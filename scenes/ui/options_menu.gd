extends CanvasLayer

signal back_pressed

@export var click_player: PackedScene

@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SfxSlider
@onready var window_button = %WindowButton
@onready var back_button = %BackButton
@onready var animation_player = $AnimationPlayer
@onready var outer_margin_container = $Control/OuterMarginContainer
@onready var options_container = $Control/OuterMarginContainer/OptionsContainer


var anim_buffer = false

#TODO for options menu:
#silly setting obvs
#sound effect for sliders


func _ready():
	update_display()
	animation_player.play("RESET")
	animation_player.play("in")


func update_display():
	window_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Fullscreen"
	sfx_slider.value = get_bus_volume_percent("sfx")
	music_slider.value = get_bus_volume_percent("music")


func get_bus_volume_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume_percent(bus_name: String, percent: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	
	if int(percent * 100) % 2 == 0 and anim_buffer:
		var clicker = click_player.instantiate()
		add_child(clicker)
		clicker.pitch_scale += percent
		clicker.play()
		
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func _on_music_slider_value_changed(value):
	set_bus_volume_percent("music", value)

func _on_sfx_slider_value_changed(value):
	set_bus_volume_percent("sfx", value)


func _on_window_button_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	update_display()


func _on_back_button_pressed():
	back_pressed.emit()
	animation_player.play("out")


func _on_reset_save_button_pressed():
	MetaProgression.reset_save()
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")


func _on_check_box_toggled(toggled_on):
	GameEvents.mouse_controls = toggled_on


func _on_animation_player_animation_finished(anim_name):
	anim_buffer = true
