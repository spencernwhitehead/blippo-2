extends Node

@export var heart_scene: PackedScene
@export var health: Node


func _ready():
	(health as HealthComponent).died.connect(on_died)


func on_died():
	if !MetaProgression.save_data["meta_upgrades"].has("heart_drops"):
		return
		
	if heart_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	var chance = .02 + .005*(MetaProgression.save_data["meta_upgrades"]["heart_drops"]["quantity"]-1) 
	if randf_range(0,1) > chance:
		return
	
	var spawn_position = (owner as Node2D).global_position
	var heart_instance = heart_scene.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(heart_instance)
	heart_instance.global_position = spawn_position
