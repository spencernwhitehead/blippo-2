extends CharacterBody2D

@onready var death_component = $DeathComponent
@onready var velocity_component = $VelocityComponent
@onready var sprite = $AnimatedSprite2D
@onready var charge_timer = $ChargeTimer

var death_color = Color(1, .9, 0)
var stop = false
var charge = false


func _ready():
	death_component.death_color = death_color
	$HurtboxComponent.hit.connect(on_hit)


func _process(delta):
	death_component.spawn_position = global_position
	
	if stop:
		velocity_component.velocity = Vector2.ZERO
		velocity = Vector2.ZERO
	else:
		velocity_component.accelerate_to_player()
	velocity_component.rotate_to_player()
	velocity_component.move(self)


func on_hit():
	$RandomStreamPlayer2DComponent.play_random()


func _on_detection_radius_area_entered(area):
	if stop or charge:
		return
	sprite.play("aim")
	stop = true


func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "aim":
		stop = false
		charge = true
		sprite.play("charge")
		charge_timer.start()
	elif sprite.animation == "slow":
		sprite.play("default")
		charge = false


func _on_charge_timer_timeout():
	sprite.play("slow")
