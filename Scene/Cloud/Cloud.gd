extends Sprite2D

@export var speed = 20
@export var texture_array: Array = [
	preload("res://Art/Cloud/Cloud.png"),
	preload("res://Art/Cloud/Cloud2.png"),
	preload("res://Art/Cloud/Cloud3.png"),
	preload("res://Art/Cloud/Cloud4.png")
]

var direction: Vector2 = Vector2.ZERO
@export var free_point :Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = Vector2.RIGHT
	set_cloud_texture()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta
	if (position > free_point):
		queue_free()
	

func set_cloud_texture():
	if (texture_array.size() > 1):
		var id = randi() % texture_array.size()
		texture = texture_array[id]
		
