extends CanvasLayer

signal transition_halfway


func transition_to_scene(scene_name: String):
	transition()
	await transition_halfway
	get_tree().change_scene_to_file(scene_name)


func transition():
	$AnimationPlayer.play("transition_in")
	await $AnimationPlayer.animation_finished
	transition_halfway.emit()
	$AnimationPlayer.play("transition_out")
