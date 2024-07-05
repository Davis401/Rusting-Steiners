extends WeaponController

var firing = false

@onready var attack_emitter = $AttackEmitter
@onready var fire_timer = $FireTimer

func on_hold()->void:
	if fire_timer.is_stopped():
		fire_timer.start(.05)
		attack_emitter.fire()
