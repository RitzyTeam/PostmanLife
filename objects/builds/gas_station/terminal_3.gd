extends StaticBody3D

@onready var gas_station = $".."
@onready var place_to_spawn = $place_to_spawn
# HOW MUCH CAN YOU BUY FOR A ONE CANISTER
var buy_amount: int = 20

func buy_petrol():
	var isSuccess: bool = false
	var amountBought: int = 0
	var petrol_left: int = gas_station.petrol_station_3
	if petrol_left >= buy_amount:
		var petrol_price: int = buy_amount * gas_station.petrol_price_station_3
		if SIN_WORLD_DATA.WORLD_DATA['money'] >= petrol_price:
			SIN_WORLD_DATA.WORLD_DATA['money'] -= petrol_price
			SIN_WORLD_SIGNALS.emit_signal('PLAYER_UI_CASH_UPDATE')
			isSuccess = true
			amountBought = buy_amount
			gas_station.petrol_station_3 -= buy_amount
	else:
		if petrol_left > 0:
			var petrol_price: int = gas_station.petrol_station_3 * gas_station.petrol_price_station_3
			if SIN_WORLD_DATA.WORLD_DATA['money'] >= petrol_price:
				isSuccess = true
				amountBought = gas_station.petrol_station_3
				SIN_WORLD_DATA.WORLD_DATA['money'] -= petrol_price
				SIN_WORLD_SIGNALS.emit_signal('PLAYER_UI_CASH_UPDATE')
				gas_station.petrol_station_3 = 0
	if isSuccess:
		var petrol_canister = gas_station.petrol_canister.instantiate()
		get_tree().get_root().add_child(petrol_canister)
		petrol_canister.item.litres = amountBought
		petrol_canister.global_position = place_to_spawn.global_position
		petrol_canister.global_rotation = place_to_spawn.global_rotation
		gas_station.update_petrol_info()
