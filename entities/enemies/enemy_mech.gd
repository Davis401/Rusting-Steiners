extends Enemy

@onready var left_missile_attack:AttackEmitter = $LeftMissileAttack
@onready var right_missile_attack:AttackEmitter = $RightMissileAttack
@onready var missile_attack_timer:Timer = $MissileAttackTimer

func start_attack() -> void:
	if missile_attack_timer.is_stopped():
		missile_attack_timer.start(5.0)
		super()
		var target_pos = player.global_position
		var dir_to_player = attack_emitter.global_position
		if dir_to_player.is_equal_approx(Vector3.UP) or dir_to_player.is_equal_approx(Vector3.DOWN):
			attack_emitter.look_at(target_pos, Vector3.RIGHT)
		else:
			attack_emitter.look_at(target_pos)
			
func do_attack()->void:
	left_missile_attack.attack()
	right_missile_attack.attack()
