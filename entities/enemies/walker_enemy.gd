extends Enemy

@onready var laser_timer:Timer = $LaserTimer
@onready var smoke_particles = $Graphics/SmokeParticles
@onready var smoke_particles_2 = $Graphics/SmokeParticles2
@onready var hitflash_player = $HitflashPlayer
@onready var laser_attack:AttackEmitter = $LaserAttack
@onready var projectile_emitter_left = $LaserAttack/ProjectileEmitterLeft
@onready var projectile_emitter_right = $LaserAttack/ProjectileEmitterRight
@onready var animation_player = $AnimationPlayer

func _ready():
	super()
	for child in get_children():
		if child is AttackEmitter:
			child.set_damage(100)
	_animation_player = animation_player


func hurt(damage_data:DamageData)->void:
	super(damage_data)
	if !hitflash_player.is_playing():
		hitflash_player.play("hitflash")
	if !smoke_particles.emitting && health_component.current_health / health_component.max_health <= .5:
		smoke_particles.emitting = true
		smoke_particles_2.emitting = true
	
	
func process_attack_state(delta)->void:
	var is_attacking = _animation_player.current_animation == "attack"
	var vec_to_player = player.global_position - global_position
	
	if vec_to_player.length() <= attack_range && laser_timer.is_stopped():
		movement_component.stop_moving()
		if !is_attacking and vision_component.is_facing_target(player):
			start_attack()
		elif !is_attacking:
			movement_component.set_facing_dir(vec_to_player)
	elif !is_attacking:
		movement_component.set_facing_dir(movement_component.move_dir)
		if vec_to_player.length() > minimum_distance_to_player:
			movement_component.move_to_point(player.global_position)
			if _animation_player != null && is_instance_valid(_animation_player):
				_animation_player.play("walk")
	move_and_slide()


func start_attack() -> void:
	if laser_timer.is_stopped():
		laser_timer.start(3.0)
	else:
		return
	
	super()
	var target_pos = player.global_position + Vector3.UP * .75
	
	var dir_to_player = laser_attack.global_position.direction_to(target_pos)
	if dir_to_player.is_equal_approx(Vector3.UP) or dir_to_player.is_equal_approx(Vector3.DOWN):
		projectile_emitter_left.look_at(target_pos, Vector3.RIGHT)
		projectile_emitter_right.look_at(target_pos, Vector3.RIGHT)
	else:
		projectile_emitter_left.look_at(target_pos)
		projectile_emitter_right.look_at(target_pos)
	

func do_attack()->void:
	var sfx = AudioManager.play_sound3D(LASER_SOUNDS.pick_random())
	sfx.global_position = global_position
	laser_attack.attack()
	
