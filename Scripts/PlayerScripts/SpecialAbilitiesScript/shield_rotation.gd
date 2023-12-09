extends Node2D

@onready var sprite = $Sprite2D

var value = 0

func rotate_shield():
	sprite.set_rotation(value)
	value += 0.1
	if(value == 360):
		value = -360


func _on_hurtbox_area_entered(bullet):
	bullet.get_parent().queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_shield()
