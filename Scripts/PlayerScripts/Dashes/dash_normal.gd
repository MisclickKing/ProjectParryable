extends Node

@onready var duration_timer = $DurationTimer

const DASH_DELAY = 0.5
var can_dash = true

func start_dash(duration):
	duration_timer.wait_time = duration
	duration_timer.start()


func is_dashing():
	return !duration_timer.is_stopped()


func end_dash():
	can_dash = false
	await get_tree().create_timer(DASH_DELAY).timeout
	can_dash = true


func _on_duration_timer_timeout():
	end_dash()
