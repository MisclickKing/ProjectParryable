extends Node

@onready var duration_timer = $DurationTimer

# Preload ammo types
var normal_bullet = preload("res://Objects/BulletObjects/PlayerBulletObjects/player_normal_bullet.tscn")
var shotgun_bullet = preload("res://Objects/BulletObjects/PlayerBulletObjects/player_shotgun_bullet.tscn")

# Ammo instances
var norm_bullet 

var shot_bullet_1
var shot_bullet_2
var shot_bullet_3
var shot_bullet_4
var shot_bullet_5

const NORMAL_BULLET_DELAY = 0.16
const SHOTGUN_BULLET_DELAY = 0.65
var attack_delay

const NORMAL_BULLET_PADDING = 4.5
const SHOTGUN_BULLET_PADDING = 3.5

var can_attack = true


func attack(position):
	# normal ammo type
	if get_parent().ammo_type == "normal":
		attack_delay = NORMAL_BULLET_DELAY
		
		norm_bullet = normal_bullet.instantiate()
		norm_bullet.position = (get_parent().player_crosshair.position / NORMAL_BULLET_PADDING) + position
		norm_bullet.direction = get_parent().bullet_direction
		add_child(norm_bullet)
		duration_timer.wait_time = attack_delay
		duration_timer.start()
		
	# shotgun ammo type
	elif get_parent().ammo_type == "shotgun":
		attack_delay = SHOTGUN_BULLET_DELAY
		
		var shotgun_angle = get_parent().shotgun_angle
		
		shot_bullet_1 = shotgun_bullet.instantiate()
		shot_bullet_2 = shotgun_bullet.instantiate()
		shot_bullet_3 = shotgun_bullet.instantiate()
		shot_bullet_4 = shotgun_bullet.instantiate()
		shot_bullet_5 = shotgun_bullet.instantiate()
		
		shot_bullet_1.position = (get_parent().player_crosshair.position / SHOTGUN_BULLET_PADDING) + position
		shot_bullet_2.position = (get_parent().player_crosshair.position / SHOTGUN_BULLET_PADDING) + position
		shot_bullet_3.position = (get_parent().player_crosshair.position / SHOTGUN_BULLET_PADDING) + position
		shot_bullet_4.position = (get_parent().player_crosshair.position / SHOTGUN_BULLET_PADDING) + position
		shot_bullet_5.position = (get_parent().player_crosshair.position / SHOTGUN_BULLET_PADDING) + position
		
		shot_bullet_1.direction = get_parent().bullet_direction
		shot_bullet_2.direction = (get_parent().bullet_direction + shotgun_angle) 
		shot_bullet_3.direction = (get_parent().bullet_direction - shotgun_angle) 
		shot_bullet_4.direction = (get_parent().bullet_direction + (shotgun_angle/2)) 
		shot_bullet_5.direction = (get_parent().bullet_direction - (shotgun_angle/2)) 
		
		add_child(shot_bullet_1)
		add_child(shot_bullet_2)
		add_child(shot_bullet_3)
		add_child(shot_bullet_4)
		add_child(shot_bullet_5)
		
		duration_timer.wait_time = attack_delay
		duration_timer.start()


func fire_rate():
	return !duration_timer.is_stopped()


func wait_to_attack():
	can_attack = false
	await get_tree().create_timer(attack_delay).timeout
	can_attack = true


func _on_duration_timer_timeout():
	wait_to_attack()
