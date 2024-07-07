extends Projectile

@onready var area_damage_emitter:AreaDamageEmitter = $AreaDamageEmitter

const sounds = [ 
	preload("res://assets/sfx/Ovani/Bazooka Blast Close 001.wav"),
	preload("res://assets/sfx/Ovani/Bazooka Blast Close 002.wav"),
	preload("res://assets/sfx/Ovani/Bazooka Blast Close 003.wav"),
	preload("res://assets/sfx/Ovani/Bazooka Blast Close 004.wav"),
	preload("res://assets/sfx/Ovani/Bazooka Blast Close 005.wav")
	]

func on_hit(hit_collider: Node3D, hit_pos:Vector3, hit_normal: Vector3)->void:
	area_damage_emitter.damage = damage
	area_damage_emitter.attack()
	$ExplosionFireBall.restart()
	var player = AudioManager.play_sound3D(sounds.pick_random())
	player.global_position = global_position
	super(hit_collider, hit_pos, hit_normal)
