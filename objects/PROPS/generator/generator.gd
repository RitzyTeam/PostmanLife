extends RigidBody3D

var state: String = 'idle'
var item: Dictionary = {
	'fuel_inside': 10,
}

func _physics_process(delta):
	state_machine()
	if item['fuel_inside'] > 0 and state == 'idle':
		set_state_working()
	if item['fuel_inside'] == 0 and state == 'working':
		set_state_not_working()

func state_machine():
	pass

func set_state_not_working():
	$anim.stop()
	var tween = create_tween()
	tween.tween_property($axle, 'position', 1.539, 1)
	tween.play()
	state = 'idle'

func set_state_working():
	$anim.play('working')
	state = 'working'
