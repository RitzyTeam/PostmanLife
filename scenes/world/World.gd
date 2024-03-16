extends Node

var saved_world: Array = []

func _ready():
	SIN_WORLD_SIGNALS.WORK_DAY_END.connect(_work_day_ended)
	SIN_WORLD_SIGNALS.WORK_DAY_START.connect(_work_day_started)
	SIN_WORLD_SIGNALS.WORLD_SAVE.connect(world_save)
	world_load()

func _work_day_ended():
	if SIN_WORLD_DATA.WORLD_DATA['daily_quota_delivered'] < SIN_WORLD_DATA.WORLD_DATA['daily_quota']:
		SIN_WORLD_DATA.WORLD_DATA['firing_warns'] += 1
		if SIN_WORLD_DATA.WORLD_DATA['firing_warns'] > 3:
			SIN_WORLD_DATA.last_death_reason = 'fired'
			get_tree().change_scene_to_file.bind("res://scenes/death/death.tscn").call_deferred()

func _work_day_started():
	SIN_WORLD_DATA.new_quota()

# WORLD SAVING/LOADING FEAUTURES

func world_save():
	var converted_data: Array = []
	var important_objs: Array = get_tree().get_nodes_in_group('save_this')
	for i in range(important_objs.size()):
		if 'item' in important_objs[i]:
			var item = important_objs[i].item
			item['global_position'] = important_objs[i].global_position
			item['global_rotation'] = important_objs[i].global_rotation
			converted_data.append(item)
	SIN_WORLD_DATA.WORLD_DATA['world'] = converted_data
	SIN_WORLD_DATA.data_save()

func world_load():
	var converted_data: Array = SIN_WORLD_DATA.WORLD_DATA['world']
	if converted_data.size() > 0:
		var previous_objects: Array = get_tree().get_nodes_in_group('save_this')
		for i in range(previous_objects.size()):
			previous_objects[i].queue_free()
		for i in range(converted_data.size()):
			var obj: Object = null
			match converted_data[i]['id']:
				'box':
					obj = load("res://objects/PROPS/package_box/package_box.tscn").instantiate()
				'letter':
					obj = load("res://objects/PROPS/package_letter/package_letter.tscn").instantiate()
				'fuel_tank':
					obj = load("res://objects/PROPS/fuel_tank/fuel_tank.tscn").instantiate()
				'player':
					obj = load("res://objects/player/player.tscn").instantiate()
				'car':
					obj = load("res://objects/TRANSPORT/car/car.tscn").instantiate()
			call_deferred_thread_group('set_object', obj, converted_data[i])

func set_object(obj: Object, converted_data: Dictionary):
	get_tree().get_root().add_child(obj)
	obj.global_position = converted_data['global_position']
	obj.global_rotation = converted_data['global_rotation']
	obj.item = converted_data
