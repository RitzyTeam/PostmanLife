extends StaticBody3D

@onready var generator = $".."

func interract():
	if not $anim_button.is_playing():
		generator.isTurnedOn = not generator.isTurnedOn
		if generator.isTurnedOn:
			$anim_button.play('turn_on')
		else:
			$anim_button.play('turn_off')
			
		
		
