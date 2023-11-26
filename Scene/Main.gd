extends Node2D

@export var torch :Node2D

@onready var blur_rect = $Blur/BlurShader
@onready var blur_canvas = $Blur
@onready var gameover_canvas = $GameOver


const level = 1

var tween: Tween
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	global.trx = false
	player = get_tree().get_nodes_in_group("Player")[0]
	player.connect("gameover", handle_gameover)
	torch.connect("winsignal", handle_win)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("testblur")):
		blur_canvas.show()
		tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.connect("finished", on_tween_finished)
		tween.set_parallel(true)
		tween.tween_property(blur_rect.material, 'shader_parameter/size_x', 0.017, 0.7)
		tween.tween_property(blur_rect.material, 'shader_parameter/size_y', 0.017, 0.7)
		
	pass

func on_tween_finished():
	gameover_canvas.show()
	
func handle_gameover():
	get_node("Player").get_node("ChasingBGM").stop()
	$GameOverSFX.play()
	player.set_process(false)
	player.set_physics_process(false)
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
