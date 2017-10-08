# HexTile Script

extends Area2D

# Hexagon characteristics
#    ^
#   /  \
#  /    \
# |      | .
# |      | h
# |      | .
#  \     /.
#   \   / s
#     v   .
#     . r .

const r = 48;
const h = 28;
const s = 54;

var tile_x;
var tile_y;
var tile_type;
var reloading = false;

onready var tile = get_node("tile");
onready var _tile = get_node("marker");
onready var timer = get_node("Timer");
onready var PlayerData = get_tree().get_root().get_node("/root/PlayerData");
onready var GameRoot = get_tree().get_root().get_node("/root/GameRoot");
onready var particles = preload("../scenes/Particles.tscn");

signal pressed(tile_instance);
signal enter(tile_instance);
signal released(tile_instance);
signal exit(tile_instance);

func _ready():
	reset_tile();
	pass

func reset_tile():
	randomize();
	tile_type = randi()%16;
	tile.set_frame( tile_type );
	_tile.hide();
	pass

func used():
	var quest_type_color = floor(int(tile_type)%4); #RGBY
	var quest_index = PlayerData.quest_type.find(quest_type_color);
	if(quest_index > -1 and PlayerData.quest_remain[quest_index] > 0):
		PlayerData.quest_remain[quest_index] -= 1;
		create_quest_particles();
	
	var quest_type_shape = floor(tile_type/4) + 4; #X·O@
	quest_index = PlayerData.quest_type.find(quest_type_shape);
	if(quest_index > -1 and PlayerData.quest_remain[quest_index] > 0):
		PlayerData.quest_remain[quest_index] -= 1;
		create_quest_particles();
	
	var quest_type_tile = floor(tile_type + 8); #tiles
	quest_index = PlayerData.quest_type.find(quest_type_tile);
	if(quest_index > -1 and PlayerData.quest_remain[quest_index] > 0):
		PlayerData.quest_remain[quest_index] -= 1;
		create_quest_particles();
	reload();

func create_quest_particles():
	#print("Creting Particles");
	var instance = particles.instance();
	var pos = Vector2( get_global_pos().x + get_item_rect().size.width/2, get_global_pos().y + get_item_rect().size.height/2);
	instance.set_pos( pos );
	instance.target_pos = Vector2(483, 234);
	GameRoot.add_child(instance);

func reload():
	reloading = true;
	timer.start();
	randomize();
	tile_type = randi()%16;
	tile.set_frame(22); #hide
	_tile.hide();
	get_node("Particles2D").set_emitting(true);
	pass

func grow():
	tile.set_frame( tile_type );
	reloading = false;
	timer.stop();
	pass;

func explode():
	reload();
	pass

func randomize_color():
	var new_color = randi()%4; #RGBY
	var old_shape = floor(tile_type/4); #X·O@
	tile_type = (old_shape * 4) + new_color;
	tile.set_frame( tile_type );
	pass

func randomize_shape():
	var old_color = int(tile_type)%4; #RGBY
	var new_shape = randi()%4; #X·O@
	tile_type = (new_shape * 4) + old_color;
	tile.set_frame( tile_type );
	pass

func apply_power_up(power_up_type):
	if power_up_type == PlayerData.POWER_UP.PU_RANDOM_COLOR:
		randomize_color();
	elif power_up_type == PlayerData.POWER_UP.PU_RANDOM_SHAPE:
		randomize_shape();
	elif power_up_type == PlayerData.POWER_UP.PU_EXPLODE:
		explode();
	elif power_up_type == PlayerData.POWER_UP.PU_GROW:
		grow();

func set_tile_pos(x, y):
	tile_x = x; tile_y = y;
	set_pos( Vector2( (x * 2 * r) + ( (y % 2) * r), y * (h + s) ) );

func _on_input_event( viewport, event, shape_idx ):
	#if reloading: return;
	if event.is_action_pressed("Clicked") :
		emit_signal("pressed", self);
	elif event.is_action_released("Clicked"):
		emit_signal("released", self);
	pass

func _on_mouse_enter():
	if reloading: return;
	emit_signal("enter", self);
	pass

func _on_Timer_timeout():
	var current_frame = tile.get_frame();
	if current_frame == 22:
		tile.set_frame(20);
	elif current_frame == 20:
		tile.set_frame(21);
	elif current_frame == 21:
		var color = int(tile_type)%4;
		tile.set_frame( 16 + color );
	else:
		tile.set_frame( tile_type );
		reloading = false;
		timer.stop();
	pass


func _on_HexTile_mouse_exit():
	if reloading: return;
	emit_signal("exit", self);
	pass
