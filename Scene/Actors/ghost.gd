extends CharacterBody2D

@export var move_speed: float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var vaporize = $AnimatedSprite2D
@onready var ghost_sprite = $GhostFull2D
@onready var ghost_eyes_sprite = $GhostEyes2D

func _ready():
	update_animation_params(starting_direction)

func _physics_process(delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	)
	if (input_direction.x < 0):
		ghost_sprite.flip_h = true
		ghost_eyes_sprite.flip_h = true
	else:
		ghost_sprite.flip_h = false
		ghost_eyes_sprite.flip_h = false

	if Input.is_key_label_pressed(KEY_E):
		activate_vaporize(input_direction)
	else:
		update_animation_params(input_direction)
	
	velocity = input_direction * move_speed
	move_and_slide()



func update_animation_params(move_input: Vector2):
	if (move_input != Vector2.ZERO):
		state_machine.travel("Walk")
		animation_tree.set("parameters/Walk/blend_position", move_input)
		
	else:
		state_machine.travel("Idle")
		animation_tree.set("parameters/Idle/blend_position", move_input)
		

func activate_vaporize(move_input: Vector2):
	state_machine.travel("Vaporize")
	animation_tree.set("parameters/Vaporize/blend_position", move_input)
