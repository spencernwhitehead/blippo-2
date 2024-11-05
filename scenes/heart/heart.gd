extends Node2D


func _on_pickup_radius_area_entered(area):
	GameEvents.emit_heart_collected(1)
	queue_free()
