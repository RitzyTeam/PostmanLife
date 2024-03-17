extends StaticBody3D


@export var deliver_code: String = ''


func try_put_package(item_data: Dictionary):
	if item_data.has('deliver_id'):
		if item_data.id == 'box':
			if deliver_code == item_data['deliver_id']:
				SIN_WORLD_SIGNALS.emit_signal('PACKAGE_DELIVERED', item_data['task_id'])
				$audio_delivered.play()
				return true
	$anim_warn.play('warn')
	return false
