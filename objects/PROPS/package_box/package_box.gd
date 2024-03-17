extends RigidBody3D


var canBeGrabbed: bool = true
var seconds_to_deliver: int = 90
@onready var delivery_timer = $delivery_timer
@onready var timer = $timer

var item = {}

func set_labels():
	# SET LABELS
	$street_name.text = item.target_address
	$weight.text = str(item.weight) + 'кг'
	# FILL TYPES
	if item['fill_type'] == 'based':
		$package_type_glass.visible = false
		$package_type_eco.visible = false
		$package_type_water.visible = false
	elif item['fill_type'] == 'food':
		$package_type_glass.visible = false
		$package_type_eco.visible = true
		$package_type_water.visible = false
	elif item['fill_type'] == 'docs':
		$package_type_glass.visible = false
		$package_type_eco.visible = false
		$package_type_water.visible = true
	elif item['fill_type'] == 'glass':
		$package_type_glass.visible = true
		$package_type_eco.visible = false
		$package_type_water.visible = false

func deliver():
	if canBeGrabbed:
		canBeGrabbed = false
	var tween = create_tween()
	anim_deliver()
	tween.tween_property(self, 'global_rotation', Vector3(global_rotation.x, global_rotation.y + deg_to_rad(180), global_rotation.z), 1)
	tween.play()
	await tween.finished
	SIN_WORLD_SIGNALS.emit_signal('PACKAGE_DELIVERED', item['task_id'])
	queue_free()

func destroy_task_failed():
	if canBeGrabbed:
		canBeGrabbed = false
	var tween = create_tween()
	tween.tween_property(self, 'scale', Vector3(0, 0, 0), 1)
	tween.play()
	await tween.finished
	SIN_WORLD_SIGNALS.emit_signal('PACKAGE_FAILED', item['task_id'])
	queue_free()

func anim_deliver():
	var tween = create_tween()
	tween.tween_property(self, 'scale', Vector3(0, 0, 0), 1)
	tween.play()

func grab():
	return item

func _on_delivery_timer_timeout():
	if seconds_to_deliver > 0:
		seconds_to_deliver -= 1
	else:
		destroy_task_failed()
	var minutes: int = int(seconds_to_deliver / 60)
	var seconds: int = seconds_to_deliver % 60
	var minutes_display: String = ''
	var seconds_display: String = ''
	if minutes < 10:
		minutes_display = '0' + str(minutes)
	else:
		minutes_display = str(minutes)
	if seconds < 10:
		seconds_display = '0' + str(seconds)
	else:
		seconds_display = str(seconds)
	timer.text = str(minutes_display) + ':' + str(seconds_display)
