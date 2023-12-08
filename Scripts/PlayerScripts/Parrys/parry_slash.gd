extends Sprite2D

@onready var animation = $AnimationPlayer

var duration = 0.16  # 10 frames


# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("parry")
	await get_tree().create_timer(duration).timeout
	queue_free()
