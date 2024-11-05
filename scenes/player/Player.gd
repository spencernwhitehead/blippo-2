extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var velocity_component = $VelocityComponent

var player_last_moved_angle = 0
var is_rotating = false
var number_colliding_bodies = 0
var base_speed = 0
var health_tracker = 0

func _ready():
	base_speed = velocity_component.max_speed
	
	health_component.max_health = 5
	if MetaProgression.save_data["meta_upgrades"].has("health_up"):
		health_component.max_health += MetaProgression.save_data["meta_upgrades"]["health_up"]["quantity"]
	health_component.current_health = health_component.max_health
	health_component.health_changed.connect(on_health_changed)
	health_tracker = health_component.max_health
	
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	GameEvents.heart_collected.connect(on_heart_collected)
	GameEvents.yumbo_collected.connect(on_yumbo_collected)
	update_health_display()


func _process(delta):
	#determine direction/velocity and move
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	#controls sprite animation based on movement
	if movement_vector != Vector2.ZERO:
		is_rotating = true
		sprite.play("walk")
		if !$FootstepPlayer.playing:
			$FootstepPlayer.play()
		player_last_moved_angle = direction.angle()
	else:
		sprite.play("idle")
		$FootstepPlayer.stop()
		#sprite.frame = 0
	
	#rotates sprite to movement direction, snaps to closest 45 deg angle when no longer moving
	if movement_vector != Vector2.ZERO:
		rotation = lerp_angle(rotation, player_last_moved_angle + -PI/2, 10 * delta)
	elif is_rotating:
		rotation = round(rotation / (PI/4)) * PI/4
		is_rotating = false
	
	#prevents health bar from rotating with rest of player
	#health_bar.rotation = rotation * -1


#returns movement vector, can be 8 possible directions based on WASD movement
func get_movement_vector():
	var x_movement
	var y_movement
	if GameEvents.mouse_controls:
		x_movement = Input.get_action_strength("move_right_mouse") - Input.get_action_strength("move_left_mouse")
		y_movement = Input.get_action_strength("move_down_mouse") - Input.get_action_strength("move_up_mouse")
	else:
		x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func check_deal_damage():
	if number_colliding_bodies == 0 or not damage_interval_timer.is_stopped():
		return
	
	health_component.damage(1)
	damage_interval_timer.start()


func update_health_display():
	health_bar.value = health_component.get_health_percent()


func _on_collision_area_2d_body_entered(body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func _on_collision_area_2d_body_exited(body):
	number_colliding_bodies -= 1


func on_yumbo_collected(num):
	$MunchRandomStreamPlayer.play_random()


func _on_damage_interval_timer_timeout():
	check_deal_damage()


func on_heart_collected():
	print("player calls heal function")
	health_component.heal(1)
	$HeartRandomStreamPlayer.play_random()


func on_health_changed():
	if health_component.current_health < health_tracker:
		GameEvents.emit_player_damaged()
		$HitRandomStreamPlayer.play_random()
	update_health_display()
	health_tracker = health_component.current_health


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
		
	elif ability_upgrade.id == "player_speed":
		#note that percentage is hard coded here
		velocity_component.max_speed = base_speed + .1 * current_upgrades["player_speed"].quantity * base_speed
	
