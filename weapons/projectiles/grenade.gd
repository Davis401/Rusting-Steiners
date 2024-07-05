class_name Grenade
extends Projectile

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var drag = .1

func process_movement(delta)->void:
	last_pos = global_position
	global_position += -global_transform.basis.z * initial_speed * delta
	global_position += Vector3.DOWN * gravity * delta
	initial_speed -= drag * delta

const sounds = [ 
	preload("res://assets/sfx/Ovani/Bazooka Blast Close 001.wav"),
	preload("res://assets/sfx/Ovani/Bazooka Blast Close 002.wav"),
	preload("res://assets/sfx/Ovani/Bazooka Blast Close 003.wav"),
	preload("res://assets/sfx/Ovani/Bazooka Blast Close 004.wav"),
	preload("res://assets/sfx/Ovani/Bazooka Blast Close 005.wav")
	]

@onready var area_damage_emitter = $AreaDamageEmitter

func on_hit(hit_collider: Node3D, hit_pos:Vector3, hit_normal: Vector3)->void:
	area_damage_emitter.damage = damage
	area_damage_emitter.attack()
	var player = AudioManager.play_sound3D(sounds.pick_random(), true)
	player.global_position = global_position
	super(hit_collider, hit_pos, hit_normal)
