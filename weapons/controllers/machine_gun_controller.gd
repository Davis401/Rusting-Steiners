extends WeaponController

const SFX = [ preload("res://assets/sfx/EchoesAudioPack/machinegun_heavy_1.mp3"),preload("res://assets/sfx/EchoesAudioPack/machinegun_heavy_2.mp3"),preload("res://assets/sfx/EchoesAudioPack/machinegun_heavy_3.mp3")]
var firing = false

@onready var attack_emitter = $AttackEmitter
@onready var fire_timer = $FireTimer

func on_hold()->void:
	if fire_timer.is_stopped():
		fire_timer.start(.05)
		attack_emitter.attack()
		var sfx_player = AudioManager.play_sound3D(SFX.pick_random(), true)
		sfx_player.global_position = global_position
