extends Marker3D

@export var package_box: PackedScene
@export var package_letter: PackedScene

@onready var new_task_sound = $new_task_sound


func _ready():
	SIN_WORLD_SIGNALS.PACKAGE_CREATED.connect(_package_created)

func _package_created(task_data: Dictionary) -> void:
	match task_data['id']:
		'box':
			var package = package_box.instantiate()
			add_child(package)
			package.item = task_data
			package.set_labels()
			new_task_sound.play()
		'letter':
			var package = package_letter.instantiate()
			add_child(package)
			package.item = task_data
			new_task_sound.play()
