extends Area2D

@export var speed = 3

@onready var light = $PointLight2D

var direction: Vector2 = Vector2.ZERO
var original_position: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = position
	target_position = get_global_mouse_position()
	direction = (target_position - position).normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = lerp(position, target_position, speed * delta)
	if (!position.is_equal_approx(target_position)):
		rotation += 9 * -1 * delta

func _on_timer_timeout():
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.connect("finished", on_tween_finished)
	tween.tween_property(light, 'energy', 0, 1.2)

func on_tween_finished():
	queue_free()
