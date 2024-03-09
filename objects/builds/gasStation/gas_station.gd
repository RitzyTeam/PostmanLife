extends Node3D

@export var petrol_canister: PackedScene

@onready var info_station_1 = $petrol_station_1/info
@onready var info_station_2 = $petrol_station_2/info
@onready var info_station_3 = $petrol_station_3/info
@onready var info_station_4 = $petrol_station_4/info


var petrol_station_1: int = 0
var petrol_station_2: int = 0
var petrol_station_3: int = 0
var petrol_station_4: int = 0

var petrol_price_station_1: int = 0
var petrol_price_station_2: int = 0
var petrol_price_station_3: int = 0
var petrol_price_station_4: int = 0

func _ready():
	update_petrol()

func update_petrol():
	randomize()
	petrol_station_1 = randi_range(100, 1000)
	petrol_station_2 = randf_range(100, 1000)
	petrol_station_3 = randi_range(100, 1000)
	petrol_station_4 = randi_range(100, 1000)
	
	petrol_price_station_1 = randi_range(1, 6)
	petrol_price_station_2 = randi_range(1, 6)
	petrol_price_station_3 = randi_range(1, 6)
	petrol_price_station_4 = randi_range(1, 6)
	update_petrol_info()

func update_petrol_info():
	info_station_1.text = '''Станция №1
	Запас: ''' + str(petrol_station_1) + '''л.
	Цена: ''' + str(petrol_price_station_1) + 'р за 1л'
	info_station_2.text = '''Станция №2
	Запас: ''' + str(petrol_station_2) + '''л.
	Цена: ''' + str(petrol_price_station_2) + 'р за 1л'
	info_station_3.text = '''Станция №3
	Запас: ''' + str(petrol_station_3) + '''л.
	Цена: ''' + str(petrol_price_station_3) + 'р за 1л'
	info_station_4.text = '''Станция №4
	Запас: ''' + str(petrol_station_4) + '''л.
	Цена: ''' + str(petrol_price_station_4) + 'р за 1л'
