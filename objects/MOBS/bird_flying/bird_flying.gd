extends CharacterBody3D

func _ready():
	$anim.play('fly')

func activate():
	global_rotation.y = deg_to_rad(randi_range(0, 359))
	var target_pos = global_transform.basis.x * 1000
	look_at(target_pos, Vector3.UP)
	var tween = create_tween()
	tween.tween_property(self, 'global_position', target_pos, randi_range(200, 1000))
	tween.play()
	await tween.finished
	return true
