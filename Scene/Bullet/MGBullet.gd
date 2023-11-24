extends Area2D

@export var speed = 400
@export var bullet_range = 250

var target: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var original_position: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = position
	target = get_global_mouse_position()
	direction = (target - position).normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta
	if original_position.distance_to(position) > bullet_range:
		queue_free()

