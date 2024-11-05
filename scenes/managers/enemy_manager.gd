extends Node

@export var basic_enemy_scene: PackedScene
@export var pincer_enemy_scene: PackedScene
@export var snail_enemy_scene: PackedScene
@export var skater_enemy_scene: PackedScene

@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time = 0
var spawn_radius = ProjectSettings.get_setting("display/window/size/viewport_width") * 0.6
var enemy_table = WeightedTable.new()


func _ready():
	#enemy_table.add_item(snail_enemy_scene, 10)
	enemy_table.add_item(basic_enemy_scene, 10)
	#enemy_table.add_item(skater_enemy_scene, 10)
	#enemy_table.add_item(pincer_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position(player: Node2D):
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var rand_direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	
	for i in 4:
		spawn_position = player.global_position + (spawn_radius * rand_direction)
		
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		if result.is_empty():
			break
		else:
			rand_direction = rand_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func _on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var enemy = enemy_table.pick_item().instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position(player)


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (.1/12) * arena_difficulty
	time_off = min(time_off, .7)
#	print(time_off)
	timer.wait_time = base_spawn_time - time_off
	
	#note: difficulty increases every 5 secs
	if arena_difficulty == 6:
		enemy_table.add_item(skater_enemy_scene, 10)
	elif arena_difficulty == 12:
		enemy_table.add_item(snail_enemy_scene, 10)
	elif arena_difficulty == 18:
		enemy_table.add_item(pincer_enemy_scene, 10)
	elif arena_difficulty == 24:
		enemy_table.add_item(skater_enemy_scene, 10)
		enemy_table.add_item(snail_enemy_scene, 10)
	elif arena_difficulty == 30:
		enemy_table.add_item(pincer_enemy_scene, 10)
