extends StaticBody3D

@export var package_box: PackedScene
@export var package_letter: PackedScene
@onready var new_task_sound = $new_task_sound

var slot_1_free: bool = true
var slot_2_free: bool = true
var slot_3_free: bool = true
var slot_4_free: bool = true
var slot_5_free: bool = true
var slot_6_free: bool = true
var slot_7_free: bool = true
var slot_8_free: bool = true
var slot_9_free: bool = true
var slot_10_free: bool = true
var slot_11_free: bool = true
var slot_12_free: bool = true

func _ready():
	SIN_WORLD_SIGNALS.PACKAGE_CREATED.connect(_package_created)

func _package_created(task_data: Dictionary) -> void:
	var slot_id: String = ''
	if slot_1_free:
		slot_id = '1'
	elif slot_2_free:
		slot_id = '2'
	elif slot_3_free:
		slot_id = '3'
	elif slot_4_free:
		slot_id = '4'
	elif slot_5_free:
		slot_id = '5'
	elif slot_6_free:
		slot_id = '6'
	elif slot_7_free:
		slot_id = '7'
	elif slot_8_free:
		slot_id = '8'
	elif slot_9_free:
		slot_id = '9'
	elif slot_10_free:
		slot_id = '10'
	elif slot_11_free:
		slot_id = '11'
	elif slot_12_free:
		slot_id = '12'
	if not slot_id == '':
		match task_data['id']:
			'box':
				var package = package_box.instantiate()
				get_node("slot_" + slot_id).add_child(package)
				package.item = task_data
				package.set_labels()
				new_task_sound.play()
			'letter':
				var package = package_letter.instantiate()
				get_node("slot_" + slot_id).add_child(package)
				package.item = task_data
				new_task_sound.play()

# SET SLOTS STATUSES
func _on_slot_1_body_entered(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_1_free = false
func _on_slot_2_body_entered(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_2_free = false
func _on_slot_3_body_entered(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_3_free = false
func _on_slot_4_body_entered(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_4_free = false
func _on_slot_5_body_entered(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_5_free = false
func _on_slot_6_body_entered(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_6_free = false
func _on_slot_7_body_entered(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_7_free = false
func _on_slot_8_body_entered(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_8_free = false
func _on_slot_9_body_entered(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_9_free = false
func _on_slot_10_body_entered(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_10_free = false
func _on_slot_11_body_entered(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_11_free = false
func _on_slot_12_body_entered(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_12_free = false

func _on_slot_1_body_exited(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_1_free = true
func _on_slot_2_body_exited(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_2_free = true
func _on_slot_3_body_exited(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_3_free = true
func _on_slot_4_body_exited(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_4_free = true
func _on_slot_5_body_exited(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_5_free = true
func _on_slot_6_body_exited(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_6_free = true
func _on_slot_7_body_exited(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_7_free = true
func _on_slot_8_body_exited(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_8_free = true
func _on_slot_9_body_exited(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_9_free = true
func _on_slot_10_body_exited(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_10_free = true
func _on_slot_11_body_exited(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_11_free = true
func _on_slot_12_body_exited(body):
	if body is RigidBody3D and body.has_method('deliver'):
		slot_12_free = true
