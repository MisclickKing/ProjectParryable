extends CharacterBody2D

# Player Character Variables
const STARTING_HEALTH = 3
var current_health = STARTING_HEALTH

const SPEED = 850.0
const DASH_SPEED = 2500.0

const DASH_DURATION = 0.15
const SHIELD_ONE_DURATION = 5.0

var crosshair_range = 650
var crosshair_buffer = 150

var ammo_type = "normal"

# Control Variaables
var move_direction
var look_direction
var bullet_direction

var shotgun_angle
var parry_angle

var screen_size
var border_padding_x = 80
var border_padding_y = 120

# Get Node Variables
@onready var player_sprite = $Sprite2D
@onready var player_crosshair = $Marker2D
@onready var player_crosshair_sprite = $Marker2D/Sprite2D

@onready var player_dash = $Dash_Normal
@onready var player_normal_attack = $Attack
@onready var player_parry = $Parry
@onready var shield = $Shield
@onready var missiles = $Missiles



# Function called at the start of runtime
func _ready():
	screen_size = get_viewport_rect().size


# Get 360 degree input for movement
func get_move_direction():
	move_direction = Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
	return move_direction


# Get 360 degree input for look direction
func get_look_direction():
	# Use mouse if controller 0 not found
	if (Input.get_connected_joypads().size() == 0):
		look_direction = rad_to_deg(position.angle_to_point(get_global_mouse_position()))
		
	# Use right thumb stick if controller 0 found
	else :
		look_direction = rad_to_deg((Input.get_vector("Look_Left", "Look_Right", "Look_Up", "Look_Down")).angle())
		
	#print(look_direction)


# Move player normally unless dashing
func move():
	if player_parry.can_parry != false:
		velocity = (move_direction * DASH_SPEED) if player_dash.is_dashing() else (move_direction * SPEED)
	else:
		velocity = move_direction * 0


# Limit player area to screen size
func player_borders():
	position.x = clamp(position.x, border_padding_x, screen_size.x - border_padding_x)
	position.y = clamp(position.y, border_padding_y, screen_size.y - border_padding_y)
	#print(position)


func flip_sprite():
	if look_direction >= -90 and look_direction <= 90:
		player_sprite.set_flip_h(true)
		$CollisionBox.position.x = 0
		$HurtBox/CollisionBox.position.x = 0
	else:
		player_sprite.set_flip_h(false)
		$CollisionBox.position.x = 0
		$HurtBox/CollisionBox.position.x = 0


# Moves player crosshair and determines where the player's bullets go
func aim():
	# 0 / 360 degrees
	if look_direction >= -22.5 and look_direction < 22.5:
		player_crosshair.position = Vector2(crosshair_range, 0)
		bullet_direction = Vector2(1, 0)
		
		shotgun_angle = Vector2(0, .25)
		parry_angle = 0
		
	# 45 degrees
	elif look_direction >= -67.5 and look_direction < -22.5:
		player_crosshair.position = Vector2(crosshair_range - crosshair_buffer, -crosshair_range + crosshair_buffer)
		bullet_direction = Vector2(.75, -.75)
		
		shotgun_angle = Vector2(0.25, 0.25)
		parry_angle = -45
		
	# 90 degrees
	elif look_direction >= 67.5 and look_direction < 112.5:
		player_crosshair.position = Vector2(0, crosshair_range)
		bullet_direction = Vector2(0, 1)
		
		shotgun_angle = Vector2(.25, 0)
		parry_angle = 90
		
	# 135 degrees
	elif look_direction >= -157.5 and look_direction < -112.5:
		player_crosshair.position = Vector2(-crosshair_range + crosshair_buffer, -crosshair_range + crosshair_buffer)
		bullet_direction = Vector2(-.75, -.75)
		
		shotgun_angle = Vector2(-.25, .25)
		parry_angle = 45
		
	# 180 degrees
	elif (look_direction >= 157.5 and look_direction < 180) or (look_direction >= -180 and look_direction < -157.5):
		player_crosshair.position = Vector2(-crosshair_range, 0)
		bullet_direction = Vector2(-1, 0)
		
		shotgun_angle = Vector2(0, .25)
		parry_angle = 0
		
	# 225 degrees
	elif look_direction >= 112.5 and look_direction < 157.5:
		player_crosshair.position = Vector2(-crosshair_range + crosshair_buffer, crosshair_range - crosshair_buffer)
		bullet_direction = Vector2(-.75, .75)
		
		shotgun_angle = Vector2(0.25, 0.25)
		parry_angle = -45
		
	# 270 degrees
	elif look_direction >= -112.5 and look_direction < -67.5:
		player_crosshair.position = Vector2(0, -crosshair_range)
		bullet_direction = Vector2(0, -1)
		
		shotgun_angle = Vector2(0.25, 0)
		parry_angle = 90
		
	# 315 degrees
	elif look_direction >= 22.5 and look_direction < 67.5:
		player_crosshair.position = Vector2(crosshair_range - crosshair_buffer, crosshair_range - crosshair_buffer)
		bullet_direction = Vector2(.75, .75)
		
		shotgun_angle = Vector2(-.25, .25)
		parry_angle = 45
	
	flip_sprite()


# Uses the currently equiped evasive special
func dash():
	if Input.is_action_just_pressed("Dash") and player_dash.can_dash and !player_dash.is_dashing():
		if player_parry.can_parry != false:
			player_dash.start_dash(DASH_DURATION)


# Swap ammo types
func swap_ammo():
	if Input.is_action_just_pressed("Swap_Ammo") and ammo_type == "normal":
		ammo_type = "shotgun"
		crosshair_range = 450
		player_crosshair_sprite.texture = load("res://Sprites/kenney_crosshair-pack/PNG/Outline Retina/crosshair027.png")
	
	elif Input.is_action_just_pressed("Swap_Ammo") and ammo_type == "shotgun":
		ammo_type = "normal"
		crosshair_range = 650
		player_crosshair_sprite.texture = load("res://Sprites/kenney_crosshair-pack/PNG/Outline Retina/crosshair037.png")


# Shoot currently equiped weapon
func attack():
	if Input.is_action_pressed("Attack") and !player_normal_attack.fire_rate():
		if player_parry.can_parry != false:
			player_normal_attack.attack(position)


# Activate parry ability
func parry():
	if Input.is_action_just_pressed("Parry") and player_parry.can_parry and !player_parry.in_recovery() and !shield.shield_on():
		player_parry.start_parry(position)


# Activate specail ability 1
func special_1():
	if Input.is_action_just_pressed("Special_1") and shield.can_shield and !shield.shield_on():
		if player_parry.can_parry != false:
			shield.start_shield(SHIELD_ONE_DURATION, position)
	
	# Update the shields position based on players position
	if shield.shield_on():
		var barrier = shield.return_shield()
		barrier.position = position


# Activate specail ability 2
func special_2():
	if Input.is_action_just_pressed("Special_2"):
		if player_parry.can_parry != false:
			pass

func die():
	if current_health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")

# Called every acive frame
func _physics_process(delta):
	get_move_direction()
	get_look_direction()
	
	aim()
	
	move()
	dash()
	move_and_slide()
	
	swap_ammo()
	attack()
	parry()
	special_1()
	special_2()
	
	player_borders()
	print(current_health)


func _on_hurt_box_area_entered(area):
	if(area.name == "BossHurtBox"):
		current_health -= 1
