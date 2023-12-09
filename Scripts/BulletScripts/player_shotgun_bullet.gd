extends CharacterBody2D

const SPEED = 1000
const TIME_TO_LIVE = 0.35

var direction

var damage = 7

@onready var time_to_die = $DeathTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(position + direction)
	time_to_die.wait_time = TIME_TO_LIVE
	time_to_die.start()


# Destroy self after a certain period of time
func kill_bullet():
	await time_to_die.timeout
	queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = direction * SPEED
	move_and_slide()
	
	kill_bullet()
