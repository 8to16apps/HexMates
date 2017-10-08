extends HBoxContainer

export(NodePath) var power_up_0_counter
export(NodePath) var power_up_1_counter
export(NodePath) var power_up_2_counter
export(NodePath) var power_up_3_counter

export(NodePath) var sample_player;

onready var PlayerData = get_tree().get_root().get_node("/root/PlayerData");
onready var power_0 = get_node("power_up_0");
onready var power_1 = get_node("power_up_1");
onready var power_2 = get_node("power_up_2");
onready var power_3 = get_node("power_up_3");

func _ready():
	ui_update_values();
	pass

func ui_update_values():
	get_node(power_up_0_counter).set_text( str(PlayerData.power_up_counters[0]) );
	get_node(power_up_1_counter).set_text( str(PlayerData.power_up_counters[1]) );
	get_node(power_up_2_counter).set_text( str(PlayerData.power_up_counters[2]) );
	get_node(power_up_3_counter).set_text( str(PlayerData.power_up_counters[3]) );

func _on_toggled_0( pressed ):
	get_node(sample_player).play("Tikk");
	power_1.set_pressed(false);
	power_2.set_pressed(false);
	power_3.set_pressed(false);


func _on_toggled_1( pressed ):
	get_node(sample_player).play("Tikk");
	power_0.set_pressed(false);
	power_2.set_pressed(false);
	power_3.set_pressed(false);


func _on_toggled_2( pressed ):
	get_node(sample_player).play("Tikk");
	power_0.set_pressed(false);
	power_1.set_pressed(false);
	power_3.set_pressed(false);


func _on_toggled_3( pressed ):
	get_node(sample_player).play("Tikk");
	power_0.set_pressed(false);
	power_1.set_pressed(false);
	power_2.set_pressed(false);

func toggle_all_off( ):
	power_0.set_pressed(false);
	power_1.set_pressed(false);
	power_2.set_pressed(false);
	power_2.set_pressed(false);