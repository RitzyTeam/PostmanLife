extends Node

func _ready():
	SIN_WORLD_SIGNALS.WORK_DAY_END.connect(_work_day_ended)
	
func _work_day_ended():
	if SIN_WORLD_DATA.WORLD_DATA['daily_quota_delivered'] < SIN_WORLD_DATA.WORLD_DATA['daily_quota']:
		SIN_WORLD_DATA.WORLD_DATA['firing_warns'] += 1
		if SIN_WORLD_DATA.WORLD_DATA['firing_warns'] > 3:
			get_tree().change_scene_to_file('res://scenes/DEATHS/death_fired/death_fired.tscn')
		
