extends Control

export(NodePath) var points
export(NodePath) var level
export(NodePath) var level_points
export(NodePath) var quest0_image
export(NodePath) var quest0_remain
export(NodePath) var quest1_image
export(NodePath) var quest1_remain
export(NodePath) var quest2_image
export(NodePath) var quest2_remain

export(NodePath) var sample_player;

onready var PlayerData = get_tree().get_root().get_node("/root/PlayerData");
onready var xp_particles = get_node("lbl_level/pgb_upgrade/quest_particle");

func _ready():
	ui_update_value();
	PlayerData.connect("reset_data", self, "reset_quest");
	pass

func reset_quest():
	xp_particles.set_emitting(true);
	ui_update_value();

func ui_update_value():
	#print("Update UI");
	get_node(points).set_text( str( PlayerData.points ) );
	get_node(level).set_text( str( PlayerData.level ) );
	var progress = (PlayerData.level_points / PlayerData.get_next_level_points()) * 100;
	get_node(level_points).set_value( progress );
	
	get_node(quest0_image).set_frame( PlayerData.quest_type[0] );
	get_node(quest1_image).set_frame( PlayerData.quest_type[1] );
	get_node(quest2_image).set_frame( PlayerData.quest_type[2] );
	
	get_node(quest0_remain).set_text( str( PlayerData.quest_remain[0] ) );
	get_node(quest1_remain).set_text( str( PlayerData.quest_remain[1] ) );
	get_node(quest2_remain).set_text( str( PlayerData.quest_remain[2] ) );
