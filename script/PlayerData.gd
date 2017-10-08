extends Node

#Const
enum POWER_UP {
	PU_RANDOM_COLOR,
	PU_RANDOM_SHAPE,
	PU_EXPLODE,
	PU_GROW
}
#var power_up_prices = [50,50,100,200];

#Player Settings
var sfx = true;
var music = true;

#Player Data
var points = 0;
var level = 1;
var level_points = 0;
var power_up_counters = [3,3,1,1];
var quest_daytime = OS.get_unix_time();
var quest_type = [-1,-1,-1];
var quest_remain = [0,0,0];
var quest_reward = 0;

#tutorial settins
var needStartTutorial = true;
var needPowerTutorial = true;
var needVideoTutorial = true;

signal reset_data;
signal level_up;

func _ready():
	#TODO - Syncronize with Google Play Game Service
	reset_quest();
	load_game();
	pass

func get_next_level_points():
	return floor(pow(1.25, level));

func check_next_level():
	var next_level_points = get_next_level_points();
	if level_points >= next_level_points:
		level_points -= next_level_points;
		level += 1;
		emit_signal("level_up");
	pass

func check_quest():
	var remain_addition = 0;
	for i in range(3):
		remain_addition += quest_remain[i];
	
	if remain_addition == 0:
		level_points += 1;
		reset_quest();
		check_next_level();
		emit_signal("reset_data");
	pass

func reset_quest():
	var x = level - 1;
	var x_half = x/2;
	for q_number in range(3):
		quest_type[q_number] = -1;
	
	for q_number in range(3):
		randomize();
		var rnd = rand_range(0,99);
		var amount = 20 + (5 * floor(x/5));
		assert( amount != 0 );
		quest_remain[q_number] = amount;
		if rnd < (50 - x_half):
			var quest = floor(rand_range(0, 3)); #RGBY
			while( quest_type.has(quest) ):
				quest = floor(rand_range(0, 3)) #RGBY
			quest_type[q_number] = quest
		elif rnd < (100 - x):
			var quest = floor(rand_range(4, 7)); #X·O@
			while( quest_type.has(quest) ):
				quest = floor(rand_range(4, 7)); #X·O@
			quest_type[q_number] = quest
		else:
			var quest = floor(rand_range(8, 23)); #tile number
			while( quest_type.has(quest) ):
				quest = floor(rand_range(8, 23)); #tile number
			quest_type[q_number] = quest
	pass

func load_game():
	#TODO - Open file and load data
	var savegame = File.new()
	if !savegame.file_exists("user://savegame.save"):
		return #Error!  We don't have a save to load
	# Load the file line by line and process that dictionary to restore the object it represents
	var currentline = {} # dict.parse_json() requires a declared dict.
	savegame.open("user://savegame.save", File.READ)
	currentline.parse_json(savegame.get_line())

	sfx = currentline._sfx;
	music = currentline._music;

	points = currentline._points;
	level = currentline._level;
	level_points = currentline._level_points;
	power_up_counters = currentline._power_up_counters;
	quest_daytime = currentline._quest_daytime;
	quest_type = currentline._quest_type;
	quest_remain = currentline._quest_remain;
	quest_reward = currentline._quest_reward;

	needStartTutorial = currentline._needStartTutorial;
	needPowerTutorial = currentline._needPowerTutorial;
	needVideoTutorial = currentline._needVideoTutorial;

	savegame.close()
	pass

func save_game():
	#TODO - Open file and save file
	var save_dict = {
		#Player Settings
		_sfx = sfx,
		_music = music,
		#Player Data
		_points = points,
		_level = level,
		_level_points = level_points,
		_power_up_counters = power_up_counters,
		_quest_daytime = quest_daytime,
		_quest_type = quest_type,
		_quest_remain = quest_remain,
		_quest_reward = quest_reward,
		#tutorial settins
		_needStartTutorial = needStartTutorial,
		_needPowerTutorial = needPowerTutorial,
		_needVideoTutorial = needVideoTutorial
	}
	var savegame = File.new();
	savegame.open("user://savegame.save", File.WRITE);
	savegame.store_line(save_dict.to_json())
	savegame.close()
	#TODO - Sync with Google Play Game Service
	pass

func get_sfx():
	return sfx;

func toggle_sfx():
	sfx = !sfx;
	pass

func get_music():
	return music;

func toggle_music():
	music = !music;
	pass
