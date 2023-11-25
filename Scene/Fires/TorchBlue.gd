extends AnimatedSprite2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if (body.name == "Player"):
		body.handle_toggle_bubble_e()

func _on_area_2d_body_exited(body):
	if (body.name == "Player"):
		body.handle_toggle_bubble_e()
