extends Sprite2D



func _on_area_2d_body_entered(body):
	if (body.name == "Player"):
		body.handle_toggle_bubble_e()

func _on_area_2d_body_exited(body):
	if (body.name == "Player"):
		body.handle_toggle_bubble_e()
