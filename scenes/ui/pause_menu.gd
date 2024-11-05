extends CanvasLayer

var options_scene = preload("res://scenes/ui/options_menu.tscn")

var is_closing = false


func _ready():
	get_tree().paused = true


func close():
	if is_closing:
		return
	is_closing = true
	get_tree().paused = false
	queue_free()


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		get_tree().root.set_input_as_handled()
		close()


func _on_resume_button_pressed():
	close()


func _on_options_button_pressed():
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))


func on_options_closed(options_instance: Node):
	pass#options_instance.queue_free()


func _on_quit_button_pressed():
	MetaProgression.save()
	MusicPlayer.stop()
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")
