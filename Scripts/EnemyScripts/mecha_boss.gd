extends CharacterBody2D

const STARTING_HEALTH = 500

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var damage_taken

@onready var health = STARTING_HEALTH
@onready var wait_time_start = 3.0

var time_to_change = false


var time_to_move = 10.0
var wait_to_act = 3.0
var wait_to_move = 2.0
var wait_time_stun = 5.0

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
	time_to_change = true


func flip_sprite():
	if position.x <= 960:
		$Sprite2D.set_flip_h(true)
		$CollisionShape2D.position.x = -42
		$BossHurtBox/CollisionShape2D.position = $CollisionShape2D.position
		
	else:
		$Sprite2D.set_flip_h(false)
		$CollisionShape2D.position.x = 42
		$BossHurtBox/CollisionShape2D.position = $CollisionShape2D.position


func change_pos():
	var rand_num = randi() % 9
	new_pos = pos_array[rand_num]
	position = new_pos
	


func act():
	if time_to_change == true:
		change_pos()
		$WaitTimer.wait_time = time_to_move
		$WaitTimer.start()
		time_to_change = false
		await $WaitTimer.timeout
		time_to_change = true


func update_health(damage):
	health -= damage


func attack():
	var normal_bullet = preload("res://Objects/BulletObjects/EnemyBulletObjects/enemy_bullet.tscn")
	var parry_bullet = preload("res://Sprites/Bullets/EnemyBullets/enemy_bullet_parryable.png")
	
	var norm_b
	var parry_b

	if time_to_change == false:
		var direction = position - get_parent().get_node("Player").position 
		var rand_attack_num = randi() % 10
		if rand_attack_num <= 6:
			norm_b = normal_bullet.instantiate()
			norm_b.direction = direction
		elif rand_attack_num > 6:
			parry_b = parry_bullet.instantiate()
			parry_b.direction = direction


func die():
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")


func _on_area_2d_area_entered(bullet):
	if(bullet.name == "PlayerBulletHitBox"):
		damage_taken = bullet.get_parent().damage
		update_health(damage_taken)
		bullet.get_parent().queue_free()


func _physics_process(delta):
	
	flip_sprite()
	act()
	die()
	#print(health)
