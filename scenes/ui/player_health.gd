extends CanvasLayer

@export var heart_sprite_scene: PackedScene

@onready var empty_hearts_container = $MarginContainer/EmptyHeartsContainer
@onready var hearts_container = $MarginContainer/HeartsContainer

var current_hearts = 0
var max_health = 0
var player


func _ready():
	if heart_sprite_scene == null:
		return
	player = get_tree().get_first_node_in_group("player")
	await player.ready
	max_health = player.health_component.max_health
	
	add_health(max_health)
	add_health(max_health, true)
	
	#GameEvents.player_damaged.connect(on_player_damaged)
	player.health_component.health_changed.connect(on_player_health_changed)


func add_health(num: int = 1, empty = false):
	for i in num:
		var heart_instance = heart_sprite_scene.instantiate()
		if empty:
			empty_hearts_container.add_child(heart_instance)
			heart_instance.set_empty()
		else:
			hearts_container.add_child(heart_instance)
			heart_instance.set_random_frame()
			current_hearts += 1


func remove_health(num: int = 1, empty = false):
	var index = hearts_container.get_child_count()-1
	while hearts_container.get_children()[index].is_breaking:
		index -= 1
	hearts_container.get_children()[index].heart_break()
	empty_hearts_container.get_children()[index].modulate = Color(0,0,0,0)
	await hearts_container.get_children()[index].sprite.animation_finished
	empty_hearts_container.get_children()[index].modulate = Color(1,1,1,1)
	current_hearts -= 1
#		if empty:
#			empty_hearts_container.get_children()[empty_hearts_container.get_child_count()-1].queue_free()
#		if !empty:
#			var index = hearts_container.get_child_count()-1
#			while hearts_container.get_children()[index].is_breaking:
#				index -= 1
#			hearts_container.get_children()[index].heart_break()
#		if hearts_container.get_children() > empty_hearts_container.get_children():
#			hearts_container.get_children()[hearts_container.get_child_count()-1].queue_free()


func on_player_health_changed():
	if player.health_component.current_health < current_hearts:
		remove_health()
	else:
		if current_hearts == max_health:
			return
		add_health()


func on_player_damaged():
	remove_health()
#	var health_to_remove = len(hearts_container.get_children()) - int(player.health_component.get_health_percent() * max_health)
#	remove_health(health_to_remove)
