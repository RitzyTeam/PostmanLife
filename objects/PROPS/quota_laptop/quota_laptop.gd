extends Node3D

@onready var quota = $monitor/quota
@onready var tasks_available = $monitor/tasks_available

func _ready():
	SIN_WORLD_SIGNALS.PACKAGE_DELIVERED.connect(update_quota_data)
	SIN_WORLD_SIGNALS.PACKAGE_CREATED.connect(update_tasks_data)
	SIN_WORLD_SIGNALS.PACKAGE_FAILED.connect(update_tasks_data)
	update_quota_data('')

func update_quota_data(task_id: String):
	quota.text = 'Квота: ' + str(SIN_WORLD_DATA.WORLD_DATA['daily_quota_delivered']) + '/' + str(SIN_WORLD_DATA.WORLD_DATA['daily_quota'])
	update_tasks_data({})
	
func update_tasks_data(task_data: Dictionary):
	tasks_available.text = 'Заказов доступно: ' + str(SIN_TASK_SYSTEM.ACTIVE_TASKS.size())
