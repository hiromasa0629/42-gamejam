extends CanvasLayer

@onready var textbox = $HBoxContainer/MatchCount
var count :int = 0

func set_count(i):
	textbox.text = str(i)
	count = i

func decrement():
	count -= 1
	textbox.text = str(count)
	if (count == 0):
		textbox.add_theme_color_override("font_color", Color("ff0000"))
	
