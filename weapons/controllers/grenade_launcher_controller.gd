extends WeaponController

@onready var attack_emitter:AttackEmitter = $AttackEmitter
@onready var audio_stream_player_3d = $AudioStreamPlayer3D
@onready var fire_timer:Timer = $FireTimer

func on_press()->void:
	if fire_timer.is_stopped() && current_ammo > 0:
		fire_timer.start(time_between_attacks)
		current_ammo -= 1
		audio_stream_player_3d.play()
		attack_emitter.attack()
