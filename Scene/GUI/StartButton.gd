extends CanvasLayer

signal StartButtonClick
# Called when the node enters the scene tree for the first time.
func _ready():
	if (global.game_is_started):
		hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	emit_signal("StartButtonClick")
