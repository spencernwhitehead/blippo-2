extends AudioStreamPlayer

@export var main_menu_song: AudioStream
@export var intro_level_song: AudioStream
@export var shop_song: AudioStream
@export var fade_in_damper: float

var default_db
var fade_in = false


func _ready():
	default_db = volume_db


func play_song(song_name: String):
	if song_name == "menu":
		stream = main_menu_song
	elif song_name == "intro":
		stream = intro_level_song
	elif song_name == "shop":
		stream = shop_song
	
	if fade_in:
		var tween = create_tween()
		volume_db -= 20
		tween.tween_property(self, "volume_db", default_db, 1)
	
	play()
