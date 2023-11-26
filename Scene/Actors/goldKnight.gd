extends CharacterBody2D

@export var move_speed: float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var bubble_sfx = $BubbleSFX

signal is_close_to_level

func _ready():
	update_animation_params(starting_direction)
	

func _physics_process(_delta):
	
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	).normalized()
	update_animation_params(input_direction)
	
	velocity = input_direction * move_speed
	move_and_slide()
	
func update_animation_params(move_input: Vector2):
	if (move_input != Vector2.ZERO):
		state_machine.travel("Walk")
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
		if (!$WalkSFX.playing):
			$WalkSFX.play()
	else:
		state_machine.travel("Idle")
		if ($WalkSFX.playing):
			$WalkSFX.stop()

func handle_toggle_bubble_e(i : int):
	bubble_sfx.play()
	$ESpeedBubble.visible = !$ESpeedBubble.visible
	emit_signal("is_close_to_level", i)
	
