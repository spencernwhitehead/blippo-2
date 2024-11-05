extends Node

signal spridget_collected(number: float)
signal yumbo_collected(number: int)
signal heart_collected()
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged

var mouse_controls = false


func emit_spridget_collected(number: float):
	spridget_collected.emit(number)


func emit_yumbo_collected(number: int):
	yumbo_collected.emit(number)


func emit_heart_collected(number: int):
	heart_collected.emit()
	print("game events emits heart collected")


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)


func emit_player_damaged():
	player_damaged.emit()
