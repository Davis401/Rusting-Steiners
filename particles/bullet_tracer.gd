extends Node3D

var speed = 100
var direction:Vector3
@export var start:Vector3
@export var end:Vector3

func _ready():
	speed = randf_range(20.0,100.0)
	global_position = start
	direction = start.direction_to(end).normalized()
	
func _process(delta):
	global_position += direction * speed * delta
	if global_position == end:
		queue_free()


func _on_timer_timeout():
	queue_free()
