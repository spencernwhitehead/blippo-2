extends Area2D
class_name HurtboxComponent

signal hit

@export var health: Node
@export var velocity_component: Node

var floating_text_scene = preload("res://scenes/ui/floating_text.tscn")
var text_upwards_offset = 25

func get_direction_to_damage(hitbox: HitboxComponent):
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return Vector2.ZERO
	
	var damage_node2d = hitbox.owner as Node2D
	if damage_node2d == null:
		return Vector2.ZERO
	
	var direction = Vector2.RIGHT.rotated(damage_node2d.rotation)#(damage_node2d.global_position - owner_node2d.global_position).normalized()
	return direction


func _on_area_entered(area: Area2D):
	if not area is HitboxComponent:
		return
	
	if health == null:
		return
	
	var hitbox = area as HitboxComponent
	health.damage(hitbox.damage)
	
	if velocity_component != null:
		var direction = get_direction_to_damage(hitbox)#.rotated(deg_to_rad(180))
		velocity_component.knockback(hitbox.knockback, direction)
	
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	
	floating_text.global_position = global_position + Vector2.UP * text_upwards_offset
	
	var format_str = "%0.1f"
	if round(hitbox.damage) == hitbox.damage:
		format_str = "%0.0f"
	floating_text.start(format_str % hitbox.damage)
	
	hit.emit()
