extends CharacterBody3D

var object_pool: Array = []
var rayIsOn: bool = false
var patrol_region: Array = [Vector3(-50, 20, -50), Vector3(50, 1000, 50)]
var target_place: Vector3 = Vector3()

func _ready():
	$anim.play('rotate')
	life_cycle()

func _physics_process(delta):
	if rayIsOn:
		if object_pool.size() > 0:
			for i in range(object_pool.size()):
				if not object_pool[i] == null:
					# LIFT PACKAGE
					object_pool[i].global_position.y = object_pool[i].global_position.y + 1
					# LOCK PACKAGE IN BEAM
					object_pool[i].global_position.z = lerp(object_pool[i].global_position.z, $mesh.global_transform.origin.z, 0.2)
					object_pool[i].global_position.x = lerp(object_pool[i].global_position.x, $mesh.global_transform.origin.x, 0.2)

func _on_trigger_body_entered(body):
	if rayIsOn:
		if body is RigidBody3D:
			object_pool.append(body)

func _on_trigger_body_exited(body):
	if rayIsOn:
		if object_pool.has(body):
			object_pool.erase(body)

func _on_destructor_body_entered(body):
	if not body == self:
		if body is RigidBody3D:
			if body.has_method('destroy_task_failed'):
				body.destroy_task_failed()

func ray_on():
	rayIsOn = true
	$ray/ray_anim.play('ray_on')

func ray_off():
	$ray/ray_anim.play('ray_off')
	await $ray/ray_anim.animation_finished
	rayIsOn = false
	
func life_cycle():
	ray_on()
	await get_tree().create_timer(randf_range(5.0, 10.0)).timeout
	await ray_off()
	target_place = Vector3(randi_range(patrol_region[0].x, patrol_region[1].x), randi_range(patrol_region[0].y, patrol_region[1].y), randi_range(patrol_region[0].z, patrol_region[1].z))
	var tween = create_tween()
	tween.tween_property(self, 'global_position', target_place, Vector3(global_transform.origin).distance_to(target_place)/150)
	tween.play()
	await tween.finished
	life_cycle()

