extends Node

@onready var duration_timer = $DurationTimer

var parry_slash = preload("res://Objects/ParryObjects/parry_slash.tscn")
var parry

const RECOVERY_WINDOW = 1.0
const POSITION_PADDING = 4.5

var duration = 0.16  # 10 frames
var can_parry = true

var angle 


func start_parry(position):
	parry = parry_slash.instantiate()
	parry.position = (get_parent().player_crosshair.position / POSITION_PADDING) + position
	add_child(parry)
	
	angle = get_parent().parry_angle
	parry.set_rotation_degrees(angle)
	
	duration_timer.wait_time = duration
	duration_timer.start()
	can_parry = false


func in_recovery():
	return !duration_timer.is_stopped()


func end_parry():
	await get_tree().create_timer(RECOVERY_WINDOW).timeout
	can_parry = true


func _on_duration_timer_timeout():
	end_parry()
