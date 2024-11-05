extends CanvasLayer

signal dialog_started
signal dialog_finished

@onready var character_timer = $CharacterTimer
#this is supposed to control how many characters appear per second in the dialogue box
#I think it's limited by the computing time so it can only reveal text at a medium speed
@export var characters_per_second: int = 1000
@onready var dialog = %Dialog
@onready var text_blip_player = $TextBlipPlayer


func _ready():
	character_timer.wait_time = 1.0 / characters_per_second
	#display_text("this is a test on doing very long strings that will probably take multiple lines aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")


func display_text(text: String):
	dialog_started.emit()
	var current_text = ""
	character_timer.start()
	for character in text:
		current_text = current_text + character
		dialog.text = current_text
		if character != ' ':
			text_blip_player.play_random()
		await character_timer.timeout
		character_timer.start()
	character_timer.stop()
	dialog_finished.emit()
