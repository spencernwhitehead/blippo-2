extends CharacterBody2D

@onready var death_component = $DeathComponent
@onready var velocity_component = $VelocityComponent
@onready var health_component = $HealthComponent
@onready var sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

var death_color = Color(1, .5, 1)
var has_shell = true


func _ready():
	death_component.death_color = death_color
	$HurtboxComponent.hit.connect(on_hit)


func _process(delta):
	death_component.spawn_position = global_position
	
	if has_shell and health_component.current_health < health_component.max_health / 2:
		sprite.play("shell-less")
		animation_player.play("shell_drop")
		velocity_component.max_speed *= 3
		velocity_component.acceleration *= .4
		#velocity_component.rotational_acceleration *= .4
		has_shell = false
	
	velocity_component.rotate_to_player()
	velocity_component.accelerate_to_player()
	velocity_component.move(self)


func on_hit():
	$RandomStreamPlayer2DComponent.play_random()
