extends Label

func _ready():
	$anim.play('show')
	
func set_content(amount: int):
	if amount < 0:
		text = str(amount) + '₽'
		add_theme_color_override('font_color', Color('ff0000'))
	else:
		text = '+' + str(amount) + '₽'
		add_theme_color_override('font_color', Color('00ff00'))
		


func _on_anim_animation_finished(anim_name):
	queue_free()
