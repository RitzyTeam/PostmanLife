extends Marker3D

@export var package_box: PackedScene
@export var package_letter: PackedScene

func _ready():
	SIN_WORLD_SIGNALS.PACKAGE_CREATED.connect(_package_created)

func _package_created(task_data: Dictionary) -> void:
	match task_data['id']:
		'box':
			var package = package_box.instantiate()
			add_child(package)
			package.item = task_data
			package.set_labels()
		'letter':
			var package = package_letter.instantiate()
			add_child(package)
			package.item = task_data
