extends CanvasLayer

const CHAR_READ_RATE = 0.05

@onready var textbox_container = $TextBoxContainer
@onready var start_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/StartSymbol
@onready var end_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/EndSymbol
@onready var textbox = $TextBoxContainer/MarginContainer/HBoxContainer/ScrollContainer/Text

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []
var tween : Tween

func _ready():
	print("Starting state: State.READY")
	hide_textbox()
	queue_text("Hi, nice to meet you")
	queue_text("Why is the scale weird")
	queue_text("what should I do to fix it omg!")
	queue_text("Long text will ruin the container and scale it up and up and up, how can I fix this also omg, omg, omg, long text, no long text or dialog hello world hello world hello world hello world hello world hello world hello wold")
	queue_text("Come again bye bye")

func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				textbox.visible_ratio = 1.0
				tween.stop()
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_textbox()

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	textbox.text = ""
	textbox_container.hide()

func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()

func display_text():
	var next_text = text_queue.pop_front()
	textbox.text = next_text
	textbox.visible_ratio = 0.0
	change_state(State.READING)
	show_textbox()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.connect("finished", on_tween_finished)
	tween.tween_property(textbox, 'visible_ratio', 1.0, len(next_text) * CHAR_READ_RATE)
	#tween.play()
	

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: State.READY")
		State.READING:
			print("Changing state to: State.READING")
		State.FINISHED:
			print("Changing state to: State.FINISHED")

func on_tween_finished():
	end_symbol.text = "v"
	change_state(State.FINISHED)
