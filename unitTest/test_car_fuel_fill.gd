extends GutTest

# ЭТОТ ТЕСТ ПРОВЕРЯЕТ ЗАПРАВКУ МАШИНЫ ТОПЛИВОМ

var car: Dictionary = {
	'id': 'car',
	'res_fuel': 20.0,
	'res_fuel_max': 20.0,
	'isPlayerInside': false
}

var item_fuel_tank: Dictionary = {
	'id': 'fuel_tank',
	'name': 'Канистра бензина',
	'litres': 5.0,
	'weight': 20.0
}

func car_drive_for_seconds(secs: int):
	car['res_fuel'] -= secs * 0.2
	if car['res_fuel'] < 0.0:
		car['res_fuel'] = 0.0

func car_fuel_up():
	var need_fuel = car['res_fuel_max'] - car['res_fuel']
	if item_fuel_tank['litres'] >= need_fuel:
		car['res_fuel'] += need_fuel
		item_fuel_tank['litres'] -= need_fuel

func before_all():
	car_drive_for_seconds(100) # Катаемся на машинке ровно 100 секунд и тратим всё топливо
	car_fuel_up() # Заправляем машину топливом насколько это возможно
	
func test_assert_eq_number_not_equal():
	assert_eq(item_fuel_tank['litres'], 5.0, "")
