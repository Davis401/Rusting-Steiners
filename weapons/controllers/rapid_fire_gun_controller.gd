extends WeaponController

var firing:bool = false

@onready var attack_emitter = $AttackEmitter
@onready var fire_timer = $FireTimer

func _ready():
	super()
	$AttackEmitter/SprayEmiiter/HitscanAttackEmitter.tracer_start_position = spawn_point_node
	$AttackEmitter/SprayEmiiter/HitscanAttackEmitter.set_damage(2)
	

func on_hold()->void:
	if fire_timer.is_stopped() && current_ammo > 0:
		fire_timer.start(time_between_attacks)
		current_ammo -= 1
		attack_emitter.attack()
		#var sfx_player = AudioManager.play_sound3D(SFX.pick_random(), true)
		#wsfx_player.global_position = global_position
func set_spray_arc(spray_arc)->void:
	$AttackEmitter/SprayEmiiter.arc = spray_arc
