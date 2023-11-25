extends CharacterBody2D

@export var move_speed: float = 150
@export var player: CharacterBody2D

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var nav_agent = $NavigationAgent2D

var is_in_range: bool = false
var is_light_on: bool = false
var chase_tourch: bool = false

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
	look_at(target.global_position)

	if (chase_tourch):
		var direction = (tourch_target.position - position).normalized()
		velocity = direction * move_speed
		move_and_slide()
	elif (is_light_on and is_in_range):
		var direction = global_position.direction_to(nav_agent.get_next_path_position())
		velocity = direction * move_speed
		move_and_slide()
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
	
func handle_player_not_spotted():
	is_light_on = false

func handle_player_entered():
	is_in_range = true

func handle_player_exited():
	is_in_range = false

func tourch_entered(tourch):
	tourch_target = tourch
	chase_tourch = true

func tourch_exited(tourch):
	if (tourch_target and tourch_target == tourch):
		chase_tourch = false
		tourch_target = null
