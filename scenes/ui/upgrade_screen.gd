extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene

@onready var card_container: HBoxContainer = %CardContainer

var default_volume
var music_dampener = 10
var delay_period = .2


func _ready():
	get_tree().paused = true
	default_volume = MusicPlayer.volume_db
	MusicPlayer.volume_db = default_volume - music_dampener


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	var delay = 0
	for upgrade in upgrades:
		var card_instance = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.card.set_ability_upgrade(upgrade)
		card_instance.card.pop_up(delay)
		card_instance.card.selected.connect(on_upgrade_selected.bind(upgrade))
		delay += delay_period


func on_upgrade_selected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	MusicPlayer.volume_db = default_volume
	get_tree().paused = false
	queue_free()
