extends Node2D
class_name DefaultBullet

@onready var hitbox = $HitboxComponent
const OFFSET = 25
const RANGE = 1200
var start_position
var travel_time = 2.0
var piercing_buffer = 0
var range_scale = 1


func _ready():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	start_position = player.global_position + Vector2(0, int(-OFFSET * .5)).rotated(player.rotation)


func fire(speed_factor = 1):
	var tween = create_tween()
	travel_time /= speed_factor
	tween.tween_method(tween_method, 0.0, 1.0, travel_time * range_scale)
	tween.tween_callback(queue_free)


func tween_method(percent: float):
	var current_distance = percent * RANGE * range_scale
	position = start_position + Vector2(current_distance + OFFSET, 0).rotated(rotation)


func _on_hitbox_component_area_entered(area: Area2D):
	if not area is HurtboxComponent:
		return
	if piercing_buffer > 0:
		piercing_buffer -= 1
		return
	
	queue_free()
