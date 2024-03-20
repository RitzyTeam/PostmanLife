extends StaticBody3D

@onready var generator = $".."

func interract():
	generator.isTurnedOn = not generator.isTurnedOn
	$anim_button.play('push')
