extends MeshInstance3D


func _ready():
	SIN_WORLD_SIGNALS.NEW_FIRING_WARN.connect(_update_text_firing_warn)
	_update_text_firing_warn()

func _update_text_firing_warn():
	$quotas_missed.text = 'Невыполненных квот: ' + str(SIN_WORLD_DATA.WORLD_DATA['firing_warns'])
