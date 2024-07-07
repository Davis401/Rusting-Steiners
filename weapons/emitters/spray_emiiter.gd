extends AttackEmitter

@export var spray_arc = 5.0

var rng:RandomNumberGenerator = RandomNumberGenerator.new()

func attack(params = null) -> void:
	rng.randomize()
	rotation = Vector3.ZERO
	rotate_object_local(Vector3.FORWARD, rng.randf_range(0.0, TAU))
	rotate_object_local(Vector3.RIGHT, deg_to_rad(rng.randf_range(-spray_arc, spray_arc)))
	super(params)
