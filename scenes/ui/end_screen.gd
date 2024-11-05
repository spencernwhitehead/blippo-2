extends CanvasLayer

var defeat = false


func _ready():
	get_tree().paused = true
	%PanelContainer.modulate = Color.TRANSPARENT
	

func set_defeat():
	%TitleLabel.text = "you lost"
	%DescriptionLabel.text = "ya dingus"
	defeat = true


func _on_restart_button_pressed():
	get_tree().paused = false
	MusicPlayer.play()
	ScreenTransition.transition_to_scene("res://scenes/main/main.tscn")


func _on_quit_button_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")


func _on_animation_player_animation_finished(anim_name):
	if anim_name != "in":
		return
	
	MusicPlayer.stop()
	
	if defeat:
		$AnimationPlayer.play("win")
		$DefeatStreamPlayer.play()
		return
	$AnimationPlayer.play("win")
	$VictoryStreamPlayer.play()
