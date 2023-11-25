extends CharacterBody2D

@export var move_speed: float = 120
@export var matches_left: int = 10

@onready var tourch_light = $Area2D/PointLight2D


var tourch = preload("res://Scene/Tourch/Tourch.tscn")
var can_throw = true
var finish_tourch : Node2D = null

signal playerspotted
signal playernotspotted
signal gameover

@export var starting_direction : Vector2 = Vector2(0, 1)
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var match_counter = $Match
@onready var bubble_sfx = $BubbleSFX

func _ready():
	match_counter.set_count(matches_left)
	update_animation_params(starting_direction)

func _physics_process(delta):
	if (finish_tourch and Input.is_action_just_pressed("E")):
		finish_tourch.win()
		tourch_light.enabled = false
		update_animation_params(Vector2.ZERO)
		return
	if (Input.is_action_just_pressed("left_click") and can_throw):
		throw()
	if (Input.is_action_just_pressed("SpaceBar")):
		switch_torch_light()
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	).normalized()
	update_animation_params(input_direction)
	velocity = input_direction * move_speed
	move_and_slide()

		
func switch_torch_light():
	if (!tourch_light.enabled):
		matches_left -= 1
		match_counter.decrement()
		tourch_light.enabled = true
		emit_signal("playerspotted")
	elif (tourch_light.enabled):
		if (matches_left <= 0):
			emit_signal("gameover")
		tourch_light.enabled = false
		emit_signal("playernotspotted")
		
func _on_area_2d_body_entered(body):
	if (body.is_in_group("Enemy")):
		body.handle_player_entered()

func _on_area_2d_body_exited(body):
	if (body.is_in_group("Enemy")):
		body.handle_player_exited()

func throw():
	if (tourch_light.enabled):
		tourch_light.enabled = false
	elif (!tourch_light.enabled):
		matches_left -= 1
		match_counter.decrement()
	if (matches_left <= 0):
		emit_signal("gameover")
	emit_signal("playernotspotted")
	var tourch_instance = tourch.instantiate()
	tourch_instance.position = position
	get_tree().get_root().add_child(tourch_instance)
	can_throw = true

	
func update_animation_params(move_input: Vector2):
	if (move_input != Vector2.ZERO):
		state_machine.travel("Walk")
		animation_tree.set("parameters/Walk/blend_position", move_input)
		if (!$WalkSFX.playing):
			$WalkSFX.play()
	else:
		state_machine.travel("Idle")
		animation_tree.set("parameters/Idle/blend_position", move_input)
		if ($WalkSFX.playing):
			$WalkSFX.stop()
		
func _on_enemy_kill_zone_body_entered(body):
	if (body.is_in_group("Enemy")):
		emit_signal("gameover")

func handle_toggle_bubble_e(tourch):
	bubble_sfx.play()
	$ESpeedBubble.visible = !$ESpeedBubble.visible
	if ($ESpeedBubble.visible):
		finish_tourch = tourch
	else:
		finish_tourch = null
		
	
