extends CharacterBody2D

const STARTING_HEALTH = 5000

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var damage_taken

@onready var health = STARTING_HEALTH
@onready var wait_time_start = 3.0
@onready var wait_time_stun = 5.0

# Positions
var new_pos

var pos1 = Vector2(250, 200)
var pos2 = Vector2(250, 540)
var pos3 = Vector2(250, 880)

var pos4 = Vector2(960, 200)
var pos5 = Vector2(960, 540)
var pos6 = Vector2(960, 880)

var pos7 = Vector2(1670, 880)
var pos8 = Vector2(1670, 540)
var pos9 = Vector2(1670, 200)


var pos_array = [pos1, pos2, pos3, pos7, pos8, pos9, pos4, pos5, pos6]

func _ready():
	# Wait before boss can do anything
	$WaitTimer.wait_time = wait_time_start
	$WaitTimer.start()
	await $WaitTimer.timeout
	change_pos()


func flip_sprite():
	if position.x <= 960:
		$Sprite2D.set_flip_h(true)
		$CollisionShape2D.position.x = -42
		$HurtBox/CollisionShape2D.position = $CollisionShape2D.position
		
	else:
		$Sprite2D.set_flip_h(false)
		$CollisionShape2D.position.x = 42
		$HurtBox/CollisionShape2D.position = $CollisionShape2D.position


func change_pos():
	var rand_num = randi() % 9
	new_pos = pos_array[rand_num]
	
	var tween = create_tween()
	tween.tween_property(self, "position", new_pos, 1)
	

func update_health(damage):
	health -= damage


func die():
	if health <= 0:
		queue_free()


func _on_area_2d_area_entered(bullet):
	if(bullet.name == "PlayerBulletHitBox"):
		damage_taken = bullet.get_parent().damage
		update_health(damage_taken)
		bullet.get_parent().queue_free()


func _physics_process(delta):
	flip_sprite()
	die()
	#print(health)
