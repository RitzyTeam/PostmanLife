extends GutTest

# ЭТОТ ТЕСТ ПРОВЕРЯЕТ, ПОЛУЧАЕТСЯ ЛИ ВЫКИНУТЬ ПРЕДМЕТ ИЗ КОНКРЕТНОГО СЛОТА ИНВЕНТАРЯ

var inv: Dictionary = {
	'slot_1': {'id': 'void'},
	'slot_2': {'id': 'void'},
	'slot_3': {'id': 'void'},
	'slot_4': {'id': 'void'}
}

var inv_expected: Dictionary = {
	'slot_1': {
		'id': 'milk',
		'name': 'Молочко',
		'weight': 1
	},
	'slot_2': {
		'id': 'milk',
		'name': 'Молочко',
		'weight': 1
	},
	'slot_3': {'id': 'void'},
	'slot_4': {
		'id': 'milk',
		'name': 'Молочко',
		'weight': 1
	},
}

var item_milk: Dictionary = {
	'id': 'milk',
	'name': 'Молочко',
	'weight': 1
}

func add_item_to_inv(item_data: Dictionary) -> bool:
	var hasFreeSlot: bool = false
	var target_slot: int = -1
	if inv['slot_4']['id'] == 'void':
		hasFreeSlot = true
		target_slot = 4
	if inv['slot_3']['id'] == 'void':
		hasFreeSlot = true
		target_slot = 3
	if inv['slot_2']['id'] == 'void':
		hasFreeSlot = true
		target_slot = 2
	if inv['slot_1']['id'] == 'void':
		hasFreeSlot = true
		target_slot = 1
	if hasFreeSlot:
		inv['slot_' + str(target_slot)] = item_data
		return true
	return false

func drop_item(slot_num: int) -> bool:
	if inv.has('slot_' + str(slot_num)):
		if not inv['slot_' + str(slot_num)] == {'id': 'void'}:
			inv['slot_' + str(slot_num)] = {'id': 'void'}
			return true
	return false



func before_all():
	add_item_to_inv(item_milk)
	add_item_to_inv(item_milk)
	add_item_to_inv(item_milk)
	add_item_to_inv(item_milk)
	drop_item(3)

func test_assert_eq_number_not_equal():
	assert_eq(inv, inv_expected, "Must pass test.")
