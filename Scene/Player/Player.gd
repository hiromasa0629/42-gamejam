extends CharacterBody2D

@export var move_speed: float = 150

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

var bullet = preload("res://Scene/Bullet/HGBullet.tscn")
var can_fire = true
var fire_rate : float = 1

func _physics_process(delta):
	
#	rotate(get_angle_to(get_global_mouse_position()))
	look_at(get_global_mouse_position())
	
	if (Input.is_action_pressed("left_click") and can_fire):
		fire()
	
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
		
func fire():
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = $BulletSpawnPoint.global_position
	bullet_instance.target = get_global_mouse_position()
	get_tree().get_root().add_child(bullet_instance)
	can_fire = false
	await(get_tree().create_timer(fire_rate).timeout)
	can_fire = true
