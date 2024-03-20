extends RigidBody3D

var current_tank: Object = null
var max_fuel_inside: float = 200.0
var item: Dictionary = {
	'fuel_inside': 10.0,
	'temperature_inside': 0.0
}
var isTurnedOn: bool = false


func _physics_process(delta):
	state_machine()
	# IF TANK IS ATTACHED
	if not current_tank == null:
		if item.fuel_inside < max_fuel_inside:
			if current_tank.item['litres'] >= 0.02:
				item.fuel_inside += 0.02
				current_tank.item['litres'] -= 0.02
				current_tank.item['weight'] = int(current_tank.item['litres'])
			else:
				current_tank.freeze = false
				current_tank = null
		else:
			current_tank.freeze = false
			current_tank = null

func state_machine():
	if isTurnedOn:
		$terminal/pad/fuel_inside.text = 'Топливо: ' + str(int(item['fuel_inside'])) + 'л.'
		$terminal/pad/temperature_inside.text = 'Температура: ' + str(int(item['temperature_inside'])) + 'ц.'
		if item['fuel_inside'] >= 0.01:
			item['fuel_inside'] -= 0.01
			item['temperature_inside'] += 0.01
			set_state_working()
		else:
			set_state_not_working()
	else:
		set_state_not_working()
		if item['temperature_inside'] > 0:
			item['temperature_inside'] -= 0.02
		
	
func set_state_not_working():
	$anim.play('no_fuel')
	$work_particles.emitting = false

func set_state_working():
	$anim.play('working')
	$work_particles.emitting = true


func _on_area_body_entered(body):
	if body is RigidBody3D:
		if 'item' in body:
			if body.has_method('grab'):
				if body.item.has('litres'):
					if body.item['litres'] > 0:
						if item.fuel_inside < max_fuel_inside:
							if current_tank == null:
								linear_velocity.x = 0
								linear_velocity.z = 0
								current_tank = body
								body.freeze = true
								rotate_tank()
								var tween = create_tween()
								tween.tween_property(current_tank, 'global_position', $fuel_hole.global_position, 1)
								tween.play()

func rotate_tank():
	var tween = create_tween()
	tween.tween_property(current_tank, 'global_rotation', $fuel_hole.global_rotation, 1)
	tween.play()

func _on_area_body_exited(body):
	if body is RigidBody3D:
		if 'item' in body:
			if body.has_method('grab'):
				if body.item.has('litres'):
					body.freeze = false
