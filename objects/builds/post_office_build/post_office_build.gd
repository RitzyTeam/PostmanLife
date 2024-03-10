extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	doors_open()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func doors_open():
	$anim_doors.play('doors_open')

func doors_close():
	$anim_doors.play('doors_close')
