extends CanvasLayer

var options_scene = preload("res://scenes/ui/options_menu.tscn")


func _ready():
	get_tree().paused = false
	MusicPlayer.play_song("menu")
	MusicPlayer.fade_in = true
	#Engine.max_fps = 24


func _on_play_button_pressed():
	MusicPlayer.stop()
	ScreenTransition.transition_to_scene("res://scenes/main/main.tscn")
	await ScreenTransition.transition_halfway
	MusicPlayer.play_song("intro")


func _on_shop_button_pressed():
	MusicPlayer.stop()
	ScreenTransition.transition_to_scene("res://scenes/ui/shop/shop.tscn")
	await ScreenTransition.transition_halfway
	MusicPlayer.play_song("shop")


func _on_options_button_pressed():
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))


func _on_quit_button_pressed():
	get_tree().quit()


func on_options_closed(options_instance: Node):
	pass#options_instance.queue_free()
