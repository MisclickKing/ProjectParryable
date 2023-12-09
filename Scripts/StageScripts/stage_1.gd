extends Node

@onready var player = $PlayerController
@onready var boss = $MechaBoss

# Called when the node enters the scene tree for the first time.
func _ready():
	player.position = Vector2(250, 540)
	boss.position = Vector2(1670, 540)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
