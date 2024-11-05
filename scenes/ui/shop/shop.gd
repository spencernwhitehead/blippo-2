extends CanvasLayer

var shop_item_scene = preload("res://scenes/ui/shop/shop_item.tscn")

var upgrade_experience = preload("res://resources/meta_upgrades/experience_gain.tres")
var powerup_bomb = preload("res://resources/meta_upgrades/powerup_bomb.tres")
var health_up = preload("res://resources/meta_upgrades/health_up.tres")
var heart_drops = preload("res://resources/meta_upgrades/heart_drops.tres")
var little_guy = preload("res://resources/meta_upgrades/little_guy.tres")
var powerup_ice = preload("res://resources/meta_upgrades/powerup_ice.tres")
var powerup_shield = preload("res://resources/meta_upgrades/powerup_shield.tres")
var powerup_weapon = preload("res://resources/meta_upgrades/powerup_weapon.tres")
var upgrades_up = preload("res://resources/meta_upgrades/upgrades_up.tres")

@onready var shelf_1 = %Shelf1
@onready var shelf_2 = %Shelf2
@onready var dialog_box = $DialogBox
@onready var item_name = %ItemName
@onready var item_quantity = %ItemQuantity
@onready var item_cost = %ItemCost
@onready var item_info_container = $ItemInfoContainer
@onready var buy_button = %BuyButton
@onready var current_yumbos = $YumboContainer/HBoxContainer/CurrentYumbos
@onready var clumbo = %Clumbo
@onready var red_dither_effect = %RedDitherEffect

var current_upgrade
var dialogs = 0


func _ready():
	#MetaProgression.save_data["meta_upgrade_currency"] = 100
	#print(MetaProgression.save_data)
	var upgrades_table = [[upgrade_experience, health_up, heart_drops, little_guy]]#,\
						#[powerup_bomb, powerup_ice, powerup_shield, powerup_weapon]]
	for i in 1:
		for j in 4:
			var shop_item_instance = shop_item_scene.instantiate()
			if i == 0:
				shelf_1.add_child(shop_item_instance)
			else:
				shelf_2.add_child(shop_item_instance)
			shop_item_instance.upgrade = upgrades_table[i][j]
			shop_item_instance.set_sprite()
			shop_item_instance.upgrade_selected.connect(on_upgrade_selected)
	
	dialog_box.dialog_started.connect(on_dialog_started)
	dialog_box.dialog_finished.connect(on_dialog_finished)
	
	update_current_yumbos()
	dialog_box.display_text("clumbo: hello and and welcome to my shop !")


func update_current_yumbos():
	current_yumbos.text = ": " + str(MetaProgression.save_data["meta_upgrade_currency"])


func set_item_quantity(upgrade):
	if MetaProgression.save_data["meta_upgrades"].has(upgrade.id):
		var quantity = MetaProgression.save_data["meta_upgrades"][upgrade.id]["quantity"]
		item_quantity.text = 'x' + str(quantity) + '/' + str(upgrade.max_quantity)
		if quantity == upgrade.max_quantity:
			buy_button.text = "sold out"
			buy_button.disabled = true
		else:
			buy_button.text = "buy"
			buy_button.disabled = false
	else:
		item_quantity.text = "x0/" + str(upgrade.max_quantity)
		buy_button.text = "buy"


func on_dialog_started():
	dialogs += 1
	clumbo.talk()
	#red_dither_effect.material.set_shader_parameter("enable", true)


func on_dialog_finished():
	dialogs -= 1
	if dialogs == 0:
		clumbo.idle()
		#red_dither_effect.material.set_shader_parameter("enable", false)


func on_upgrade_selected(upgrade: MetaUpgrade):
	current_upgrade = upgrade
	item_info_container.visible = true
	item_name.text = upgrade.title
	item_cost.text = str(upgrade.cost)
	if upgrade.cost > MetaProgression.save_data["meta_upgrade_currency"]:
		buy_button.disabled = true
	else:
		buy_button.disabled = false
	set_item_quantity(upgrade)
	dialog_box.display_text(upgrade.description)


func _on_back_button_pressed():
	MetaProgression.save()
	MusicPlayer.stop()
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")


func _on_buy_button_pressed():
	if current_upgrade == null:
		return
	MetaProgression.add_meta_upgrade(current_upgrade)
	update_current_yumbos()
	set_item_quantity(current_upgrade)
	dialog_box.display_text("ooooooooo tytytytyty!")
