extends Node

var characters = 'abcdefghijklmnopqrstuvwxyz'
var ACTIVE_TASKS: Array = []

func _ready():
	SIN_WORLD_SIGNALS.PACKAGE_DELIVERED.connect(_package_delivered)
	SIN_WORLD_SIGNALS.PACKAGE_FAILED.connect(_package_failed)
	await get_tree().create_timer(5).timeout
	add_random_task()
	
# FUNCS
# Deliver ID должен выбираться из списка доступных Deliver ID.
# Deliver ID должен совпадать с Deliver ID для конкретного дома (Зоны приема посылки)
func add_random_task() -> void:
	var package_type_id: String = 'void'
	var package_type: int = randi_range(0,1)
	match package_type:
		0:
			package_type_id = 'box'
		1:
			package_type_id = 'letter'
	var address_lib = ClassAddresses.new()
	var deliver_id = address_lib.get_random_delivery_id()
	var target_address = address_lib.addresses[str(deliver_id)]
	var task_data: Dictionary = {
		'task_id': generate_word(10) + str(Time.get_unix_time_from_system()) + str(randi_range(10000,99999)),
		'id': package_type_id,
		'deliver_id': deliver_id,
		'target_address': target_address,
		'weight': randi_range(2, 20)
	}
	ACTIVE_TASKS.append(task_data)
	SIN_WORLD_SIGNALS.emit_signal('PACKAGE_CREATED', task_data)

func remove_task(task_id: String) -> bool:
	for i in range(ACTIVE_TASKS.size()):
		if ACTIVE_TASKS[i]['task_id'] == task_id:
			ACTIVE_TASKS.remove_at(i)
			return true
	return false

# UTILS
func generate_word(length):
	var word: String
	var n_char = len(characters)
	for i in range(length):
		word += characters[randi()% n_char]
	return word

# SIGNAL HANDLE
func _package_delivered(task_id: String):
	SIN_TASK_SYSTEM.remove_task(task_id)

func _package_failed(task_id: String):
	SIN_TASK_SYSTEM.remove_task(task_id)
