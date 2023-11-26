extends CharacterBody2D

@export var move_speed: float = 120
@export var matches_left: int = 10
@export var BGM: AudioStreamPlayer2D

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
@onready var tourch_animation = $TourchAnimation


enum State {
	MIDDLE,
	SIDE
}

var current_state = State.SIDE

func _ready():
	tourch_light.energy = 0
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(tourch_light, "energy", 1, 1)
	tourch_animation.play()
	tourch_animation.animation = "red_fire"
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
		tourch_animation.animation = "red_fire"
		emit_signal("playerspotted")
	elif (tourch_light.enabled):
		if (matches_left <= 0):
			emit_signal("gameover")
		tourch_light.enabled = false
		tourch_animation.animation = "red_out"
		emit_signal("playernotspotted")
		
func _on_area_2d_body_entered(body):
	check_enemy_overlapping()
	if (body.is_in_group("Enemy")):
		if (check_enemy_overlapping() == 1):
			BGM.stop()
			$ChasingBGM.play()
		body.handle_player_entered()

func _on_area_2d_body_exited(body):
	if (body.is_in_group("Enemy")):
		if (check_enemy_overlapping() == 0):
			BGM.play()
			$ChasingBGM.stop()		
		body.handle_player_exited()

func check_enemy_overlapping() -> int:
	var count = 0
	var bodies = $Area2D.get_overlapping_bodies();
	for i in bodies.size():
		if (bodies[i].is_in_group("Enemy")):
			count += 1
	return count

func throw():
	$ThrowSFX.play()
	if (tourch_light.enabled):
		tourch_light.enabled = false
		tourch_animation.animation = "red_out"
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
		animation_tree.set("parameters/Idle/blend_position", move_input)
		if (move_input.y > 0):
			current_state = State.SIDE
		elif (move_input.y < 0):
			current_state = State.SIDE
		elif (move_input == Vector2(1,0)):
			current_state = State.MIDDLE
		elif (move_input == Vector2(-1,0)):
			current_state = State.MIDDLE
		if (!$WalkSFX.playing):
			$WalkSFX.play()
	else:
		state_machine.travel("Idle")
		if ($WalkSFX.playing):
			$WalkSFX.stop()
			
	match current_state:
		State.SIDE:
			tourch_animation.position = Vector2(13, -1)
			tourch_animation.rotation = 0.34
		State.MIDDLE:
			tourch_animation.position = Vector2.ZERO
			tourch_animation.rotation = 0

func _on_enemy_kill_zone_body_entered(body):
	if (body.is_in_group("Enemy")):
		emit_signal("gameover")

func player_death():
	emit_signal("gameover")

func handle_toggle_bubble_e(tourch):
	bubble_sfx.play()
	$ESpeedBubble.visible = !$ESpeedBubble.visible
	if ($ESpeedBubble.visible):
		finish_tourch = tourch
	else:
		finish_tourch = null
		
	
