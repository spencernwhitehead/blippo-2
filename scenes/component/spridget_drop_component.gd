extends Node

@export var spridget_scene: PackedScene
@export var health: Node

var min_range = 1
var max_range = 3


func _ready():
	(health as HealthComponent).died.connect(on_died)
	
	if !MetaProgression.save_data["meta_upgrades"].has("experience_gain"):
		return
	var xp_quantity : float = MetaProgression.save_data["meta_upgrades"]["experience_gain"]["quantity"]
	min_range += floorf(xp_quantity / 2)
	max_range += ceilf(xp_quantity / 2)

func on_died():
	if spridget_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	var spawn_position = (owner as Node2D).global_position
	
	for i in randi_range(min_range, max_range):
		var spridget_instance = spridget_scene.instantiate()
		var entities_layer = get_tree().get_first_node_in_group("entities_layer")
		entities_layer.add_child(spridget_instance)
		spridget_instance.global_position = spawn_position
