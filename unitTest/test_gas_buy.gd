extends GutTest

# ЭТОТ ТЕСТ ПРОВЕРЯЕТ ВОЗМОЖНОСТЬ ПОКУПКИ ТОПЛИВА ДЛЯ ГРУЗОВИКА

var petrol_left: int = 1000
var petrol_price: int = 1
# HOW MUCH CAN YOU BUY FOR A ONE CANISTER
var buy_amount: int = 20
var player_money: int = 100

func test_assert_eq_number_not_equal():
	assert_eq(buy_petrol(), true, "Must pass test.")

func buy_petrol():
	var isSuccess: bool = false
	var amountBought: int = 0
	if petrol_left >= buy_amount:
		var petrol_price: int = buy_amount * petrol_price
		if player_money >= petrol_price:
			player_money -= petrol_price
			isSuccess = true
			amountBought = buy_amount
			petrol_left -= buy_amount
	else:
		if petrol_left > 0:
			if player_money >= petrol_price:
				isSuccess = true
				amountBought = petrol_left
				player_money -= petrol_price
				petrol_left = 0
	gut.p(isSuccess)
	return isSuccess
