extends Node

@export var max_speed: int = 200
@export var acceleration: float = 5
@export var rotational_acceleration: float = 5

var velocity = Vector2.ZERO
var knockback_active = false
var knockback_direction = Vector2.ZERO
var knockback_velocity = Vector2.ZERO
var stored_velocity = Vector2.ZERO


func get_direction_to_player():
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return Vector2.ZERO
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var direction = (player.global_position - owner_node2d.global_position).normalized()
	return direction


func rotate_to_player():
	rotate_in_direction(get_direction_to_player())


func rotate_in_direction(direction: Vector2):
	owner.rotation = lerp_angle(owner.rotation, direction.angle(), 1.0 - exp(-rotational_acceleration * get_process_delta_time()))


func accelerate_to_player():
	accelerate_in_direction(get_direction_to_player())


func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))


func knockback(knockback_received: int, direction: Vector2):
	knockback_active = true
	$KnockbackTimer.start()
	knockback_velocity = knockback_received * direction
	stored_velocity = velocity


func decelerate():
	accelerate_in_direction(Vector2.ZERO)


func move(character_body: CharacterBody2D):
	if knockback_active:
		velocity = knockback_velocity
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity


func _on_knockback_timer_timeout():
	knockback_active = false
	velocity = stored_velocity
