extends TileMap

var cloud = preload("res://Scene/Cloud/cloud.tscn")

@onready var spawn_location = $CloudPath/PathFollow2D
@onready var cloud_free_point = $CloudFreePoint

func _ready():
	$goldKnight.set_physics_process(false)
	$goldKnight.update_animation_params(Vector2.ZERO)

func _on_timer_timeout():
	var cloud_instance = cloud.instantiate()
	
	spawn_location.progress_ratio = randf()
	
	cloud_instance.position = spawn_location.position
	cloud_instance.free_point = cloud_free_point.position
	
	add_child(cloud_instance)


func _on_start_button_start_button_click():
	$StartButton.hide()
	$InitialDialogue.show()
	pass # Replace with function body.


func _on_initial_dialogue_initial_dialogue_finish():
	$InitialDialogue.hide()
	$goldKnight.set_physics_process(true)
	pass # Replace with function body.
