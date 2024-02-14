extends Area3D

var packages_ids_to_receive: Array = []



func _on_body_entered(body):
	if body is RigidBody3D and body.has_method('deliver'):
		# ЕСЛИ ИМЕННО ПОСЫЛКА ПОПАЛА В РАДИУС
		for i in range(packages_ids_to_receive.size()):
			if packages_ids_to_receive[i] == str(body.deliver_id):
				# ПОПАВШАЯ В РАДИУС ПОСЫЛКА КОРРЕКТНО ДОСТАВЛЕНА. ВЫЗЫВАЕМ ЕЁ МЕТОД.
				body.deliver()
