extends CharacterBody2D

@export var move_speed: float = 120
@export var player: CharacterBody2D

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var nav_agent = $NavigationAgent2D
@onready var raycast_up = $RayCast2DUp
#@onready var raycast_up = $ShapeCast2D
@onready var raycast_down = $RayCast2DDown

var bullet = preload("res://Scene/Bullet/HGBullet.tscn")
var can_fire = true
var fire_rate : float = 1
var in_range : bool = false
var target: CharacterBody2D

func _ready():
	await get_tree().process_frame
	target = get_tree().get_nodes_in_group("Player")[0]
	make_path()

func _physics_process(delta):
	velocity = Vector2.ZERO
	target = get_tree().get_nodes_in_group("Player")[0]
	look_at(target.global_position)
	#rotation = velocity.angle()
	if (raycast_up.is_colliding() and raycast_up.get_collider().is_in_group("Player")):
		#and raycast_down.is_colliding() and raycast_down.get_collider().is_in_group("Player")):
		in_range = true
		if (can_fire == true):
			fire()
	if (in_range == false):
		var direction = global_position.direction_to(nav_agent.get_next_path_position())
		velocity = direction * move_speed
		move_and_slide()
	pick_new_state()
	in_range = false


func make_path():
	nav_agent.target_position = target.global_position

func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

func _on_timer_timeout():
	make_path()
	
func fire():
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = $BulletSpawnPoint.global_position
	bullet_instance.target = target.position
	get_tree().get_root().add_child(bullet_instance)
	can_fire = false
	await(get_tree().create_timer(fire_rate).timeout)
	can_fire = true
