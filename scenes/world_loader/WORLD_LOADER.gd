extends Node

var progress = []
var sceneName = "res://scenes/world/World.tscn"
var scene_load_status = 0
var tips = ["Двигайте ногами, чтобы ходить", 
			"Если вокруг темно - попробуйте открыть глаза",
			"Как правило, днем светлее, чем ночью",
			"Мы не доставляем ничего запрещенного!",
			"В городе у всех есть шапки-невидимки",
			"В багажник машины можно класть вещи",
			"Не забывайте посылки",
			"Мы вдохновлялись своим вдохновением",
			"В среднем разработчику требуется 5,7 литров кофе в день"
]


func _ready():
	ResourceLoader.load_threaded_request(sceneName)
	$UI/bg/loading_phrase.text = tips.pick_random()


func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName, progress)
	if $UI/bg/loading_progress.value < int(progress[0]*100):
		$UI/bg/loading_progress.value = int(progress[0]*100)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		$anim.play('go_world')


func _on_anim_animation_finished(anim_name):
	var world_scene = ResourceLoader.load_threaded_get(sceneName)
	get_tree().change_scene_to_packed(world_scene)
