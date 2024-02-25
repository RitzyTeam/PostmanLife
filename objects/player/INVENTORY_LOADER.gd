extends Node

@onready var item_1_icon = $"../UI/UserInterface/inventory/slot_1/item_icon"
@onready var item_2_icon = $"../UI/UserInterface/inventory/slot_2/item_icon"
@onready var item_3_icon = $"../UI/UserInterface/inventory/slot_3/item_icon"
@onready var item_4_icon = $"../UI/UserInterface/inventory/slot_4/item_icon"



func load_inventory_visual():
	var inv: Dictionary = $"..".inv
	# slot 1
	match inv.slot_1.id:
		# space is free
		'void':
			item_1_icon.texture = null
		'box':
			item_1_icon.texture = load('res://assets/images/item_box.png')
		'letter':
			item_1_icon.texture = load('res://assets/images/item_letter.png')
		'ball':
			item_1_icon.texture = load('res://assets/images/item_ball.png')
	# slot 2
	match inv.slot_2.id:
		# space is free
		'void':
			item_2_icon.texture = null
		'box':
			item_2_icon.texture = load('res://assets/images/item_box.png')
		'letter':
			item_2_icon.texture = load('res://assets/images/item_letter.png')
		'ball':
			item_1_icon.texture = load('res://assets/images/item_ball.png')
	# slot 3
	match inv.slot_3.id:
		# space is free
		'void':
			item_3_icon.texture = null
		'box':
			item_3_icon.texture = load('res://assets/images/item_box.png')
		'letter':
			item_3_icon.texture = load('res://assets/images/item_letter.png')
		'ball':
			item_1_icon.texture = load('res://assets/images/item_ball.png')
	# slot 4
	match inv.slot_4.id:
		# space is free
		'void':
			item_4_icon.texture = null
		'box':
			item_4_icon.texture = load('res://assets/images/item_box.png')
		'letter':
			item_4_icon.texture = load('res://assets/images/item_letter.png')
		'ball':
			item_1_icon.texture = load('res://assets/images/item_ball.png')

func load_hand_visual(slot_id):
	$"../UI/UserInterface/item_name/item_name_anim".play('popup')
	$"../UI/UserInterface/item_name".text = ''
	var inv: Dictionary = $"..".inv
	var item = inv['slot_' + str(slot_id)]
	match item.id:
		'void': 
			$"../Head/Camera/item_display/letter".visible = false
			$"../Head/Camera/item_display/box".visible = false
			$"../Head/Camera/item_display/ball".visible = false
		'box':
			$"../Head/Camera/item_display/letter".visible = false
			$"../Head/Camera/item_display/box".visible = true
			$"../Head/Camera/item_display/ball".visible = false
			$"../UI/UserInterface/item_name".text = item['name']
		'letter':
			$"../Head/Camera/item_display/letter".visible = true
			$"../Head/Camera/item_display/box".visible = false
			$"../Head/Camera/item_display/ball".visible = false
			$"../UI/UserInterface/item_name".text = item['name']
		'ball':
			$"../Head/Camera/item_display/letter".visible = false
			$"../Head/Camera/item_display/box".visible = false
			$"../Head/Camera/item_display/ball".visible = true
			$"../UI/UserInterface/item_name".text = item['name']
