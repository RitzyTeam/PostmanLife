extends Node

var work_path: String = 'user://save.dat'
var world_path: String = 'user://world.tscn'

var WORLD_DATA_EMPTY: Dictionary = {
	'money': 0, # MONEY OF PLAYER
	'player_inv': {
		'slot_1': {'id': 'void'},
		'slot_2': {'id': 'void'},
		'slot_3': {'id': 'void'},
		'slot_4': {'id': 'void'}
		}, # INVENTORY
	'tod': 540, # TIME OF DAY IN SECONDS
	'day_num': 1, # NUM OF DAYS PASSED
	'daily_quota': 1, # AMOUNT OF PACKAGES TO DELIVER
	'daily_quota_delivered': 0,
	'firing_warns': 0,
	# BUFFS & DEBUFFS
	'player_insane': false,
}

var WORLD_DATA: Dictionary = {
	'money': 0,
	'player_inv': {
		'slot_1': {'id': 'void'},
		'slot_2': {'id': 'void'},
		'slot_3': {'id': 'void'},
		'slot_4': {'id': 'void'}
		},
	'tod': 540,
	'day_num': 1,
	'daily_quota': 1,
	'daily_quota_delivered': 0,
	'firing_warns': 0,
	'player_insane': false,
}

func _ready():
	if data_exists():
		data_load()
	else:
		data_reset()

# MAIN FUNCS

func data_reset():
	var filer = FileAccess.open(work_path, FileAccess.WRITE)
	filer.store_var(WORLD_DATA_EMPTY)
	filer.close()
	data_save()

func data_load() -> bool:
	if data_exists():
		var filer = FileAccess.open(work_path, FileAccess.READ)
		WORLD_DATA = filer.get_var()
		filer.close()
		return true
	return false

func data_save():
	var filer = FileAccess.open(work_path, FileAccess.WRITE)
	filer.store_var(WORLD_DATA)
	filer.close()

func data_is_empty() -> bool:
	if data_exists():
		if data_load():
			if WORLD_DATA == WORLD_DATA_EMPTY:
				return true
			else:
				return false
		else:
			return true
	return true

func data_exists() -> bool:
	return FileAccess.file_exists(work_path)

# VALUE CHANGERS

func value_change_money(money_to_add: int) -> void:
	WORLD_DATA['money'] += money_to_add
	SIN_WORLD_SIGNALS.emit_signal('PLAYER_UI_CASH_UPDATE', money_to_add)

func value_tod_changed(new_tod: int):
	WORLD_DATA['tod'] = new_tod

func value_day_passed():
	WORLD_DATA['day_num'] += 1

func new_quota():
	randomize()
	WORLD_DATA['daily_quota'] += randi_range(1, 3)

func add_delivered_to_quota_counter():
	if SIN_WORLD_DATA.WORLD_DATA['tod'] >= 540 and SIN_WORLD_DATA.WORLD_DATA['tod'] <= 1080:
		SIN_WORLD_DATA.WORLD_DATA['daily_quota_delivered'] += 1
	
func isQuotaReached():
	return WORLD_DATA['daily_quota'] == WORLD_DATA['daily_quota_delivered']
