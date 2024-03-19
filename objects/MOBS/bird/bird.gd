extends CharacterBody3D


var agro_chance: int = 100
var bird_speed: float = 10
var state: String = 'idle'
var current_target: Object = null
var current_slot_item = {'id': 'void'}
var home_point: Vector3 = Vector3()
var home_point_rot: Vector3 = Vector3()

var trigger_cooldown: int = 0
# idle - bird is seating somewhere
# going_to_steal - bird is going to steal package
# follow_target - bird is following package
# stealed - bird stole package
# go_home - bird is flying
# lock - valve variable

func _ready():
	home_point = global_position
	home_point_rot = global_rotation
	$hand/letter.visible = false
	$hand/box.visible = false
	$kar_interval.wait_time = randf_range(5, 20)
	$kar_interval.start()

func _on_trigger_body_entered(body):
	if state == 'idle':
		if current_target == null:
			if trigger_cooldown == 0:
				if body is RigidBody3D:
					if body.has_method('deliver'):
						var willAgro: int = randi_range(0, 100)
						if willAgro < agro_chance:
							# BIRD TARGETS PACKAGE
							state = 'follow_target'
							current_target = body
							look_at(current_target.global_transform.origin, Vector3.UP)

func _physics_process(delta):
	if state == 'follow_target':
		go_steal()

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
							state = 'go_home'
							look_at(home_point, Vector3.UP)
							current_slot_item = body.item
							$hand/letter.visible = false
							$hand/box.visible = true
							body.queue_free()
							go_home()
						'letter':
							state = 'go_home'
							current_slot_item = body.item
							$hand/letter.visible = true
							$hand/box.visible = false
							body.queue_free()
							go_home()
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

func go_steal():
	if not current_target == null:
		look_at(Vector3(current_target.global_position.x, current_target.global_position.y, current_target.global_position.z), Vector3.UP)
		global_position = lerp(global_position, current_target.global_position, 0.01)

func go_home():
	look_at(Vector3(home_point.x, global_position.y, home_point.z), Vector3.UP)
	var tween = create_tween()
	tween.tween_property(self, 'global_position', home_point, home_point.distance_to(global_position)/bird_speed)
	tween.play()
	await tween.finished
	state = 'idle'

		
func _on_timer_timeout():
	if trigger_cooldown > 0:
		trigger_cooldown -= 1

func rotate_towards_target():
	var tween = create_tween()
	tween.tween_property(self, 'global_rotation', Vector3(), 1)
	tween.play()

func kar():
	var kar_type = int(randi_range(0,1))
	match kar_type:
		0:
			$karkalka.stream = load("res://assets/sounds/MOBS/bird/bird_1.mp3")
			var kar_longevity = randi_range(2, 5)
			for i in kar_longevity:
				$karkalka.pitch_scale = randf_range(0.8, 1.2)
				$karkalka.play()
				await $karkalka.finished
		1:
			$karkalka.stream = load("res://assets/sounds/MOBS/bird/bird_2.mp3")
			$karkalka.play()
		2:
			$karkalka.stream = load("res://assets/sounds/MOBS/bird/bird_3.mp3")
			$karkalka.play()
	$kar_interval.wait_time = randf_range(5, 20)
	$kar_interval.start()

func _on_kar_interval_timeout():
	kar()

func hurt():
	try_drop_item()
	go_home()
	state = 'go_home'
	$hurt.play()
