extends Node3D

@onready var between_picks = $between_picks
@onready var scream_delay = $scream_delay


func _ready():
	SIN_WORLD_SIGNALS.WORK_DAY_START.connect(scream)
	reset_pick_timer()

func reset_pick_timer():
	between_picks.wait_time = randi_range(5, 10)
	between_picks.start()

func _on_between_picks_timeout():
	$anim.play('pick')

func _on_anim_animation_finished(anim_name):
	reset_pick_timer()

func scream():
	scream_delay.wait_time = randi_range(5, 20)
	scream_delay.start()
	


func _on_scream_delay_timeout():
	var scream_id: int = randi_range(0, 3)
	match scream_id:
		0:
			$scream_1.pitch_scale = randf_range(0.9, 1.1)
			$scream_1.play()
		1:
			$scream_2.pitch_scale = randf_range(0.9, 1.1)
			$scream_2.play()
		2:
			$scream_3.pitch_scale = randf_range(0.9, 1.1)
			$scream_3.play()
		3:
			$scream_4.pitch_scale = randf_range(0.9, 1.1)
			$scream_4.play()
