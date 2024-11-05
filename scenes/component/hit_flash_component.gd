extends Node

@export var health_component: Node
@export var sprite: Node2D

var hit_flash_tween: Tween


func _ready():
	health_component.damaged.connect(on_health_changed)


#currently all this does is take half the given time to set the color back to normal from red
#at some point this whole system probably needs to be changed since modulating to red doesn't really work with the player
func tween_method(percent: float):
	var rounded_percent = roundf(percent)
	if rounded_percent > 0:
		sprite.modulate = Color(1, rounded_percent, rounded_percent, 1)
	

func on_health_changed():
	if hit_flash_tween != null and hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	sprite.modulate = Color(1,0,0,1)
	
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_method(tween_method, 0.0, 1.0, .4)
