extends Area2D

@export var speed = 3

var direction: Vector2 = Vector2.ZERO
var original_position: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = position
	target_position = get_global_mouse_position()
	direction = (target_position - position).normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = lerp(position, target_position, speed * delta)
