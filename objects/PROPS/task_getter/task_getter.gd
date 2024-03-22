extends StaticBody3D

@onready var anim = $anim

func interract():
	if not anim.is_playing():
		if not SIN_TASK_SYSTEM.ACTIVE_TASKS.size() > 11:
			anim.play('push_button')
			SIN_TASK_SYSTEM.add_random_task()
