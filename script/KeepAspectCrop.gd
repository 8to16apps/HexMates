extends Node

onready var viewport = get_viewport()

var reference_size = Vector2(576, 1024)

func _ready():
	viewport.connect("size_changed", self, "window_resize")
	window_resize()

func window_resize():
	var current_size = OS.get_window_size()
	
	var scale_factor = reference_size.y/current_size.y
	var new_size = Vector2(current_size.x*scale_factor, reference_size.y)

	if new_size.y < reference_size.y:
		scale_factor = reference_size.y/new_size.y
		new_size = Vector2(new_size.x*scale_factor, reference_size.y)
	if new_size.x < reference_size.x:
		scale_factor = reference_size.x/new_size.x
		new_size = Vector2(reference_size.x, new_size.y*scale_factor)

	viewport.set_size_override(true, new_size)