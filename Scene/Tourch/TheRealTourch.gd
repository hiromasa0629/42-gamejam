extends Node2D

@onready var animation = $TorchAnimation
@onready var light = $PointLight2D

var player = null

func _ready():
	animation.animation = "blue_out"
	animation.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if (body.name == "Player"):
		player = body
		body.handle_toggle_bubble_e(self)

func _on_area_2d_body_exited(body):
	if (body.name == "Player"):
		body.handle_toggle_bubble_e(self)

func win():
	light.enabled = true
	player.handle_toggle_bubble_e(self)
	animation.animation = "blue_fire"
	
