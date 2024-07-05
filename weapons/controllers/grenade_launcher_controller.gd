extends WeaponController

@onready var attack_emitter:AttackEmitter = $AttackEmitter

func on_press()->void:
	attack_emitter.attack()
