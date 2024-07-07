class_name Missile
extends Projectile

const sounds = [preload("res://assets/sfx/EchoesAudioPack/explosion_distant_1.mp3"), preload("res://assets/sfx/EchoesAudioPack/explosion_distant_2.mp3")]

@export var missile_target:Node3D

var rotation_speed = 30
var rot = Vector3()
var current_speed = initial_speed

@onready var area_damage_emitter = $AreaDamageEmitter

func _ready():
	super()
	current_speed = 1
	acceleration = 50

func _physics_process(delta)->void:
	process_movement(delta)
	check_collisions()

func process_movement(delta)->void:
	last_pos = global_position
	
	if missile_target != null:
		var direction = missile_target.global_transform.origin - global_transform.origin
		direction = direction.normalized()
		var rotate_amount = direction.cross(global_transform.basis.z)
		rot.y = rotate_amount.y * rotation_speed * delta
		rot.x = rotate_amount.x * rotation_speed * delta
		rotate(Vector3.UP, rot.y)
		rotate(Vector3.RIGHT,rot.x)
		
	global_position += -global_transform.basis.z * current_speed * delta
	current_speed = min(current_speed + (acceleration * delta), max_speed)
	
	
	
func on_hit(hit_collider: Node3D, hit_pos:Vector3, hit_normal: Vector3)->void:
	area_damage_emitter.damage = damage
	area_damage_emitter.attack()
	$ExplosionFireBall.restart()
	var player = AudioManager.play_sound3D(sounds.pick_random())
	player.global_position = global_position
	super(hit_collider, hit_pos, hit_normal)
