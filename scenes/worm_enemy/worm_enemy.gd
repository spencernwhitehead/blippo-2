extends CharacterBody2D

@onready var death_component = $DeathComponent
@onready var velocity_component = $VelocityComponent

var death_color = Color(0, .35, 1)


func _ready():
	death_component.death_color = death_color
	$HurtboxComponent.hit.connect(on_hit)
	$AnimatedSprite2D.frame = randi_range(0, $AnimatedSprite2D.sprite_frames.get_frame_count("default") - 1)


func _process(delta):
	death_component.spawn_position = global_position
	
	velocity_component.rotate_to_player()
	velocity_component.accelerate_to_player()
	velocity_component.move(self)


func on_hit():
	$RandomStreamPlayer2DComponent.play_random()
