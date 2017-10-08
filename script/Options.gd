extends ColorFrame

onready var PlayerData = get_tree().get_root().get_node("/root/PlayerData");
onready var SceneMng = get_tree().get_root().get_node("/root/SceneMng");

export var show_exit_button = false;

signal toggle_sfx;
signal toggle_music;

func _ready():
	if not show_exit_button: 
		get_node("Background/btn_exit").hide();
	hide();
	get_node("Background/hb_audio/tgl_audio").set_pressed( PlayerData.sfx );
	get_node("Background/hb_audio/tgl_music").set_pressed( PlayerData.music );
	pass

func _on_btn_close_pressed():
	get_node("SamplePlayer").play("Tikk");
	hide();
	pass # replace with function body


func _on_tgl_audio_pressed():
	get_node("SamplePlayer").play("Tikk");
	PlayerData.sfx = !PlayerData.sfx;
	emit_signal("toggle_sfx");
	pass # replace with function body


func _on_tgl_music_pressed():
	get_node("SamplePlayer").play("Tikk");
	PlayerData.music = !PlayerData.music;
	emit_signal("toggle_music");
	pass # replace with function body


func _on_btn_more_pressed():
	get_node("SamplePlayer").play("Tikk");
	OS.shell_open("https://play.google.com/store/apps/developer?id=8+to+16+Apps");

func _on_btn_exit_pressed():
	get_node("SamplePlayer").play("Tikk");
	PlayerData.save_game();
	get_tree().quit();
	pass # replace with function body
