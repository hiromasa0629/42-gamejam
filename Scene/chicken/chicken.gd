extends CharacterBody2D

var speed : float = 20
var move_direction : Vector2 = Vector2.ZERO
var idle_time = 5
var walk_time = 3

@onready var timer = $Timer
@onready var animation = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	change_state()
	animation.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (animation.animation == "walk"):
		velocity = move_direction * speed
		move_and_slide()

func select_new_direction():
	move_direction = Vector2(
		randi_range(-1, 1),
		randi_range(-1, 1)
	)
	
	if (move_direction.x < 0):
		animation.flip_h = true
	elif (move_direction.x > 0):
		animation.flip_h = false

func change_state():
	if (animation.animation == "idle"):
		animation.animation = "walk"
		select_new_direction()
		timer.start(walk_time)
	elif (animation.animation == "walk"):
		animation.animation = "idle"
		timer.start(idle_time)
		

func _on_timer_timeout():
	change_state()
