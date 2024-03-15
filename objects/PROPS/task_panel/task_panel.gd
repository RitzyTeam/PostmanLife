extends MeshInstance3D

func _physics_process(delta):
	# ACTIVE TASKS
	$active_tasks.text = 'Задач активно: ' + str(SIN_TASK_SYSTEM.ACTIVE_TASKS.size())
	# TASK LIST
	$tasks.text = ''
	for i in range(SIN_TASK_SYSTEM.ACTIVE_TASKS.size()):
		$tasks.text += SIN_TASK_SYSTEM.ACTIVE_TASKS[i]['name'] + '\n'
