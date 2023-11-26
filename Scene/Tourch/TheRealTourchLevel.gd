extends Node2D

@onready var animation = $TorchAnimation
@onready var torchlight = $PointLight2D

@export var level: int

func _ready():
	animation.play()
	if (level <= global.levels_cleared):
		animation.animation = "blue_fire"
	else :
		animation.animation = "blue_out"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if (body.name == "goldKnight"):
		if (animation.animation == "blue_fire"):
			$FireSFX.play()
		body.handle_toggle_bubble_e()

func _on_area_2d_body_exited(body):
	if (body.name == "goldKnight" and global.trx == false):
		if (animation.animation == "blue_fire"):
			$FireSFX.stop()
		body.handle_toggle_bubble_e()
