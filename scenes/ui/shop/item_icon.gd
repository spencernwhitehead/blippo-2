extends Sprite2D

@onready var pick_up_player = %PickUpPlayer
@onready var put_down_player = %PutDownPlayer
@onready var animation_player = $"../AnimationPlayer"

var lerpa : Vector2
var lerpi : Vector2
#@export var mouse_range = 120
@export var speed_of_lerp = 0.1
@export var sprite_divisions = 3
@export var hover_scale = 1.25
var mouse
var grow = false
var default_scale = scale
var mouse_round_margin


func _ready():
	self.set_material(self.get_material().duplicate(true))
	
	await owner.sprite_set
	
	var width = get_texture().get_width() * scale.x
	var height = get_texture().get_height() * scale.y
	
	material.set_shader_parameter("width", width)
	material.set_shader_parameter("height", height)
	
	#mouse_range = width * .6
	mouse_round_margin = width / sprite_divisions
	
	animation_player.seek(randf_range(0, animation_player.current_animation_length))


func _process(delta):
	if owner.is_hovered():#get_global_mouse_position().distance_to(global_position) < mouse_range:
		if !grow:
			var tween = create_tween()
			tween.tween_property(self, "scale", default_scale * hover_scale, .5)\
				.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			#mouse_range *= 1.25
			grow = true
			pick_up_player.play_random()
			animation_player.stop()
		
		mouse = round((get_global_mouse_position() - global_position) / mouse_round_margin) * mouse_round_margin
		lerpi = lerp(lerpi, mouse, speed_of_lerp)
		if lerpi != mouse:
			material.set_shader_parameter("mouse_position", lerpi)
		lerpa = lerpi
	else:
		if grow:
			var tween = create_tween()
			tween.tween_property(self, "scale", default_scale, .5)\
				.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			#mouse_range /= 1.25
			grow = false
			put_down_player.play_random()
			animation_player.play("default")
		
		lerpa = lerp(lerpa, Vector2.ZERO, speed_of_lerp)
		if lerpa != Vector2.ZERO:
			material.set_shader_parameter("mouse_position", lerpa)
		lerpi = Vector2.ZERO
