extends WeaponController

@onready var attack_emitter:AttackEmitter = $AttackEmitter
@onready var audio_stream_player_3d = $AudioStreamPlayer3D

func on_press()->void:
	audio_stream_player_3d.play()
	attack_emitter.attack()
