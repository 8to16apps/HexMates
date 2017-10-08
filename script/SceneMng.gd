extends Node

var current_scene = null
var top_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	top_scene = root.get_child( root.get_child_count() -1 )

func goto_scene(path):
	call_deferred("_deferred_goto_scene",path)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene( current_scene )

func push_scene(path):
	call_deferred("_deferred_push_scene",path)

func pop_scene():
	call_deferred("_deferred_pop_scene")

func _deferred_push_scene(path):
	var s = ResourceLoader.load(path)
	top_scene = s.instance()
	get_tree().get_root().add_child(top_scene)
	get_tree().set_current_scene( top_scene )

func _deferred_pop_scene():
	var root = get_tree().get_root()
	top_scene.free()
	top_scene = root.get_child( root.get_child_count() -1 )
	get_tree().set_current_scene( top_scene )
