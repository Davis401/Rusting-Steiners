class_name Grenade
extends Projectile

var drag = 10

func _ready():
	super()
	area_damage_emitter.damage = 40

func process_movement(delta)->void:
	last_pos = global_position
	global_position += -global_transform.basis.z * initial_speed * delta
	global_position += Vector3.DOWN * 8 * delta
	initial_speed = max(initial_speed - (drag * delta), 0)

const sounds = [ 
	preload("res://assets/sfx/Ovani/Bazooka Blast Close 001.wav"),
	preload("res://assets/sfx/Ovani/Bazooka Blast Close 002.wav"),
	preload("res://assets/sfx/Ovani/Bazooka Blast Close 003.wav"),
	preload("res://assets/sfx/Ovani/Bazooka Blast Close 004.wav"),
	preload("res://assets/sfx/Ovani/Bazooka Blast Close 005.wav")
	]

@onready var area_damage_emitter = $AreaDamageEmitter

func on_hit(hit_collider: Node3D, hit_pos:Vector3, hit_normal: Vector3)->void:
	super(hit_collider, hit_pos, hit_normal)
	area_damage_emitter.attack()
	var sfx_player = AudioManager.play_sound3D(sounds.pick_random(), true)
	sfx_player.global_position = global_position
	$ExplosionFireBall.restart()
