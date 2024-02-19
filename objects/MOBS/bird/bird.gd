extends AnimatableBody3D


var agro_chance: int = 100
var bird_speed: float = 0.01
var state: String = 'idle'
var current_target: Object = null
var current_slot_item = {'id': 'void'}
var home_point: Vector3 = Vector3()

var trigger_cooldown: int = 0
# idle - bird is seating somewhere
# agro - bird is going to steal package
# stealed - bird stole package
# flying - bird is flying
# lock - valve variable

func _ready():
	home_point = global_position
	$hand/letter.visible = false
	$hand/box.visible = false

func _on_trigger_body_entered(body):
	if state == 'idle':
		if trigger_cooldown == 0:
			if body is RigidBody3D:
				if body.has_method('deliver'):
					var willAgro: int = randi_range(0, 100)
					if willAgro < agro_chance:
						# BIRD TARGETS PACKAGE
						state = 'agro'
						current_target = body

func _physics_process(delta):
	state_machine()

func _on_grab_zone_body_entered(body):
	# ONLY PACKAGES
	if 'item' in body and body.has_method('deliver') and body is RigidBody3D:
		if trigger_cooldown == 0:
			var item = body.item
			# IF BIRD'S SLOT IS FREE
			if current_slot_item == {'id': 'void'}:
				if not item.id == null:
					match item.id:
						'box':
							state = 'stealed'
							current_slot_item = body.item
							$hand/letter.visible = false
							$hand/box.visible = true
							body.queue_free()
						'letter':
							state = 'stealed'
							current_slot_item = body.item
							$hand/letter.visible = true
							$hand/box.visible = false
							body.queue_free()
						_:
							pass

func try_drop_item():
	var drop_success: bool = false
	if not current_slot_item == {'id': 'void'}:
		match current_slot_item.id:
			'box':
				var obj = load('res://objects/PROPS/package_box/package_box.tscn').instantiate()
				get_tree().get_root().add_child(obj)
				trigger_cooldown = 20
				obj.global_position = $hand.global_position
				obj.global_rotation = $hand.global_rotation
				obj.item = current_slot_item
				current_slot_item = {'id': 'void'}
				drop_success = true
			'letter':
				var obj = load('res://objects/PROPS/package_letter/package_letter.tscn').instantiate()
				get_tree().get_root().add_child(obj)
				trigger_cooldown = 20
				obj.global_position = $hand.global_position
				obj.global_rotation = $hand.global_rotation
				obj.item = current_slot_item
				current_slot_item = {'id': 'void'}
				drop_success = true
	if drop_success:
		current_target = null
		$hand/letter.visible = false
		$hand/box.visible = false

func state_machine():
	match state:
		'idle':
			pass
		'agro':
			if not current_target == null:
				look_at(current_target.global_position, Vector3.UP)
				global_position = lerp(global_position, current_target.global_position, bird_speed)
			else:
				state = 'stealed'
		'stealed':
			if home_point.distance_to(global_position) < 5:
				state = 'idle'
				if not current_slot_item == {'id': 'void'}:
					try_drop_item()
			else:
				look_at(home_point, Vector3.UP)
				global_position = lerp(global_position, home_point, bird_speed)
		'flying':
			pass


func _on_timer_timeout():
	if trigger_cooldown > 0:
		trigger_cooldown -= 1
