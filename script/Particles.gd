extends Node2D

onready var TweenNode = get_node("Tween");
var target_pos;

func _ready():
	TweenNode.interpolate_property(self, "transform/pos", get_pos(), target_pos, 1, Tween.TRANS_QUART, Tween.EASE_OUT)
	TweenNode.start()

# We use a signal to detect when the tween ends.
func _on_Tween_tween_complete( object, key ):
	queue_free();
	pass

func _on_Tween_tween_start( object, key ):
	pass # replace with function body
