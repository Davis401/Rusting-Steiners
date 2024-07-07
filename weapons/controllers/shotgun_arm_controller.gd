extends WeaponController

const SFX = [preload("res://assets/sfx/EchoesAudioPack/shotgun_1.mp3"), preload("res://assets/sfx/EchoesAudioPack/shotgun_2.mp3")]

@onready var attack_emitter = $AttackEmitter
@onready var fire_timer = $FireTimer

func _ready():
	super()
	$AttackEmitter/BurstEmitter/SprayEmiiter/HitscanAttackEmitter.tracer_start_position = spawn_point_node

#Call first time is pressed
func on_press()->void:
	if !fire_timer.is_stopped():
		return
	fire_timer.start()
	attack_emitter.attack()
	var sfx_player = AudioManager.play_sound3D(SFX.pick_random(), true)
	sfx_player.global_position = global_position
