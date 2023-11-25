extends Node2D

@onready var blur_rect = $Blur/BlurShader
@onready var blur_canvas = $Blur
@onready var gameover_canvas = $GameOver

var tween: Tween
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	player.connect("gameover", handle_gameover)

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
