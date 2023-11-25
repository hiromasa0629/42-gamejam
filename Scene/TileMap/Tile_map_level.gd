extends TileMap

var cloud = preload("res://Scene/Cloud/cloud.tscn")

@onready var spawn_location = $CloudPath/PathFollow2D
@onready var cloud_free_point = $CloudFreePoint

var is_close_to_level: bool = false

func _ready():
	global.trx = false
	var map_limits = get_used_rect()
	var map_cellsize = tile_set.tile_size
	$Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	$Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	$Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y
	if (!global.game_is_started):
		$goldKnight.set_physics_process(false)
	else:
		$goldKnight.position = global.level_pos
		$goldKnight.set_physics_process(true)
	$goldKnight.update_animation_params(Vector2.ZERO)

func _process(delta):
	if (Input.is_action_just_pressed("E")):
		if (is_close_to_level):
			global.level_pos = $goldKnight.position
			global.trx = true
			get_tree().change_scene_to_file("res://Scene/Main.tscn")

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
	global.game_is_started = true
	pass # Replace with function body.


func _on_gold_knight_is_close_to_level():
	is_close_to_level = !is_close_to_level
	pass # Replace with function body.
