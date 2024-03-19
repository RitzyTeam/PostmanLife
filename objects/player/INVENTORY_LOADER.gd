extends Node

@onready var item_1_icon = $"../UI/UI/inventory/slot_1/item_icon"
@onready var item_2_icon = $"../UI/UI/inventory/slot_2/item_icon"
@onready var item_3_icon = $"../UI/UI/inventory/slot_3/item_icon"
@onready var item_4_icon = $"../UI/UI/inventory/slot_4/item_icon"



func load_inventory_visual():
	var inv: Dictionary = SIN_WORLD_DATA.WORLD_DATA['player_inv']
	for i in range(4):
		match inv['slot_' + str(i+1)].id:
			# space is free
			'void':
				get_node("../UI/UI/inventory/slot_" + str(i+1) + "/item_icon").texture = null
			'box':
				get_node("../UI/UI/inventory/slot_" + str(i+1) + "/item_icon").texture = load('res://assets/images/item_box.png')
			'letter':
				get_node("../UI/UI/inventory/slot_" + str(i+1) + "/item_icon").texture = load('res://assets/images/item_letter.png')
			'ball':
				get_node("../UI/UI/inventory/slot_" + str(i+1) + "/item_icon").texture = load('res://assets/images/item_ball.png')
			'fuel_tank':
				get_node("../UI/UI/inventory/slot_" + str(i+1) + "/item_icon").texture = load('res://assets/images/item_fuel_tank.png')
			'shotgun':
				get_node("../UI/UI/inventory/slot_" + str(i+1) + "/item_icon").texture = load('res://assets/images/item_shotgun.png')
			'shell':
				get_node("../UI/UI/inventory/slot_" + str(i+1) + "/item_icon").texture = load('res://assets/images/item_shell.png')
			'milk':
				get_node("../UI/UI/inventory/slot_" + str(i+1) + "/item_icon").texture = load('res://assets/images/item_milk.png')
			'spray_orange':
				get_node("../UI/UI/inventory/slot_" + str(i+1) + "/item_icon").texture = load('res://assets/images/item_spray.png')

func load_hand_visual(slot_id):
	$"../UI/UI/item_name".text = ''
	var inv: Dictionary = SIN_WORLD_DATA.WORLD_DATA['player_inv']
	var item = inv['slot_' + str(slot_id)]
	$"../Head/Camera/item_display/letter".visible = false
	$"../Head/Camera/item_display/box".visible = false
	$"../Head/Camera/item_display/ball".visible = false
	$"../Head/Camera/item_display/fuel_tank".visible = false
	$"../Head/Camera/item_display/shotgun".visible = false
	$"../Head/Camera/item_display/shell".visible = false
	$"../Head/Camera/item_display/milk".visible = false
	$"../Head/Camera/item_display/spray_orange".visible = false
	match item.id:
		'void': 
			$"../UI/UI/item_name".text = ''
		'letter':
			$"../Head/Camera/item_display/letter".visible = true
			$"../UI/UI/item_name".text = item['name']
		'box':
			$"../Head/Camera/item_display/box".visible = true
			$"../UI/UI/item_name".text = item['name']
		'ball':
			$"../Head/Camera/item_display/ball".visible = true
			$"../UI/UI/item_name".text = item['name']
		'fuel_tank':
			$"../Head/Camera/item_display/fuel_tank".visible = true
			$"../UI/UI/item_name".text = item['name']
		'shotgun':
			$"../Head/Camera/item_display/shotgun".visible = true
			$"../UI/UI/item_name".text = item['name']
		'shell':
			$"../Head/Camera/item_display/shell".visible = true
			$"../UI/UI/item_name".text = item['name']
		'milk':
			$"../Head/Camera/item_display/milk".visible = true
			$"../UI/UI/item_name".text = item['name']
		'spray_orange':
			$"../Head/Camera/item_display/spray_orange".visible = true
			$"../UI/UI/item_name".text = item['name']
