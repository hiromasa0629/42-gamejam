extends CharacterBody2D

@export var move_speed: float = 200
@export var player: CharacterBody2D

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var ghost_sprite = $GhostFull2D
@onready var ghost_eyes_sprite = $GhostEyes2D

@onready var nav_agent = $NavigationAgent2D
@onready var enemy_eye = $EnemyEyeLight

@onready var chase_delay = $ChaseDelay

var is_in_range: bool = false
var is_light_on: bool = true
var chase_tourch: bool = false
var is_chasing: bool = false

var target: CharacterBody2D
var tourch_target

func _ready():
	await get_tree().process_frame
	target = get_tree().get_nodes_in_group("Player")[0]
	target.connect("playerspotted", handle_player_spotted)
	target.connect("playernotspotted", handle_player_not_spotted)
	make_path()

func _physics_process(delta):
	velocity = Vector2.ZERO
	target = get_tree().get_nodes_in_group("Player")[0]
	move_speed = 200
	if (is_chasing):
		if (chase_tourch):
			var direction = (tourch_target.position - position).normalized()
			handle_animation(direction, tourch_target, 15)
			velocity = direction * move_speed
			move_and_slide()
		elif (is_light_on and is_in_range):
			var direction = global_position.direction_to(nav_agent.get_next_path_position())
			handle_animation(direction, target, 25)
			velocity = direction * move_speed
			move_and_slide()
		else:
			is_chasing = false
			enemy_eye.enabled = false

	pick_new_state()

func make_path():
	nav_agent.target_position = target.global_position

func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

func _on_timer_timeout():
	make_path()
	
func handle_player_spotted():
	is_light_on = true
	if (is_in_range and !is_chasing):
		start_delay_timer()
	
func handle_player_not_spotted():
	is_light_on = false

func handle_player_entered():
	is_in_range = true
	if (is_light_on and !is_chasing):
		start_delay_timer()

func handle_player_exited():
	is_in_range = false

func tourch_entered(tourch):
	tourch_target = tourch
	chase_tourch = true
	if (!is_chasing):
		start_delay_timer()

func tourch_exited(tourch):
	if (tourch_target and tourch_target == tourch):
		chase_tourch = false
		tourch_target = null


func update_animation_params(move_input: Vector2):
	if (move_input != Vector2.ZERO):
		state_machine.travel("Walk")
		animation_tree.set("parameters/Walk/blend_position", move_input)
		
	else:
		state_machine.travel("Idle")
		animation_tree.set("parameters/Idle/blend_position", move_input)
		

func play_death():
	state_machine.travel("Vaporize")
	animation_tree.set("parameters/Vaporize/blend_position", Vector2(0,0))
	
func handle_animation(input_direction, target, i):
	if (input_direction.x < 0):
		ghost_sprite.flip_h = true
		ghost_eyes_sprite.flip_h = true
	else:
		ghost_sprite.flip_h = false
		ghost_eyes_sprite.flip_h = false
	if (position.distance_to(target.position) < i):
		move_speed = 0	
	update_animation_params(input_direction)
	
func start_delay_timer():
	$EyeLightUp.play()
	enemy_eye.enabled = true
	chase_delay.start()

func stop_chasing():
	is_chasing = false

func _on_chase_delay_timeout():
	is_chasing = true
