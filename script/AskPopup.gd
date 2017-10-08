extends Control

onready var PlayerData = get_tree().get_root().get_node("/root/PlayerData");
export(String, MULTILINE) var Message = "";

signal accept;

func _ready():
	get_node("Label").set_text(Message);
	hide();

func _on_btn_close_pressed():
	get_node("SamplePlayer").play("Tikk");
	hide();


func _on_btn_cancel_pressed():
	get_node("SamplePlayer").play("Tikk");
	hide();


func _on_btn_accept_pressed():
	get_node("SamplePlayer").play("Tikk");
	emit_signal("accept");
	hide();
