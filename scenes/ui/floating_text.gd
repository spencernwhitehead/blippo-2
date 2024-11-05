extends Node2D

var original_scale = scale

func start(text: String):
	$Label.text = text
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 20), .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 60), .4)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(queue_free)
	
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", original_scale * 1.5, .15)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(self, "scale", original_scale, .15)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(self, "modulate", Color(1,1,1,0), .4)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
