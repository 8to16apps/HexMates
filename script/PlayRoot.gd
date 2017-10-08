#PlayRoot.gd

extends Control

onready var PlayerData = get_tree().get_root().get_node("/root/PlayerData");
onready var hexTile = preload("res://scenes/HexTile.tscn");
onready var gridOrigin = get_node("GridOrigin");
onready var gameRoot = get_node("..");

var player_move = [];

var power_up_mode = -1;

func _ready():
	for y in range(7):
		for x in range(6 - y%2):
			var hex_instance = hexTile.instance();
			gridOrigin.add_child( hex_instance );
			hex_instance.set_tile_pos( x, y );
			hex_instance.set_name(str(x) + "x" + str(y));
			hex_instance.connect("pressed", self, "_on_tile_pressed");
			hex_instance.connect("released", self, "_on_tile_released");
			hex_instance.connect("enter", self, "_on_tile_enter");
	pass

func reset_game():
	for hex_instance in gridOrigin.get_children():
		hex_instance.reset_tile();
	pass

func _on_tile_pressed(tile_instance):
	#print("Pressed " + str(tile_instance.tile_x) + ":" + str(tile_instance.tile_y) + ":" + str(tile_instance.tile_type));
	if power_up_mode == -1:
		if player_move.find(tile_instance) == -1: #Check in the move
			tile_instance._tile.show();
			player_move.push_back(tile_instance);
	else:
		#power_up_mode
		gameRoot.btn_controls.toggle_all_off();
		if PlayerData.power_up_counters[power_up_mode] < 1:
			get_node("../PowerPopup").show();
			return;
		
		var tiles = [];
		if tile_instance.tile_y%2 == 0: #odd row
			var tile_name0 = str(tile_instance.tile_x) + "x" + str(tile_instance.tile_y - 1);
			if(gridOrigin.has_node(tile_name0)): tiles.append( gridOrigin.get_node(tile_name0));
			var tile_name1 = str(tile_instance.tile_x - 1) + "x" + str(tile_instance.tile_y - 1);
			if(gridOrigin.has_node(tile_name1)): tiles.append( gridOrigin.get_node(tile_name1));
			
			var tile_name2 = str(tile_instance.tile_x - 1) + "x" + str(tile_instance.tile_y);
			if(gridOrigin.has_node(tile_name2)): tiles.append( gridOrigin.get_node(tile_name2));
			var tile_name3 = str(tile_instance.tile_x) + "x" + str(tile_instance.tile_y);
			if(gridOrigin.has_node(tile_name3)): tiles.append( gridOrigin.get_node(tile_name3));
			var tile_name4 = str(tile_instance.tile_x + 1) + "x" + str(tile_instance.tile_y);
			if(gridOrigin.has_node(tile_name4)): tiles.append( gridOrigin.get_node(tile_name4));
			
			var tile_name5 = str(tile_instance.tile_x) + "x" + str(tile_instance.tile_y + 1);
			if(gridOrigin.has_node(tile_name5)): tiles.append( gridOrigin.get_node(tile_name5));
			var tile_name6 = str(tile_instance.tile_x - 1) + "x" + str(tile_instance.tile_y + 1);
			if(gridOrigin.has_node(tile_name6)): tiles.append( gridOrigin.get_node(tile_name6));
		else: #even row
			var tile_name0 = str(tile_instance.tile_x) + "x" + str(tile_instance.tile_y - 1);
			if(gridOrigin.has_node(tile_name0)): tiles.append( gridOrigin.get_node(tile_name0));
			var tile_name1 = str(tile_instance.tile_x + 1) + "x" + str(tile_instance.tile_y - 1);
			if(gridOrigin.has_node(tile_name1)): tiles.append( gridOrigin.get_node(tile_name1));
			
			var tile_name2 = str(tile_instance.tile_x - 1) + "x" + str(tile_instance.tile_y);
			if(gridOrigin.has_node(tile_name2)): tiles.append( gridOrigin.get_node(tile_name2));
			var tile_name3 = str(tile_instance.tile_x) + "x" + str(tile_instance.tile_y);
			if(gridOrigin.has_node(tile_name3)): tiles.append( gridOrigin.get_node(tile_name3));
			var tile_name4 = str(tile_instance.tile_x + 1) + "x" + str(tile_instance.tile_y);
			if(gridOrigin.has_node(tile_name4)): tiles.append( gridOrigin.get_node(tile_name4));
			
			var tile_name5 = str(tile_instance.tile_x) + "x" + str(tile_instance.tile_y + 1);
			if(gridOrigin.has_node(tile_name5)): tiles.append( gridOrigin.get_node(tile_name5));
			var tile_name6 = str(tile_instance.tile_x + 1) + "x" + str(tile_instance.tile_y + 1);
			if(gridOrigin.has_node(tile_name6)): tiles.append( gridOrigin.get_node(tile_name6));
		
		for instance in tiles:
			instance.apply_power_up(power_up_mode);
		
		if power_up_mode == PlayerData.POWER_UP.PU_RANDOM_COLOR:
			get_node("../SamplePlayer").play("openWind");
		elif power_up_mode == PlayerData.POWER_UP.PU_RANDOM_SHAPE:
			get_node("../SamplePlayer").play("openWind");
		elif power_up_mode == PlayerData.POWER_UP.PU_EXPLODE:
			get_node("../SamplePlayer").play("SpriteEx");
		elif power_up_mode == PlayerData.POWER_UP.PU_GROW:
			get_node("../SamplePlayer").play("PowerUp");
		
		PlayerData.power_up_counters[power_up_mode] -= 1;
		power_up_mode = -1;
		gameRoot.btn_controls.ui_update_values();



func _on_tile_released(tile_instance):
	#print("Released " + str(tile_instance.tile_x) + ":" + str(tile_instance.tile_y) + ":" + str(tile_instance.tile_type));
	_on_area_exit();

func _on_tile_enter(tile_instance):
	#print("Enter " + str(tile_instance.tile_x) + ":" + str(tile_instance.tile_y) + ":" + str(tile_instance.tile_type));
	if player_move.empty():
		return;
	
	if player_move.find(tile_instance) != -1: #Check in the move
		if player_move.size() >= 2: #the move has two previous tiles
			var pre_back = player_move[ player_move.size() - 2 ]; #Check is pre-back (back move)
			if pre_back == tile_instance:
				player_move.back()._tile.hide();
				player_move.pop_back();
		return;
	
	var insert_tile = false;
	var last_tile = player_move.back();
	if last_tile.tile_y%2 == 0: #even row
		if last_tile.tile_y - tile_instance.tile_y == 0 and abs(last_tile.tile_x - tile_instance.tile_x) <= 1:
			insert_tile = true;
		if (last_tile.tile_y - tile_instance.tile_y == 1 or last_tile.tile_y - tile_instance.tile_y == -1) and (last_tile.tile_x - tile_instance.tile_x == 0 or last_tile.tile_x - tile_instance.tile_x == 1):
			insert_tile = true;
	else: #odd row
		if last_tile.tile_y - tile_instance.tile_y == 0 and abs(last_tile.tile_x - tile_instance.tile_x) <= 1:
			insert_tile = true;
		if (last_tile.tile_y - tile_instance.tile_y == 1 or last_tile.tile_y - tile_instance.tile_y == -1) and (last_tile.tile_x - tile_instance.tile_x == 0 or last_tile.tile_x - tile_instance.tile_x == -1):
			insert_tile = true;
	var last_tile_type = last_tile.tile_type;
	var last_color = int(last_tile_type)%4;
	var last_symbol = floor(int(last_tile_type)/4);
	
	var this_tile_type = tile_instance.tile_type;
	var this_color = int(this_tile_type)%4;
	var this_symbol = floor(int(this_tile_type)/4);
	if (last_color == this_color or last_symbol == this_symbol) and insert_tile : #Check valid move (same color || same simbol)
		tile_instance._tile.show();
		player_move.push_back(tile_instance); #insert in the move
	pass

func _on_power_up_0_toggled( pressed ):	
	if pressed:
		power_up_mode = PlayerData.POWER_UP.PU_RANDOM_COLOR;
	pass # replace with function body


func _on_power_up_1_toggled( pressed ):
	if pressed:
		power_up_mode = PlayerData.POWER_UP.PU_RANDOM_SHAPE;
	pass # replace with function body


func _on_power_up_2_toggled( pressed ):
	if pressed:
		power_up_mode = PlayerData.POWER_UP.PU_EXPLODE;
	pass # replace with function body


func _on_power_up_3_toggled( pressed ):
	if pressed:
		power_up_mode = PlayerData.POWER_UP.PU_GROW;
	pass # replace with function body

func _on_area_exit():
	if player_move.size() > 2:
		PlayerData.points += player_move.size() - 2;
		for instance in player_move:
			instance.used();
		get_node("../SamplePlayer").play("pop");
	else:
		for instance in player_move:
			instance._tile.hide();
	player_move.clear();
	PlayerData.check_quest();
	get_node("..").update_gui();
	pass
