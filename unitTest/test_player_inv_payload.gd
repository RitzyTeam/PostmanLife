extends GutTest

# ЭТОТ ТЕСТ ПРОВЕРЯЕТ, КАКИМ ОБРАЗОМ СЧИТАЕТСЯ ВЕС ИНВЕНТАРЯ

var weight_expected: int = 3

var inv: Dictionary = {
	'slot_1': {'id': 'void'},
	'slot_2': {'id': 'void'},
	'slot_3': {'id': 'void'},
	'slot_4': {'id': 'void'}
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

func calculate_weight() -> int:
	var result_weight: int = 0
	for i in range(inv.size()):
		if not inv['slot_' + str(i+1)] == {'id': 'void'}:
			result_weight += inv['slot_' + str(i+1)]['weight']
	return result_weight

func before_all():
	add_item_to_inv(item_milk)
	add_item_to_inv(item_milk)
	add_item_to_inv(item_milk)

func test_assert_eq_number_not_equal():
	assert_eq(calculate_weight(), weight_expected, "Must pass test.")
