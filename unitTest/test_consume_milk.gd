extends GutTest

# ЭТОТ ТЕСТ ПРОВЕРЯЕТ ПРИМЕНЕНИЕ МОЛОКА И ВЛИЯНИЕ ВЕСА ИНВЕНТАРЯ НА СТАМИНУ ИГРОКА

var stamina: float = 100.0
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

var result: Dictionary = {}
var expected_result: Dictionary = {
	'payload': 0,
	'stamina': 87.0
}

func run_for_seconds(seconds):
	stamina -= (seconds * 10.0) + ((seconds * calculate_weight()) / 2.0)
	gut.p('Stamina: ' + str(stamina))
	if stamina < 0.0:
		stamina = 0.0
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
func consume(slot_id: int) -> bool:
	if inv.has('slot_' + str(slot_id)):
		match inv['slot_' + str(slot_id)]['id']:
			'void':
				return false
			'milk':
				stamina += 50.0
				inv['slot_' + str(slot_id)] = {'id': 'void'}
				return true
			_:
				return false
	return false
func calculate_weight() -> int:
	var result_weight: int = 0
	for i in range(inv.size()):
		if not inv['slot_' + str(i+1)] == {'id': 'void'}:
			result_weight += inv['slot_' + str(i+1)]['weight']
	return result_weight
func fix_result():
	result = {
		'payload': int(calculate_weight()),
		'stamina': float(stamina)
	}

# ПОСЛЕДОВАТЕЛЬНОСТЬ ДЕЙСТВИЙ ПРИ ТЕСТИРОВАНИИ:
func before_all():
	add_item_to_inv(item_milk) # ПОЛОЖИЛИ МОЛОКО
	run_for_seconds(6) # БЕЖИМ 6 СЕКУНД
	consume(1) # ПЬЕМ МОЛОКО ИЗ ПЕРВОГО СЛОТА (ВОССТАНАВЛИВАЕТ 50 СТАМИНЫ)
	fix_result() # ФИКСИРУЕМ РЕЗУЛЬТАТ ПЕРЕД СРАВНИВАНИЕМ



func test_assert_eq_number_not_equal():
	assert_eq(result, expected_result, "")
