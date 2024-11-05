extends CharacterBody2D

@onready var death_component = $DeathComponent
@onready var velocity_component = $VelocityComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var collision_shape_2d = $CollisionShape2D
@onready var animated_sprite_2d = $AnimatedSprite2D

var death_color = Color(0, 1, 0)

@export var dash_frames = 4
@export var dash_speed = 800
@export var dash_acceleration = 2
@export var dash_rotational_acceleration = 2
@export var slow_speed = 200
@export var slow_acceleration = 2
@export var slow_rotational_acceleration = 2


func _ready():
	var random_direction = randf_range(0, TAU)
	hurtbox_component.rotation = random_direction
	collision_shape_2d.rotation = random_direction
	animated_sprite_2d.rotation = random_direction
	
	death_component.death_color = death_color
	$HurtboxComponent.hit.connect(on_hit)
	#$AnimatedSprite2D.frame = randi_range(0, $AnimatedSprite2D.sprite_frames.get_frame_count("default") - 1)


func _process(delta):
	death_component.spawn_position = global_position
	if $AnimatedSprite2D.frame < dash_frames:
		velocity_component.max_speed = dash_speed
		velocity_component.acceleration = dash_acceleration
		velocity_component.rotational_acceleration = dash_rotational_acceleration
	else:
		velocity_component.max_speed = slow_speed
		velocity_component.acceleration = slow_acceleration
		velocity_component.rotational_acceleration = slow_rotational_acceleration
	
	velocity_component.rotate_to_player()
	velocity_component.accelerate_to_player()
	velocity_component.move(self)


func on_hit():
	$RandomStreamPlayer2DComponent.play_random()
