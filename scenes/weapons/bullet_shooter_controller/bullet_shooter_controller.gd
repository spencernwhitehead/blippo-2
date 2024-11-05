extends Node

@export var bullet_scene: PackedScene

var base_damage = 5
var additional_damage_percent = 1
var damage_increment = .15
var base_knockback = 1000
var additional_knockback_percent = 1
var knockback_increment = .25
var base_wait_time
var scale_factor = 1
var scale_increment = .2
var speed_factor = 1
var speed_increment = .25
var piercing_buffer = 0
var num_bullets = 1


func _ready():
	base_wait_time = $BulletTimer.wait_time
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func _process(delta):
	if not $BulletTimer.is_stopped():
		return
		
	var direction
	if GameEvents.mouse_controls:
		direction = get_bullet_mouse_vector()
	else:
		direction = get_bullet_keys_vector()
	if direction == Vector2.ZERO:
		return
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	if foreground_layer == null:
		return
	
	for i in num_bullets:
		var bullet_instance = bullet_scene.instantiate() as DefaultBullet
		foreground_layer.add_child(bullet_instance)
		bullet_instance.hitbox.damage = base_damage * additional_damage_percent
		bullet_instance.hitbox.knockback = base_knockback * additional_knockback_percent
		bullet_instance.scale *= scale_factor
		if num_bullets == 1:
			bullet_instance.rotation = direction.angle()
		else:
			bullet_instance.rotation = direction.angle() - deg_to_rad(45) + i * deg_to_rad(45)
			bullet_instance.range_scale = .15
		bullet_instance.piercing_buffer = piercing_buffer
		bullet_instance.fire(speed_factor)
	
	$RandomStreamPlayer2DComponent.play_random()
	
	$BulletTimer.start()


#returns bullet vector, can be 8 possible directions based on arrow key movement
func get_bullet_keys_vector():
	var x_movement = Input.get_action_strength("attack_right") - Input.get_action_strength("attack_left")
	var y_movement = Input.get_action_strength("attack_down") - Input.get_action_strength("attack_up")
	return Vector2(x_movement, y_movement)


#returns bullet vector, can be ANY direction based on mouse position
#may change it to also be only 8? may not be very fun to shoot though
func get_bullet_mouse_vector():
	if not Input.is_action_pressed("attack_mouse"):
		return Vector2.ZERO

	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO

	return (player.get_global_mouse_position() - player.global_position).normalized()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "bullet_rate":
		var percent_reduction = current_upgrades["bullet_rate"]["quantity"]
		$BulletTimer.wait_time = base_wait_time * pow((1 - .1), percent_reduction)
		$BulletTimer.start()
	elif upgrade.id == "bullet_damage":
		additional_damage_percent = 1 + current_upgrades["bullet_damage"]["quantity"] * damage_increment
	elif upgrade.id == "bullet_size":
		scale_factor = 1 + current_upgrades["bullet_size"]["quantity"] * scale_increment
	elif upgrade.id == "bullet_speed":
		speed_factor = 1 + current_upgrades["bullet_speed"]["quantity"] * speed_increment
	elif upgrade.id == "bullet_piercing":
		piercing_buffer = current_upgrades["bullet_piercing"]["quantity"]
	elif upgrade.id == "bullet_shotgun":
		num_bullets = 3
	elif upgrade.id == "bullet_knockback":
		additional_knockback_percent = 1 + current_upgrades["bullet_knockback"]["quantity"] * knockback_increment
