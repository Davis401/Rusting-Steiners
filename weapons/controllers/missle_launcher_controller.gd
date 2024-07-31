class_name MissleLauncher
extends WeaponController

signal locking_on_target
signal max_lock_ons
signal release

const MAX_TARGETS_NOISE = preload("res://assets/sfx/EchoesAudioPack/analog_computer_beep_1.mp3")
const TARGET_LOCK_NOISE = preload("res://assets/sfx/EchoesAudioPack/analog_computer_beep_2.mp3")
const OUT_OF_AMMO_NOISE = preload("res://assets/sfx/EchoesAudioPack/analog_computer_beep_3.mp3")
const LAUNCH_SOUNDS = [preload("res://assets/sfx/Ovani/Missile Start 001.wav"), preload("res://assets/sfx/Ovani/Missile Start 002.wav"), preload("res://assets/sfx/Ovani/Missile Start 003.wav")]

@export var max_targets:int
@export var ammo_count:int
@export var lock_on_time:float

var targets:Array[Node3D]
var locking_on:bool = false
var firing:bool = false
var lock_on_target:Node3D
var fire_delay:float = 0.2

@onready var lock_on_timer:Timer = $LockOnTimer
@onready var audio_stream_player = $AudioStreamPlayer
@onready var attack_emitter = $AttackEmitter


func _ready():
	super()
	if spawn_point_node != null:
		attack_emitter.global_position = spawn_point_node.global_position
	if Global.current_build.head != null:
		lock_on_time = Global.current_build.head.missile_lock_on_time


#Called every frame is pressed
func on_hold()->void:
	if locking_on || targets.size() >= max_targets || firing:
		return
		
	if targets.size() == current_ammo:
		audio_stream_player.stream = OUT_OF_AMMO_NOISE
		audio_stream_player.play()
		return
	
	var lock_on_nodes = get_tree().get_nodes_in_group("lock_on_target")
	for node in lock_on_nodes:
		if camera.is_position_in_frustum(node.global_position) and !node.locked_on && global_position.distance_to(node.global_position) < Global.current_build.head.max_lock_range:
			if lock_on_target == null:
				lock_on_target = node
			elif node.global_position.distance_to(camera.global_position) < lock_on_target.global_position.distance_to(camera.global_position):
				lock_on_target = node
	
	if lock_on_target != null:
		locking_on = true
		locking_on_target.emit()
		lock_on_timer.start(lock_on_time)
	

#Called when released
func on_release()->void:
	release.emit()
	if firing:
		return
	if !lock_on_timer.paused:
		lock_on_timer.stop()
	if targets.size() > 0:
		firing = true
		while targets.size() > 0:
			await get_tree().create_timer(fire_delay).timeout
			var t = targets.pop_front()
			if t != null || is_instance_valid(t):
				attack_emitter.attack(t)
				current_ammo -= 1
				t.locked_on = false
				var sfx_player = AudioManager.play_sound3D(LAUNCH_SOUNDS.pick_random(), true)
				sfx_player.volume_db = -20.0
		firing = false
		
	targets = []
	locking_on = false


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
			max_lock_ons.emit()
			audio_stream_player.stream = MAX_TARGETS_NOISE
			audio_stream_player.play()
