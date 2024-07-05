class_name MissleLauncher
extends WeaponController

const MAX_TARGETS_NOISE = preload("res://assets/sfx/EchoesAudioPack/analog_computer_beep_1.mp3")
const TARGET_LOCK_NOISE = preload("res://assets/sfx/EchoesAudioPack/analog_computer_beep_2.mp3")

@export var max_targets:int
@export var ammo_count:int
@export var lock_on_time:float

var targets:Array[Node3D]
var locking_on:bool = false
var lock_on_target:Node3D

@onready var lock_on_timer:Timer = $LockOnTimer
@onready var audio_stream_player = $AudioStreamPlayer

#Called every frame is pressed
func on_hold()->void:
	if locking_on || targets.size() >= max_targets:
		return
	var lock_on_nodes = get_tree().get_nodes_in_group("lock_on_target")
	for node in lock_on_nodes:
		if camera.is_position_in_frustum(node.global_position) and !node.locked_on:
			if lock_on_target == null:
				lock_on_target = node
			elif node.global_position.distance_to(camera.global_position) < lock_on_target.global_position.distance_to(camera.global_position):
				lock_on_target = node
	
	if lock_on_target != null:
		locking_on = true
		lock_on_timer.start(lock_on_time)

#Called when released
func on_release()->void:
	print("Released")
	if !lock_on_timer.paused:
		lock_on_timer.stop()
	while targets.size() > 0:
		var t = targets.pop_back()
		t.locked_on = false
	targets = []
		


func _on_lock_on_timer_timeout()->void:
	if lock_on_target != null:
		lock_on_target.locked_on = true
		targets.append(lock_on_target)
		lock_on_target = null
		locking_on = false
		if targets.size() < max_targets:
			audio_stream_player.stream = TARGET_LOCK_NOISE
			audio_stream_player.play()
		else:
			audio_stream_player.stream = MAX_TARGETS_NOISE
			audio_stream_player.play()
