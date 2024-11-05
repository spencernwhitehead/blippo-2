extends MarginContainer

var is_breaking = false

@onready var sprite = $AnimatedSprite2D


func set_empty():
	sprite.play("empty")


func heart_break():
	sprite.play("break")
	is_breaking = true


func get_animation():
	return sprite.animation


func set_random_frame():
	sprite.set_frame(randi_range(0,13))


func _on_animated_sprite_2d_animation_finished():
	if sprite.animation != "break":
		return
	queue_free()
