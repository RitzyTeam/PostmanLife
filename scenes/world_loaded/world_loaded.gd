extends Node


func _ready():
	if FileAccess.file_exists(SIN_WORLD_DATA.world_path):
		var loaded_world = load(SIN_WORLD_DATA.world_path).instantiate()
		get_tree().get_root().add_child.call_deferred(loaded_world)
		queue_free()
	else:
		get_tree().change_scene_to_file('res://scenes/main/main.tscn')
