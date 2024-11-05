extends AnimatedSprite2D

var talking = false
var talk_animations = ["talk_1", "talk_2", "talk_3", "talk_4", "talk_4", "talk_4"]
var idle_animations = []

func talk():
	talking = true
	animation = talk_animations.pick_random()
	play()


func idle():
	talking = false
	animation = "default"
	play()


func _on_animation_finished():
	if talking:
		animation = talk_animations.pick_random()
		play()
		return
	animation = idle_animations.pick_random()
	play()
