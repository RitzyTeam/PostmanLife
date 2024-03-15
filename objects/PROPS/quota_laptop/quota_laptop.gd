extends Node3D

@onready var quota = $monitor/quota

func _on_timer_timeout():
	update_quota_data()

func update_quota_data():
	quota.text = 'Квота: ' + str(SIN_WORLD_DATA.WORLD_DATA['daily_quota_delivered']) + '/' + str(SIN_WORLD_DATA.WORLD_DATA['daily_quota'])


