extends CanvasLayer

@onready var current_yumbos = $YumboContainer/HBoxContainer/CurrentYumbos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_yumbos.text = ' : '+str(MetaProgression.save_data["meta_upgrade_currency"])
