extends Button

signal upgrade_selected(upgrade: MetaUpgrade)
signal sprite_set

@export var upgrade: MetaUpgrade


func set_sprite():
	$ItemIcon.texture = upgrade.sprite
	sprite_set.emit()


func _on_pressed():
	upgrade_selected.emit(upgrade)
