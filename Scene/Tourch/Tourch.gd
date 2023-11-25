extends AnimatedSprite2D

@export var speed = 3
@onready var light = $PointLight2D

var target_position: Vector2 = Vector2.ZERO
var is_colliding : bool = false
var body_queue = []

# Called when the node enters the scene tree for the first time.
func _ready():
	play()
	target_position = get_global_mouse_position()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "rotation", randi_range(-5, 5), 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!is_colliding):
		position = lerp(position, target_position, speed * delta)

func _on_timer_timeout():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.connect("finished", on_tween_finished)
	tween.tween_property(light, 'energy', 0, 1.2)

func on_tween_finished():
	while (!body_queue.is_empty()):
		var body = body_queue.pop_front()
		body.tourch_exited(self)
	queue_free()

func _on_collided_body_entered(body):
	if (!body.name == "Player"):
		is_colliding = true

func _on_enemy_detection_body_entered(body):
	if (body.is_in_group("Enemy")):
		body_queue.push_back(body)
		body.tourch_entered(self)
