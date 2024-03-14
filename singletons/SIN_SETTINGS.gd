extends Node

var work_path: String = 'user://settings.dat'

var SETTINGS : Dictionary = {
	'AUDIO': {
		'db_sounds': '1',
		'db_music': '1',
	},
	'GRAPHICS': {
		'antialiasing': 'no',
		'glow': 'no', # USED IN ENV NODE
		'vsync': 'no',
		'fxaa': 'no', # USED IN ENV NODE
		'taa': 'no',
		'sdfgi': 'no', # USED IN ENV NODE
		'ssao': 'no', # USED IN ENV NODE
		'shadows': 'no', # USED IN ENV NODE dir_light.light.directional_shadow_mode = 
		'frequency': 60,
		'far': 60, # USED BY ALL CAMERAS
	},
	'ADDITIONAL': {
		'fps_counter': false,
	}
}

func _ready():
	
	if settings_exists():
		settings_load()
		settings_consume()
	else:
		settings_save()
	
func settings_exists():
	return FileAccess.file_exists(work_path)

func settings_save():
	var filer = FileAccess.open(work_path,FileAccess.WRITE)
	filer.store_var(SETTINGS)
	filer.close()

func settings_load():
	var filer = FileAccess.open(work_path,FileAccess.READ)
	SETTINGS = filer.get_var()
	filer.close()

func settings_consume():
	match SETTINGS['GRAPHICS']['antialiasing']:
		'no':
			get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		'x2':
			get_viewport().msaa_3d = Viewport.MSAA_2X
		'x4':
			get_viewport().msaa_3d = Viewport.MSAA_4X
		'x8':
			get_viewport().msaa_3d = Viewport.MSAA_8X
	match SETTINGS['GRAPHICS']['vsync']:
		'no':
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		'yes':
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	match SETTINGS['GRAPHICS']['taa']:
		'no':
			get_viewport().use_taa = false
		'yes':
			get_viewport().use_taa = true
	# SET PHYSICAL FPS
	ProjectSettings.set_setting('physics/common/physics_ticks_per_second', SETTINGS['GRAPHICS']['frequency'])
