extends Node

#region Переменные
@onready var anim = $anim

# LAYERS OF SETTINGS
@onready var panel_audio = $UI/bg/visibility_changer/content/settings/panel_audio
@onready var panel_graphics = $UI/bg/visibility_changer/content/settings/panel_graphics
@onready var panel_additional = $UI/bg/visibility_changer/content/settings/panel_additional
@onready var panel_feedback = $UI/bg/visibility_changer/content/settings/panel_additional/margin/smoother/ad_box/panel_feedback

# SETTINGS

# GRAPHICAL SETTINGS UI
# ALIASING
@onready var alias_no = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_aliasing/options/alias_no
@onready var alias_x_2 = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_aliasing/options/alias_x2
@onready var alias_x_4 = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_aliasing/options/alias_x4
@onready var alias_x_8 = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_aliasing/options/alias_x8
# GLOW
@onready var glow_btn = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_glow/glowBtn
# VSYNC
@onready var vsync_btn = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_vsync/vsyncBtn
# FXAA
@onready var fxaa_btn = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_fxaa/fxaaBtn
# TAA
@onready var taa_btn = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_taa/taaBtn
# SDFGI
@onready var sdfgi_btn = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_sdfgi/sdfgiBtn
#SSAO
@onready var ssao_btn = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_ssao/ssaoBtn
# SHADOWS
@onready var no_shadows = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_shadows/options/no_shadows
@onready var bad_shadows = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_shadows/options/bad_shadows
@onready var mid_shadows = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_shadows/options/mid_shadows
@onready var good_shadows = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_shadows/options/good_shadows
# FREQ
@onready var freq_slider = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_frequency/options/frequency
@onready var freq_value = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_frequency/options/value
# FAR
@onready var far_slider = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_far/options/far
@onready var far_value = $UI/bg/visibility_changer/content/settings/panel_graphics/margin/smoother/gr_box/item_far/options/value

# AUDIO SETTINGS UI
@onready var db_sounds = $UI/bg/visibility_changer/content/settings/panel_audio/margin/smoother/au_box/item_sounds/options/db_sounds
@onready var db_sounds_value = $UI/bg/visibility_changer/content/settings/panel_audio/margin/smoother/au_box/item_sounds/options/db_sounds_value
@onready var db_music = $UI/bg/visibility_changer/content/settings/panel_audio/margin/smoother/au_box/item_music/options/db_music
@onready var db_music_value = $UI/bg/visibility_changer/content/settings/panel_audio/margin/smoother/au_box/item_music/options/db_music_value

# ADDITIONAL SETTINGS UI
# FPS COUNTER
@onready var counter_btn = $UI/bg/visibility_changer/content/settings/panel_additional/margin/smoother/ad_box/item_fps_counter/counterBtn
# FEEDBACK
@onready var wright = $UI/bg/visibility_changer/content/settings/panel_additional/margin/smoother/ad_box/item_feedback/wright
@onready var feedback_data = $UI/bg/visibility_changer/content/settings/panel_additional/margin/smoother/ad_box/panel_feedback/margin/feedback_fields/feedbackData
@onready var feedback_text = $UI/bg/visibility_changer/content/settings/panel_additional/margin/smoother/ad_box/panel_feedback/margin/feedback_fields/feedbackText
@onready var discard = $UI/bg/visibility_changer/content/settings/panel_additional/margin/smoother/ad_box/panel_feedback/margin/feedback_fields/btns/discard
@onready var send = $UI/bg/visibility_changer/content/settings/panel_additional/margin/smoother/ad_box/panel_feedback/margin/feedback_fields/btns/send
@onready var notification = $UI/bg/visibility_changer/content/settings/panel_additional/margin/smoother/ad_box/panel_feedback/notification
@onready var text_notif = $UI/bg/visibility_changer/content/settings/panel_additional/margin/smoother/ad_box/panel_feedback/notification/textNotif
#endregion


func _ready():
	anim.play("show")
	set_base_page()
	SIN_SETTINGS.settings_save() # SAVE CURRENT SETTINGS FOR BACKUP
	load_settings()

func _on_btn_exit_pressed():
	SIN_SETTINGS.settings_save()
	SIN_SETTINGS.settings_consume()
	
	anim.play("hide")


func _on_anim_animation_finished(anim_name):
	if anim_name == 'hide':
		get_tree().change_scene_to_file('res://scenes/main/main.tscn')
	elif anim_name == 'notification':
		notification.visible = false

# SWAP LAYERS OF SETTINGS

func set_base_page():
	panel_audio.visible = true
	panel_graphics.visible = false
	panel_additional.visible = false
	panel_feedback.visible = false
	notification.visible = false

func _on_btn_audio_pressed():
	panel_audio.visible = true
	panel_graphics.visible = false
	panel_additional.visible = false
	panel_feedback.visible = false

func _on_btn_graphics_pressed():
	panel_audio.visible = false
	panel_graphics.visible = true
	panel_additional.visible = false
	panel_feedback.visible = false

func _on_btn_additional_pressed():
	panel_audio.visible = false
	panel_graphics.visible = false
	panel_additional.visible = true
	panel_feedback.visible = false

# LOAD SETTINGS VISUALLY FROM FILE

func load_settings():
	
	# LOAD AUDIO SETTINGS
	db_sounds.value = float(SIN_SETTINGS.SETTINGS['AUDIO']['db_sounds'])
	db_music.value = float(SIN_SETTINGS.SETTINGS['AUDIO']['db_music'])
	if db_sounds.value > 0:
		db_sounds_value.text = '+' + str(db_sounds.value)
	else:
		db_sounds_value.text = str(db_sounds.value)
	
	if db_music.value > 0:
		db_music_value.text = '+' + str(db_music.value)
	else:
		db_music_value.text = str(db_music.value)
	
	# LOAD GRAPHICAL SETTINGS
	freq_slider.value = SIN_SETTINGS.SETTINGS['GRAPHICS']['frequency']
	freq_value.text = str(SIN_SETTINGS.SETTINGS['GRAPHICS']['frequency']) +'Гц'
	
	far_slider.value = SIN_SETTINGS.SETTINGS['GRAPHICS']['far']
	far_value.text = str(SIN_SETTINGS.SETTINGS['GRAPHICS']['far']) +'м'
	
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['antialiasing']:
		'no':
			alias_no.button_pressed = true
			alias_x_2.button_pressed = false
			alias_x_4.button_pressed = false
			alias_x_8.button_pressed = false
		'x2':
			alias_no.button_pressed = false
			alias_x_2.button_pressed = true
			alias_x_4.button_pressed = false
			alias_x_8.button_pressed = false
		'x4':
			alias_no.button_pressed = false
			alias_x_2.button_pressed = false
			alias_x_4.button_pressed = true
			alias_x_8.button_pressed = false
		'x8':
			alias_no.button_pressed = false
			alias_x_2.button_pressed = false
			alias_x_4.button_pressed = false
			alias_x_8.button_pressed = true
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['glow']:
		'no':
			glow_btn.button_pressed = false
		'yes':
			glow_btn.button_pressed = true
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['vsync']:
		'no':
			vsync_btn.button_pressed = false
		'yes':
			vsync_btn.button_pressed = true
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['fxaa']:
		'no':
			fxaa_btn.button_pressed = false
		'yes':
			fxaa_btn.button_pressed = true
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['taa']:
		'no':
			taa_btn.button_pressed = false
		'yes':
			taa_btn.button_pressed = true
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['sdfgi']:
		'no':
			sdfgi_btn.button_pressed = false
		'yes':
			sdfgi_btn.button_pressed = true
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['ssao']:
		'no':
			ssao_btn.button_pressed = false
		'yes':
			ssao_btn.button_pressed = true
	match SIN_SETTINGS.SETTINGS['GRAPHICS']['shadows']:
		'no':
			no_shadows.button_pressed = true
			bad_shadows.button_pressed = false
			mid_shadows.button_pressed = false
			good_shadows.button_pressed = false
		'bad':
			no_shadows.button_pressed = false
			bad_shadows.button_pressed = true
			mid_shadows.button_pressed = false
			good_shadows.button_pressed = false
		'mid':
			no_shadows.button_pressed = false
			bad_shadows.button_pressed = false
			mid_shadows.button_pressed = true
			good_shadows.button_pressed = false
		'good':
			no_shadows.button_pressed = false
			bad_shadows.button_pressed = false
			mid_shadows.button_pressed = false
			good_shadows.button_pressed = true
	
	# LOAD ADDITIONAL SETTINGS
	match SIN_SETTINGS.SETTINGS['ADDITIONAL']['fps_counter']:
		true:
			counter_btn.button_pressed = true
		false:
			counter_btn.button_pressed = false
	
	# LOAD MISC SETTINGS

#region Графика
# GRAPHICS - ALIASING PICK

func _on_alias_no_pressed():
	alias_no.button_pressed = true
	alias_x_2.button_pressed = false
	alias_x_4.button_pressed = false
	alias_x_8.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['antialiasing'] = 'no'
func _on_alias_x_2_pressed():
	alias_no.button_pressed = false
	alias_x_2.button_pressed = true
	alias_x_4.button_pressed = false
	alias_x_8.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['antialiasing'] = 'x2'
func _on_alias_x_4_pressed():
	alias_no.button_pressed = false
	alias_x_2.button_pressed = false
	alias_x_4.button_pressed = true
	alias_x_8.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['antialiasing'] = 'x4'
func _on_alias_x_8_pressed():
	alias_no.button_pressed = false
	alias_x_2.button_pressed = false
	alias_x_4.button_pressed = false
	alias_x_8.button_pressed = true
	SIN_SETTINGS.SETTINGS['GRAPHICS']['antialiasing'] = 'x8'

# GRAPHICS - GLOW PICK

func _on_glow_btn_pressed():
	if glow_btn.button_pressed:
		SIN_SETTINGS.SETTINGS['GRAPHICS']['glow'] = 'yes'
	else:
		SIN_SETTINGS.SETTINGS['GRAPHICS']['glow'] = 'no'

# GRAPHICS - VSYNC PICK

func _on_vsync_btn_pressed():
	if vsync_btn.button_pressed:
		SIN_SETTINGS.SETTINGS['GRAPHICS']['vsync'] = 'yes'
	else:
		SIN_SETTINGS.SETTINGS['GRAPHICS']['vsync'] = 'no'

# GRAPHICS - FXAA PICK

func _on_fxaa_btn_pressed():
	if fxaa_btn.button_pressed:
		SIN_SETTINGS.SETTINGS['GRAPHICS']['fxaa'] = 'yes'
	else:
		SIN_SETTINGS.SETTINGS['GRAPHICS']['fxaa'] = 'no'

# GRAPHICS - TAA PICK

func _on_taa_btn_pressed():
	if taa_btn.button_pressed:
		SIN_SETTINGS.SETTINGS['GRAPHICS']['taa'] = 'yes'
	else:
		SIN_SETTINGS.SETTINGS['GRAPHICS']['taa'] = 'no'

# GRAPHICS - SDFGI PICK

func _on_sdfgi_btn_pressed():
	if sdfgi_btn.button_pressed:
		SIN_SETTINGS.SETTINGS['GRAPHICS']['sdfgi'] = 'yes'
	else:
		SIN_SETTINGS.SETTINGS['GRAPHICS']['sdfgi'] = 'no'

# GRAPHICS - SSAO PICK

func _on_ssao_btn_pressed():
	if ssao_btn.button_pressed:
		SIN_SETTINGS.SETTINGS['GRAPHICS']['ssao'] = 'yes'
	else:
		SIN_SETTINGS.SETTINGS['GRAPHICS']['ssao'] = 'no'

# GRAPHICS - SHADOWS PICK

func _on_no_shadows_pressed():
	no_shadows.button_pressed = true
	bad_shadows.button_pressed = false
	mid_shadows.button_pressed = false
	good_shadows.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['shadows'] = 'no'
func _on_bad_shadows_pressed():
	no_shadows.button_pressed = false
	bad_shadows.button_pressed = true
	mid_shadows.button_pressed = false
	good_shadows.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['shadows'] = 'bad'
func _on_mid_shadows_pressed():
	no_shadows.button_pressed = false
	bad_shadows.button_pressed = false
	mid_shadows.button_pressed = true
	good_shadows.button_pressed = false
	SIN_SETTINGS.SETTINGS['GRAPHICS']['shadows'] = 'mid'
func _on_good_shadows_pressed():
	no_shadows.button_pressed = false
	bad_shadows.button_pressed = false
	mid_shadows.button_pressed = false
	good_shadows.button_pressed = true
	SIN_SETTINGS.SETTINGS['GRAPHICS']['shadows'] = 'good'

# GRAPHICS - FREQUENCY PICK

func _on_frequency_value_changed(value):
	freq_value.text = str(value) + 'Гц'
	SIN_SETTINGS.SETTINGS['GRAPHICS']['frequency'] = value

# GRAPHICS - FAR PICK

func _on_far_value_changed(value):
	far_value.text = str(value) + 'м'
	SIN_SETTINGS.SETTINGS['GRAPHICS']['far'] = value

#endregion

#region Аудио
# AUDIO - SOUND DB PICK

func _on_db_sounds_value_changed(value):
	SIN_SETTINGS.SETTINGS['AUDIO']['db_sounds'] = str(value)
	if value > 0:
		db_sounds_value.text = '+' + str(value)
	else:
		db_sounds_value.text = str(value)

# AUDIO - MUSIC DB PICK

func _on_db_music_value_changed(value):
	SIN_SETTINGS.SETTINGS['AUDIO']['db_music'] = str(value)
	if value > 0:
		db_music_value.text = '+' + str(value)
	else:
		db_music_value.text = str(value)

#endregion

#region Дополнительно
# ADDITIONAL - FPS COUNTER

func _on_counter_btn_pressed():
	if counter_btn.button_pressed:
		SIN_SETTINGS.SETTINGS['ADDITIONAL']['fps_counter'] = true
	else:
		SIN_SETTINGS.SETTINGS['ADDITIONAL']['fps_counter'] = false

# ADDITIONAL - FEEDBACK

func _on_wright_pressed():
	panel_feedback.visible = true

func _on_discard_pressed():
	panel_feedback.visible = false
	feedback_data.text = ""
	feedback_text.text = ""

func _on_send_pressed():
	if feedback_text.text == "":
		notification.visible = true
		text_notif.text = "Для отправки введите сообщение"
		anim.play("notification")
		return
	
	var clearText : String = ""
	
	for i in range(feedback_text.text.length()):
		if feedback_text.text[i] == "\n":
			clearText += "%0A"
			continue
		clearText += feedback_text.text[i]
	
	var TEXT: String = clearText
	
	if feedback_data.text != "":
		TEXT += "%0A%0A" + "Обратная связь: " + feedback_data.text
	
	notification.visible = true
	text_notif.text = "Отправка сообщения..."
	
	var BOT_TOKEN: String = '7036911249:AAG-neJ7ceo8s9UjFg9q72bBULlxDeROJso'
	var CHAT_ID: String = '-1002004740868'
	
	var http = HTTPRequest.new()
	var url = "https://api.telegram.org/bot" + BOT_TOKEN + "/sendMessage?message_thread_id=265&chat_id=" + CHAT_ID + "&text=" + TEXT
	add_child(http)
	http.request(url, [], HTTPClient.METHOD_GET)
	
	var resp = await http.request_completed
	
	if resp[1] == 200:
		feedback_data.text = ""
		feedback_text.text = ""
		
		text_notif.text = "Сообщение успешно отправлено"
	else:
		text_notif.text = "Ошибка отправки сообщения: " + str(resp[1])
		print(url)
	
	anim.play("notification")

#endregion


# -------------------- ПРИСОЕДИНЕННЫЕ --------------------

