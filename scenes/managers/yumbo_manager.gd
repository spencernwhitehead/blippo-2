extends Node

@export var yumbo_scene: PackedScene

#limits to random spawn position
var left_border = -600
var right_border = 2100
var top_border = -1600
var bottom_border = 1200


func _ready():
	GameEvents.yumbo_collected.connect(on_yumbo_collected)


func get_spawn_position():
	return Vector2(randf_range(left_border, right_border), randf_range(top_border, bottom_border))


func _on_yumbo_cooldown_timer_timeout():
	var yumbo_instance = yumbo_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(yumbo_instance)
	yumbo_instance.global_position = get_spawn_position()


func on_yumbo_collected(_number):
	pass
	#$YumboCooldownTimer.wait_time = .5
	#$YumboCooldownTimer.start()
