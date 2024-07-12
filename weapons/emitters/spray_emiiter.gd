extends AttackEmitter

@export var spray_arc = 5.0


func attack(params = null) -> void:
	rotation = Vector3.ZERO
	rotate_object_local(Vector3.FORWARD, randf_range(0.0, TAU))
	rotate_object_local(Vector3.RIGHT, deg_to_rad(randf_range(-spray_arc, spray_arc)))
	super(params)
