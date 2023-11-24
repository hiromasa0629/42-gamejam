extends CharacterBody2D

@export var move_speed: float = 120
@export var player: CharacterBody2D

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var nav_agent = $NavigationAgent2D

var in_range : bool = false
var target: CharacterBody2D

func _ready():
	await get_tree().process_frame
	target = null
	make_path()

func _physics_process(delta):
	
	velocity = Vector2.ZERO
	if (target):
		look_at(target.global_position)
		var direction = global_position.direction_to(nav_agent.get_next_path_position())
		velocity = direction * move_speed
		move_and_slide()
	pick_new_state()


func make_path():
	if (target):
		nav_agent.target_position = target.global_position

func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

func _on_timer_timeout():
	make_path()
	
func _on_spawn_time_timeout():
	$CollisionShape2D.disabled = true
	await(get_tree().create_timer(0.1).timeout)
	queue_free()

func _on_detection_body_entered(body):
	if (body.is_in_group("Enemy") and target == null):
		target = body

func _on_detection_body_exited(body):
	if (body.is_in_group("Enemy") and target == body):
		target = null

