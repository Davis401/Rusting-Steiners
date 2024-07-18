extends Enemy

@onready var left_missile_attack:AttackEmitter = $LeftMissileAttack
@onready var right_missile_attack:AttackEmitter = $RightMissileAttack
@onready var missile_attack_timer:Timer = $MissileAttackTimer
@onready var animation_player = $AnimationPlayer


func _ready():
	super()
	_animation_player = animation_player
	for child in get_children():
		if child is AttackEmitter:
			child.set_damage(500)
	
	
func process_attack_state(delta)->void:
	var is_attacking = _animation_player.current_animation == "attack"
	var vec_to_player = player.global_position - global_position
	
	if vec_to_player.length() <= attack_range && missile_attack_timer.is_stopped():
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
	if missile_attack_timer.is_stopped():
		missile_attack_timer.start(1.0)
	else:
		return
	
	super()
	var target_pos = player.global_position + Vector3.UP * 0.5
	
	#Left
	var dir_to_player = left_missile_attack.global_position.direction_to(target_pos)
	if dir_to_player.is_equal_approx(Vector3.UP) or dir_to_player.is_equal_approx(Vector3.DOWN):
		right_missile_attack.look_at(target_pos, Vector3.RIGHT)
	else:
		left_missile_attack.look_at(target_pos)
	
	#Left
	dir_to_player = right_missile_attack.global_position.direction_to(target_pos)
	if dir_to_player.is_equal_approx(Vector3.UP) or dir_to_player.is_equal_approx(Vector3.DOWN):
		right_missile_attack.look_at(target_pos, Vector3.RIGHT)
	else:
		right_missile_attack.look_at(target_pos)

func do_attack()->void:
	left_missile_attack.attack()
	right_missile_attack.attack()
