extends MeshInstance3D

@onready var task_1 = $task_1
@onready var task_2 = $task_2
@onready var task_3 = $task_3
@onready var task_4 = $task_4
@onready var task_5 = $task_5
@onready var task_6 = $task_6
@onready var task_7 = $task_7
@onready var task_8 = $task_8
@onready var task_9 = $task_9
@onready var task_10 = $task_10
@onready var task_11 = $task_11
@onready var task_12 = $task_12


func _physics_process(delta):
	# ACTIVE TASKS
	$active_tasks.text = 'Задач активно: ' + str(SIN_TASK_SYSTEM.ACTIVE_TASKS.size())
	# TASK LIST
	$tasks.text = ''
	for i in range(SIN_TASK_SYSTEM.ACTIVE_TASKS.size()):
		$tasks.text += SIN_TASK_SYSTEM.ACTIVE_TASKS[i]['name'] + '\n'
