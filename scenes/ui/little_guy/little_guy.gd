extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if MetaProgression.save_data["meta_upgrades"].has("little_guy"):
		visible = true
	else:
		visible = false
