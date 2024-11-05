extends CharacterBody2D

@onready var velocity_component = $VelocityComponent

var attract = false
var start_speed = 400
var start_direction = Vector2.ZERO


func _ready():
	start_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	rotation = start_direction.angle()
	velocity_component.velocity = start_direction * start_speed
	
	#sets spridgets to random specific colors while avoiding black or white
	#at some point i need to make custom sprites instead of this because the colors kinda suck
	while modulate == Color(1,1,1) or modulate == Color(.25,.25,.25):
		modulate = Color(.25 + (randi() % 2) * .75, .25 + (randi() % 2) * .75, .25 + (randi() % 2) * .75)


func _process(delta):
	if attract:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	
	velocity_component.move(self)


func disable_attraction_radius():
	$AttractionRadius/CollisionShape2D.disabled = true


func _on_pickup_radius_area_entered(area):
	GameEvents.emit_spridget_collected(1)
	queue_free()


func _on_attraction_radius_area_entered(area: Node2D):
	Callable(disable_attraction_radius).call_deferred()
	attract = true
	velocity_component.acceleration = 6
	var direction = (area.global_position - global_position).rotated(PI)
	velocity_component.velocity = direction * 12
	$RandomStreamPlayer2DComponent.play_random()
