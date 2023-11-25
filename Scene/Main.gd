extends Node2D

@onready var blur_rect = $Blur/BlurShader
@onready var blur_canvas = $Blur

var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
	pass
