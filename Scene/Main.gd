extends Node2D

@export var torch :Node2D

@onready var blur_rect = $Blur/BlurShader
@onready var blur_canvas = $Blur
@onready var gameover_canvas = $GameOver
@onready var transition_canvas = $CanvasModulate

const level = 1

var tween: Tween
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	var map_limits = $TileMap.get_used_rect()
	var map_cellsize = $TileMap.tile_set.tile_size
	print(map_limits)
	print(map_cellsize)
	$Camera2D.limit_left = (map_limits.position.x * map_cellsize.x * 2) + 5
	$Camera2D.limit_right = (map_limits.end.x * map_cellsize.x * 2) - 5
	$Camera2D.limit_top = (map_limits.position.y * map_cellsize.y * 2) + 5
	$Camera2D.limit_bottom = (map_limits.end.y * map_cellsize.y * 2) - 5
	print($Camera2D.limit_left)
	print($Camera2D.limit_right)
	print($Camera2D.limit_top)
	print($Camera2D.limit_bottom)
	
	global.trx = false
	player = get_tree().get_nodes_in_group("Player")[0]
	player.connect("gameover", handle_gameover)
	torch.connect("winsignal", handle_win)
	await(get_tree().create_timer(5).timeout)
	

	$Instruction.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_tween_finished():
	gameover_canvas.show()
	
func handle_gameover():
	get_node("Player").get_node("ChasingBGM").stop()
	$GameOverSFX.play()
	player.set_process(false)
	player.set_physics_process(false)
	player.get_node("WalkSFX").stop()
	blur_canvas.show()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.connect("finished", on_tween_finished)
	tween.set_parallel(true)
	tween.tween_property(blur_rect.material, 'shader_parameter/size_x', 0.02, 0.7)
	tween.tween_property(blur_rect.material, 'shader_parameter/size_y', 0.02, 0.7)
	tween.tween_property($Camera2D, 'zoom', Vector2(8,8), 0.5)
	await(get_tree().create_timer(3.5).timeout)
	global.trx = true
	get_tree().change_scene_to_file("res://Scene/TileMap/LevelSelect2.tscn")
	
func handle_win():
	player.get_node("ChasingBGM").stop()
	$Level1BGM.stop()
	$VictorySFX.play()
	var enemy = get_tree().get_nodes_in_group("Enemy")
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($Camera2D, 'zoom', Vector2(2,2), 0.1)
	for i in enemy.size():
		enemy[i].set_physics_process(false)
		enemy[i].play_death()
	$WinGame.show()
	await(get_tree().create_timer(3.5).timeout)
	if (global.levels_cleared < level):
		global.levels_cleared += 1
	global.trx = true
	get_tree().change_scene_to_file("res://Scene/TileMap/LevelSelect2.tscn")
#	var tween2 = create_tween()
#	tween2.set_ease(Tween.EASE_IN_OUT)
#	tween2.set_trans(Tween.TRANS_LINEAR)
#	tween2.connect("finished", on_tween2_finished)
#	torch.get_node("PointLight2D").enabled = false
#	tween2.tween_property(transition_canvas, 'color', Color("ffffff"),1)

