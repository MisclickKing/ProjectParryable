extends Node

@onready var duration_timer = $DurationTimer
var shield = preload("res://Objects/SpecialAbilities/shield.tscn")
var barrier

const RECHARGE_DELAY = 15.0
var can_shield = true


func start_shield(duration, position):
	barrier = shield.instantiate()
	add_child(barrier)
	duration_timer.wait_time = duration
	duration_timer.start()


func shield_on():
	return !duration_timer.is_stopped()


func end_shield():
	barrier.queue_free()
	can_shield = false
	await get_tree().create_timer(RECHARGE_DELAY).timeout
	can_shield = true


func _on_duration_timer_timeout():
	end_shield()

func return_shield():
	return barrier
