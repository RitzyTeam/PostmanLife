extends CharacterBody3D

func _ready():
	SIN_WORLD_SIGNALS.TOD_DAY_ENDED.connect(ufo_show)

func ufo_show():
	if SIN_WORLD_DATA.WORLD_DATA['day_num'] % 10 == 0:
		$anim_appearance.play('show')
		$anim.play('rotate')
		await $anim_appearance.animation_finished
		$giant_ufo_alert.play()
		$giant_ufo_ambience.play()
		
		await $giant_ufo_alert.finished
		
		$anim_appearance.play('hide')
		await $anim_appearance.animation_finished
		$giant_ufo_ambience.stop()
		$giant_ufo_alert.stop()
		$anim.stop()
