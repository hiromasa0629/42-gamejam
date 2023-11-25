extends CharacterBody2D

@export var move_speed: float = 150
@export var matches_left: int = 10

@onready var tourch_light = $Area2D/PointLight2D
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

var bullet = preload("res://tourch.tscn")
var can_throw = true

signal playerspotted

func _physics_process(delta):
	
#	rotate(get_angle_to(get_global_mouse_position()))
	look_at(get_global_mouse_position())
	
	if (Input.is_action_just_pressed("left_click") and can_throw):
		throw()
	if (Input.is_action_just_pressed("SpaceBar")):
		switch_torch_light()
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	)
	velocity = input_direction * move_speed
	move_and_slide()
	pick_new_state()
	
func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
		
func switch_torch_light():
	if (!tourch_light.enabled):
		matches_left -= 1
		print(matches_left)
	if (tourch_light.enabled and matches_left == 0):
		print("death")
	tourch_light.enabled = !tourch_light.enabled
	emit_signal("playerspotted")
		
func _on_area_2d_body_entered(body):
	if (body.is_in_group("Enemy")):
		body.handle_player_entered()

func _on_area_2d_body_exited(body):
	if (body.is_in_group("Enemy")):
		body.handle_player_exited()

func throw():
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = position
	get_tree().get_root().add_child(bullet_instance)
	can_throw = true
