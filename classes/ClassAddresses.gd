class_name ClassAddresses

var addresses: Dictionary = {
# Delivery ID | User-friendly name
# Уникальный ID должен совпадать с ID ящика
	'aaaa1': 'улица Смольная дом 1',
}

func get_random_delivery_id():
	var a = addresses.keys()
	a = a[randi() % a.size()]
	return a
