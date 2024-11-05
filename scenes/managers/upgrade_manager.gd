extends Node

@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

#TODO: instead of creating individual nodes, figure out how to put upgrades into a JSON file that can be read in
var upgrade_bullet_rate = preload("res://resources/upgrades/bullet_rate.tres")
var upgrade_bullet_damage = preload("res://resources/upgrades/bullet_damage.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")
var upgrade_bullet_knockback = preload("res://resources/upgrades/bullet_knockback.tres")
var upgrade_bullet_piercing = preload("res://resources/upgrades/bullet_piercing.tres")
var upgrade_bullet_shotgun = preload("res://resources/upgrades/bullet_shotgun.tres")
var upgrade_bullet_size = preload("res://resources/upgrades/bullet_size.tres")
var upgrade_bullet_speed = preload("res://resources/upgrades/bullet_speed.tres")


func _ready():
	upgrade_pool.add_item(upgrade_bullet_rate, 10)
	upgrade_pool.add_item(upgrade_bullet_damage, 10)
	upgrade_pool.add_item(upgrade_player_speed, 5)
	upgrade_pool.add_item(upgrade_bullet_size, 10)
	upgrade_pool.add_item(upgrade_bullet_speed, 10)
	upgrade_pool.add_item(upgrade_bullet_piercing, 10)
	upgrade_pool.add_item(upgrade_bullet_shotgun, 10)
	upgrade_pool.add_item(upgrade_bullet_knockback, 10)
	
	experience_manager.level_up.connect(on_level_up)


func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	#TODO: un-hardcode the maximum upgrade quantity
	for i in 2:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			return
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades


func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
			}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
#	if chosen_upgrade.id == upgrade_axe.id:
#		upgrade_pool.add_item(upgrade_axe_damage, 10)
	pass


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)


func on_level_up(new_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
