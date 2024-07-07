class_name Projectile
extends Node3D

@onready var collision_raycast = $CollisionRaycast

@export var max_speed = 300
@export var initial_speed = 30
@export var acceleration = 3
@export var show_after_time := 0.1
@export var delete_on_hit_after_time := -1.0

const MAX_PROJECTILE_LIFESPAN := 10.0
var bodies_to_exclude = []
var damage = 40

var last_pos : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() ->void:
	add_to_group("instantiated")
	hide()
	await get_tree().create_timer(show_after_time).timeout
	show()
	await get_tree().create_timer(MAX_PROJECTILE_LIFESPAN).timeout
	queue_free()
	

func _physics_process(delta)->void:
	process_movement(delta)
	check_collisions()
	

func process_movement(delta)->void:
	last_pos = global_position
	global_position += -global_transform.basis.z * initial_speed * delta
	

func set_bodies_to_exclude(bte: Array):
	bodies_to_exclude = bte
	for b in bte:
		collision_raycast.add_exception(b)
	

func check_collisions()->void:
	collision_raycast.global_position = last_pos
	collision_raycast.target_position = collision_raycast.to_local(global_position)
	collision_raycast.enabled = true
	collision_raycast.force_raycast_update()
	var is_colliding = collision_raycast.is_colliding()
	var hit_pos = collision_raycast.get_collision_point()
	var hit_normal = collision_raycast.get_collision_normal()
	var hit_collider = collision_raycast.get_collider()
	collision_raycast.enabled = false
	
	if is_colliding:
		on_hit(hit_collider, hit_pos, hit_normal)

func on_hit(hit_collider:Node3D, hit_pos: Vector3, hit_normal: Vector3)->void:
	global_position = hit_pos
	if hit_collider.has_method("hurt"):
		damage_target(hit_collider, hit_pos, hit_normal)
	destroy()
	

func damage_target(hit_collider:Node3D, hit_pos: Vector3, hit_normal: Vector3)->void:
	var damage_data = DamageData.new()
	damage_data.amount = damage
	damage_data.hit_pos = hit_pos
	hit_collider.hurt(damage_data)
	

func destroy()->void:
	if delete_on_hit_after_time > 0:
		$Graphics.hide()
		set_process(false)
		set_physics_process(false)
		await get_tree().create_timer(delete_on_hit_after_time).timeout
		queue_free()
	else:
		queue_free()
