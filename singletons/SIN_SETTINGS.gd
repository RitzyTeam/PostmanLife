extends Node

var work_path: String = 'user://settings.dat'

var SETTINGS : Dictionary = {
	'AUDIO': {
		
	},
	'GRAPHICS': {
		'antialiasing': 'no',
		'glow': 'no',
		'sdfgi': 'no',
		'ssao': 'no',
		'shadows': 'no',
		'resolution': '1',
	},
	'MISC': {
		
	}
}

func _ready():
	if settings_exists():
		settings_load()
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
