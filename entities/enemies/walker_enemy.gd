extends Enemy

@onready var laser_timer:Timer = $LaserTimer
@onready var missile_timer:Timer = $MissileTimer
@onready var laser_attack_emitter:AttackEmitter = $LaserAttackEmitter
@onready var missile_attack_emitter:AttackEmitter = $MissileAttackEmitter
@onready var smoke_particles = $Graphics/SmokeParticles
@onready var smoke_particles_2 = $Graphics/SmokeParticles2
@onready var hitflash_player = $HitflashPlayer


var attack_node:AttackEmitter

func hurt(damage_data:DamageData)->void:
	super(damage_data)
	if !hitflash_player.is_playing():
		hitflash_player.play("hitflash")
	if !smoke_particles.emitting && health_component.current_health / health_component.max_health <= .5:
		smoke_particles.emitting = true
		smoke_particles_2.emitting = true

func process_attack_state(delta)->void:
	var is_attacking = animation_player.current_animation == "attack"
	var vec_to_player = player.global_position - global_position
	
	if vec_to_player.length() <= attack_range && (laser_timer.is_stopped() || missile_timer.is_stopped()):
		movement_component.stop_moving()
		if !is_attacking and vision_component.is_facing_target(player):
			start_attack()
		elif !is_attacking:
			movement_component.set_facing_dir(vec_to_player)
	elif !is_attacking:
		movement_component.set_facing_dir(movement_component.move_dir)
		movement_component.move_to_point(player.global_position)
		animation_player.play("walk")
	move_and_slide()


func start_attack() -> void:
	if laser_timer.is_stopped():
		laser_timer.start(3.0)
		attack_node = laser_attack_emitter
	elif missile_timer.is_stopped():
		missile_timer.start(10.0)
		attack_node = missile_attack_emitter
	else:
		return
	
	super()
	var target_pos = player.global_position + Vector3.UP
	
	var dir_to_player = attack_node.global_position
	if dir_to_player.is_equal_approx(Vector3.UP) or dir_to_player.is_equal_approx(Vector3.DOWN):
		attack_node.look_at(target_pos, Vector3.RIGHT)
	else:
		attack_node.look_at(target_pos)

func do_attack()->void:
	attack_node.attack()
