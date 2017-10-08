extends Control

onready var PlayerData = get_tree().get_root().get_node("/root/PlayerData");
onready var SceneMng = get_tree().get_root().get_node("/root/SceneMng");
onready var AdMobNode = get_tree().get_root().get_node("/root/admob");
onready var AskPopup = get_node("AskPopup");
onready var btn_video = get_node("video");

export(NodePath) var points
export(NodePath) var power_up_0_counter
export(NodePath) var power_up_1_counter
export(NodePath) var power_up_2_counter
export(NodePath) var power_up_3_counter

export var power_up_0_price = 100;
export var power_up_1_price = 100;
export var power_up_2_price = 100;
export var power_up_3_price = 100;

export(NodePath) var buy_power_up_0;
export(NodePath) var buy_power_up_1;
export(NodePath) var buy_power_up_2;
export(NodePath) var buy_power_up_3;

export(NodePath) var buy_power_up_label_0;
export(NodePath) var buy_power_up_label_1;
export(NodePath) var buy_power_up_label_2;
export(NodePath) var buy_power_up_label_3;

func _ready():
	btn_video.set_disabled(AdMobNode.rewardLoaded);
	AdMobNode.connect("loadingVideoReward", self, "_on_loading_videoreward");
	AdMobNode.connect("enableVideoReward", self, "_on_enable_videoreward");
	AdMobNode.connect("rewardVideoReward", self, "_on_reward_videoreward");
	
	update_ui();
	
	get_node(buy_power_up_0).connect("pressed", self, "_button_pressed", [0]);
	get_node(buy_power_up_1).connect("pressed", self, "_button_pressed", [1]);
	get_node(buy_power_up_2).connect("pressed", self, "_button_pressed", [2]);
	get_node(buy_power_up_3).connect("pressed", self, "_button_pressed", [3]);
	
	AskPopup.hide();
	pass

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		if AskPopup.is_visible():
			AskPopup.hide();
		else:
			_on_back_pressed();

func update_ui():
	get_node(points).set_text( str( PlayerData.points ) );
	get_node(power_up_0_counter).set_text( str( PlayerData.power_up_counters[0] ) );
	get_node(power_up_1_counter).set_text( str( PlayerData.power_up_counters[1] ) );
	get_node(power_up_2_counter).set_text( str( PlayerData.power_up_counters[2] ) );
	get_node(power_up_3_counter).set_text( str( PlayerData.power_up_counters[3] ) );
	#Button price text
	get_node(buy_power_up_label_0).set_text( str( power_up_0_price ) );
	get_node(buy_power_up_label_1).set_text( str( power_up_1_price ) );
	get_node(buy_power_up_label_2).set_text( str( power_up_2_price ) );
	get_node(buy_power_up_label_3).set_text( str( power_up_3_price ) );
	pass

func _button_pressed(index):
	get_node("SamplePlayer").play("Tikk");
	if index == PlayerData.POWER_UP.PU_RANDOM_COLOR:
		if PlayerData.points > power_up_0_price:
			PlayerData.points -= power_up_0_price;
			PlayerData.power_up_counters[0] += 1;
			update_ui();
		else:
			_on_video_reward();
	elif index == PlayerData.POWER_UP.PU_RANDOM_SHAPE:
		if PlayerData.points > power_up_1_price:
			PlayerData.points -= power_up_1_price;
			PlayerData.power_up_counters[1] += 1;
			update_ui();
		else:
			_on_video_reward();
	elif index == PlayerData.POWER_UP.PU_EXPLODE:
		if PlayerData.points > power_up_2_price:
			PlayerData.points -= power_up_2_price;
			PlayerData.power_up_counters[2] += 1;
			update_ui();
		else:
			_on_video_reward();
	elif index == PlayerData.POWER_UP.PU_GROW:
		if PlayerData.points > power_up_3_price:
			PlayerData.points -= power_up_3_price;
			PlayerData.power_up_counters[3] += 1;
			update_ui();
		else:
			_on_video_reward();
	pass

func _on_video_reward():
	get_node("SamplePlayer").play("Tikk");
	AskPopup.show();

func _on_back_pressed():
	get_node("SamplePlayer").play("Tikk");
	#SceneMng.goto_scene("res://stage/GameRoot.tscn");
	SceneMng.pop_scene();
	pass

func _on_AskPopup_accept():
	#Show video reward
	AdMobNode.showVideoReward();
	pass

func _on_loading_videoreward():
	btn_video.set_disabled(true);

func _on_enable_videoreward():
	btn_video.set_disabled(false);

func _on_reward_videoreward():
	PlayerData.points += 200; #if completed else 0;
	update_ui();
