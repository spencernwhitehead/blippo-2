extends Node

@export var end_screen_scene: PackedScene
@export var arena_time_manager: Node

var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")


func _ready():
	arena_time_manager.timer.timeout.connect(on_arena_timer_timeout)
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	#for some reason, this node is able to access the player before its children have initialized
	#using await allows it to wait until the player node is fully initialized to connect to the health
	await player.ready
	player.health_component.died.connect(on_player_died)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()


func on_arena_timer_timeout():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	MetaProgression.save()


func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	MetaProgression.save()
