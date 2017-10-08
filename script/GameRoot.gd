#GameRoot.gd

extends Control

onready var OptionsPopup = get_node("Options");
onready var AskPopup = get_node("AskPopup");
onready var PowerPopup = get_node("PowerPopup");
onready var PlayerData = get_tree().get_root().get_node("/root/PlayerData");
onready var SceneMng = get_tree().get_root().get_node("/root/SceneMng");
onready var MusicNode = get_tree().get_root().get_node("/root/MusicNode");
onready var AdMobNode = get_tree().get_root().get_node("/root/admob");

onready var top_controls = get_node("top_controls");
onready var btn_controls = get_node("btn_controls");
onready var btn_video = get_node("top_controls/lbl_points/Add");

onready var particles = preload("../scenes/Particles.tscn");

onready var level_up_particles = get_node("top_controls/lbl_level/level_up");

var tutorial_idx = 0;
var tutorial_text = [
	"TUTO1",
	"TUTO2",
	"TUTO3",
	"TUTO4",
	];

func _ready():
	get_tree().set_auto_accept_quit(false);
	OptionsPopup.hide();
	AskPopup.hide();
	PlayerData.connect("level_up", self, "_on_playerdata_level_up");
	_on_Options_toggle_music();
	btn_video.set_disabled(AdMobNode.rewardLoaded);
	AdMobNode.connect("loadingVideoReward", self, "_on_loading_videoreward");
	AdMobNode.connect("enableVideoReward", self, "_on_enable_videoreward");
	AdMobNode.connect("rewardVideoReward", self, "_on_reward_videoreward");
	pass

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		if(OptionsPopup.is_visible()):
			OptionsPopup.hide();
		elif(AskPopup.is_visible()):
			AskPopup.hide();
		elif(PowerPopup.is_visible()):
			PowerPopup.hide();
		else:
			PlayerData.save_game();
			get_tree().quit() # default behavior

func update_gui():
	top_controls.ui_update_value();
	btn_controls.ui_update_values();
	pass

func _on_btn_pause_pressed():
	OptionsPopup.show();
	get_node("SamplePlayer").play("Tikk");
	pass

func _on_Market_pressed():
	get_node("SamplePlayer").play("Tikk");
	#SceneMng.goto_scene("res://stage/Market.tscn");
	SceneMng.push_scene("res://stage/Market.tscn");
	pass

func _on_Add_pressed():
	get_node("SamplePlayer").play("Tikk");
	AskPopup.show();

func _on_AskPopup_accept():
	#Show video reward
	AdMobNode.showVideoReward();

func _on_PowerPopup_accept():
	_on_Market_pressed();
	pass # replace with function body


func _on_Timer_timeout():
	get_node("lbl_title").set_text( tr(tutorial_text[tutorial_idx]));
	tutorial_idx = (tutorial_idx + 1)%tutorial_text.size();


func _on_Options_toggle_music():
	if PlayerData.music:
		MusicNode.play();
	else:
		MusicNode.stop();
	pass # replace with function body

func _on_playerdata_level_up():
	get_node("SamplePlayer").play("Loaded");
	level_up_particles.set_emitting(true);


func _on_Options_toggle_sfx():
	if PlayerData.sfx:
		AudioServer.set_fx_global_volume_scale(1);
	else:
		AudioServer.set_fx_global_volume_scale(0);
	pass # replace with function body

func _on_loading_videoreward():
	btn_video.set_disabled(true);

func _on_enable_videoreward():
	btn_video.set_disabled(false);

func _on_reward_videoreward():
	PlayerData.points += 200; #if completed else 0;
	update_gui();
