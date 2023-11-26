extends CanvasLayer

const CHAR_READ_RATE = 0.01

@onready var textbox_container = $TextBoxContainer
@onready var start_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/StartSymbol
@onready var end_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/EndSymbol
@onready var textbox = $TextBoxContainer/MarginContainer/HBoxContainer/ScrollContainer/Text
@onready var audio_stream = $AudioStreamPlayer2D
@onready var popo_rect = $Popo
@onready var gold_knight_rect = $GoldKnight

signal InitialDialogueFinish

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []
var tween : Tween
var scene

var start_button_clicked: bool = false

func _ready():
	hide_textbox()
	queue_text("The village of Eldoria lay silent beneath an oppressive shroud of darkness.")
	queue_text("The once vibrant homes and lively streets now stood still, swallowed by an abyssal void.")
	queue_text("The storm had come, fierce and unrelenting, leaving only desolation in its wake.")
	queue_text("Only if someone can reignite the magical torch...")
	queue_text("Gold Knight, where are you...")
	queue_text("I am here!")
	

func _process(delta):
	if (!start_button_clicked || global.game_is_started):
		return

	if (text_queue.size() == 2):
		popo_rect.show()
	elif (text_queue.size() == 0):
		popo_rect.hide()
		gold_knight_rect.show()
		
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				textbox.visible_ratio = 1.0
				audio_stream.stop()
				tween.stop()
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_textbox()
				if (text_queue.is_empty()):
					emit_signal("InitialDialogueFinish")
					

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
	audio_stream.play()
	tween.tween_property(textbox, 'visible_ratio', 1.0, len(next_text) * CHAR_READ_RATE)
	

func change_state(next_state):
	current_state = next_state

func on_tween_finished():
	end_symbol.text = "v"
	audio_stream.stop()
	change_state(State.FINISHED)


func _on_start_button_start_button_click():
	start_button_clicked = true
