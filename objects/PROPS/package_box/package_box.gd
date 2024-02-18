extends RigidBody3D

var deliver_id: String = ''
var characters = 'abcdefghijklmnopqrstuvwxyz'
var canBeGrabbed: bool = true
var seconds_to_deliver: int = 14
@onready var delivery_timer = $delivery_timer
@onready var timer = $timer

var item = {
	'name': 'Посылка',
	'weight': 10,
	'deliver_id': ''
}

func _ready():
	deliver_id = str(generate_word(10)) + str(int(Time.get_unix_time_from_system()))
	item.deliver_id = deliver_id

func deliver():
	if canBeGrabbed:
		SIN_WORLD_SIGNALS.emit_signal('PACKAGE_DELIVERED')
		canBeGrabbed = false
		var tween = create_tween()
		anim_deliver()
		tween.tween_property(self, 'global_rotation', Vector3(global_rotation.x, global_rotation.y + deg_to_rad(180), global_rotation.z), 1)
		tween.play()
		await tween.finished
		queue_free()

func destroy_task_failed():
	SIN_WORLD_SIGNALS.emit_signal('PACKAGE_FAILED')
	canBeGrabbed = false
	var tween = create_tween()
	tween.tween_property(self, 'scale', Vector3(0, 0, 0), 1)
	tween.play()
	await tween.finished
	queue_free()

func anim_deliver():
	var tween = create_tween()
	tween.tween_property(self, 'scale', Vector3(0, 0, 0), 1)
	tween.play()

func generate_word(length):
	var word: String
	var n_char = len(characters)
	for i in range(length):
		word += characters[randi()% n_char]
	return word

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
		
