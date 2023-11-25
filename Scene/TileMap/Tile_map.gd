extends TileMap

var cloud = preload("res://Scene/Cloud/cloud.tscn")

@onready var spawn_location = $CloudPath/PathFollow2D
@onready var cloud_free_point = $CloudFreePoint

func _on_timer_timeout():
	var cloud_instance = cloud.instantiate()
	
	spawn_location.progress_ratio = randf()
	
	cloud_instance.position = spawn_location.position
	cloud_instance.free_point = cloud_free_point.position
	
	add_child(cloud_instance)
