extends AttackEmitter

@export var burst_count = 5

func attack(params = null) -> void:
	for _i in range(burst_count):
		super(params)
