extends PanelContainer

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var upgrade_drawing = $MarginContainer/VBoxContainer/UpgradeDrawing

@onready var hover_stream_player: AudioStreamPlayer = $HoverRandomStreamPlayer

var disabled = true

func _ready():
	modulate = Color.TRANSPARENT
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	

func pop_up(delay: float = 0):
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("pop-up")


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description
	if upgrade.drawing == null:
		return
	upgrade_drawing.texture = upgrade.drawing


func enable():
	disabled = false


func play_discard():
	$AnimationPlayer.play("discard")


func select_card():
	disabled = true
	$AnimationPlayer.play("selected")
	hover_stream_player.stop()
	
	for other_card in get_tree().get_nodes_in_group("upgrade_card"):
		if other_card == self:
			continue
		other_card.play_discard()
	
	await $AnimationPlayer.animation_finished
	selected.emit()


func _on_gui_input(event: InputEvent):
	if disabled:
		return
	
	if event.is_action_pressed("left_click"):
		select_card()


func _on_mouse_entered():
	if disabled:
		return
	$AnimationPlayer.play("hover")
	hover_stream_player.play_random()


func _on_mouse_exited():
	if disabled:
		return
	$AnimationPlayer.play("RESET")
	hover_stream_player.stop()
