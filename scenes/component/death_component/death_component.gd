extends Node2D

@export var health_component: Node

var death_color
var spawn_position


func _ready():
	health_component.died.connect(on_died)


func on_died():
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	#since immediately after the died signal is broadcast, the owner frees itself it may be null at this point
	#how does the child still exist if it's owner is cast into the void? i don't know!
	if owner != null:
		owner.remove_child(self)
	if get_parent() != entities_layer:
		entities_layer.add_child(self)
	
	modulate = death_color
	global_position = spawn_position
	rotation = randf_range(0,TAU)
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play("splat")
	$RandomStreamPlayer2DComponent.play_random()


func _on_animated_sprite_2d_animation_finished():
	queue_free()
