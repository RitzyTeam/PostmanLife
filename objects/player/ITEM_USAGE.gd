extends Node

@onready var inventory_loader = $"../INVENTORY_LOADER"

@onready var player = $".."

# RAYCAST
@onready var raycast_hand = $"../Head/Camera/raycast_hand"

# ITEMS
# ORANGE SPRAY CAN
@onready var raycast_spray = $"../Head/Camera/raycast_spray"
@onready var spray_orange_spraying_sound = $"../Head/Camera/item_display/spray_orange/spraying_sound"
@onready var spray_orange = $"../Head/Camera/item_display/spray_orange"
@onready var spray_orange_spraying_effect = $"../Head/Camera/item_display/spray_orange/spraying_effect"
@onready var spray_orange_sound_empty = $"../Head/Camera/item_display/spray_orange/spray_empty"
# SHOTGUN
@onready var shotgun = $"../Head/Camera/item_display/shotgun"
@onready var shotgun_anim_reload = $"../Head/Camera/item_display/shotgun/anim_reload"
@onready var shotgun_anim_shot = $"../Head/Camera/item_display/shotgun/shot"
@onready var raycast_shotgun_1 = $"../Head/Camera/raycast_shotgun_1"
@onready var raycast_shotgun_2 = $"../Head/Camera/raycast_shotgun_2"
@onready var raycast_shotgun_3 = $"../Head/Camera/raycast_shotgun_3"
@onready var raycast_shotgun_4 = $"../Head/Camera/raycast_shotgun_4"
@onready var raycast_shotgun_5 = $"../Head/Camera/raycast_shotgun_5"
@onready var no_ammo = $"../Head/Camera/item_display/shotgun/no_ammo"
# MILK
@onready var milk = $"../Head/Camera/item_display/milk"
@onready var milk_anim_consume = $"../Head/Camera/item_display/milk/anim_consume"
# COFFEE CAN
@onready var coffee_can = $"../Head/Camera/item_display/coffee_can"
@onready var coffee_can_anim_consume = $"../Head/Camera/item_display/coffee_can/anim_drink_coffee_can"



func _input(event):
	if event.is_action_pressed('key_r'):
		if shotgun.visible:
			shotgun_try_reload()
	if event.is_action_pressed('lmb'):
		if shotgun.visible:
			shotgun_shoot()
		if milk.visible:
			drink_milk()
		if coffee_can.visible:
			drink_coffee()
		if spray_orange.visible:
			if not SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_'+str(player.current_slot_selected)]['paint_amount'] > 0:
				spray_orange_sound_empty.play()

func _physics_process(delta):
	# ACTIVATE ITEMS IN HAND (CONTINUOUS)
	# PAINT ORANGE
	if Input.is_action_pressed('lmb'):
		if spray_orange.visible:
			if SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_'+str(player.current_slot_selected)]['paint_amount'] > 0:
				SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_'+str(player.current_slot_selected)]['paint_amount'] -= 0.005
				spray_orange_spraying_effect.emitting = true
				if not spray_orange_spraying_sound.is_playing():
					spray_orange_spraying_sound.play()
				if raycast_spray.is_colliding() and not raycast_spray.get_collider() == null:
					var paint = load("res://objects/EFFECTS/spray_paint_orange/spray_paint_orange.tscn").instantiate()
					raycast_spray.get_collider().add_child(paint)
					paint.global_position = raycast_spray.get_collision_point()
			else:
				spray_orange_spraying_effect.emitting = false
	else:
		spray_orange_spraying_effect.emitting = false

# ============================ SERVICE FUNCS ===================================

# ===== SHOTGUN

func shotgun_try_reload():
	if not shotgun_anim_reload.is_playing():
		var isSuccessReload: bool = false
		if SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_'+str(player.current_slot_selected)]['ammo_inside'] < 5:
			if SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_1']['id'] == 'shell':
				SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_1'] = {'id': 'void'}
				isSuccessReload = true
			elif SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_2']['id'] == 'shell':
				SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_2'] = {'id': 'void'}
				isSuccessReload = true
			elif SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_3']['id'] == 'shell':
				SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_3'] = {'id': 'void'}
				isSuccessReload = true
			elif SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_4']['id'] == 'shell':
				SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_4'] = {'id': 'void'}
				isSuccessReload = true
			if isSuccessReload:
				SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_'+str(player.current_slot_selected)]['ammo_inside'] += 1
				inventory_loader.load_inventory_visual()
				shotgun_anim_reload.play('reload')

func shotgun_shoot():
	if shotgun.visible:
		if not shotgun_anim_shot.is_playing():
			if SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_'+str(player.current_slot_selected)]['ammo_inside'] > 0:
				var spread: int = 10
				raycast_shotgun_1.rotation.x = deg_to_rad(0)
				raycast_shotgun_1.rotation.y = deg_to_rad(0)
				
				raycast_shotgun_2.rotation.x = deg_to_rad(randi_range(-spread,spread))
				raycast_shotgun_2.rotation.y = deg_to_rad(randi_range(-spread,spread))
				
				raycast_shotgun_3.rotation.x = deg_to_rad(randi_range(-spread,spread))
				raycast_shotgun_3.rotation.y = deg_to_rad(randi_range(-spread,spread))
				
				raycast_shotgun_4.rotation.x = deg_to_rad(randi_range(-spread,spread))
				raycast_shotgun_4.rotation.y = deg_to_rad(randi_range(-spread,spread))
				
				raycast_shotgun_5.rotation.x = deg_to_rad(randi_range(-spread,spread))
				raycast_shotgun_5.rotation.y = deg_to_rad(randi_range(-spread,spread))
				
				SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_'+str(player.current_slot_selected)]['ammo_inside'] -= 1
				shotgun_anim_shot.play('shot')
				var sound_id: int = randi_range(1,5)
				get_node("../Head/Camera/item_display/shotgun/fire_" + str(sound_id)).play()
				for i in range(5):
					var raycast = get_node("../Head/Camera/raycast_shotgun_"+str(i+1))
					if raycast.is_colliding():
						if not raycast.get_collider() == null:
							if raycast.get_collider().has_method('hurt'):
								raycast.get_collider().hurt()
			else:
				no_ammo.play()

# ===== MILK

func drink_milk():
	player.stamina = 100.0
	milk_anim_consume.play('consume')
	await milk_anim_consume.animation_finished
	SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_'+str(player.current_slot_selected)] = {'id': 'void'}
	inventory_loader.load_inventory_visual()
	inventory_loader.load_hand_visual(player.current_slot_selected)

func drink_coffee():
	player.stamina = 100.0
	coffee_can_anim_consume.play('consume')
	await coffee_can_anim_consume.animation_finished
	SIN_WORLD_DATA.WORLD_DATA['player_inv']['slot_'+str(player.current_slot_selected)] = {'id': 'void'}
	inventory_loader.load_inventory_visual()
	inventory_loader.load_hand_visual(player.current_slot_selected)
