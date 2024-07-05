extends AttackEmitter

@onready var ray_cast_3d = $RayCast3D


func set_bodies_to_exclude(bodies:Array):
	super(bodies)
	for body in bodies:
		ray_cast_3d.add_exception(body)
		
		
func attack():
	if ray_cast_3d.is_colliding():
		if ray_cast_3d.get_collider().has_method("hurt"):
			ray_cast_3d.get_collider().hurt(damage)
		else:
			var hit_pos = ray_cast_3d.get_collision_point()
			var hit_normal: Vector3 = ray_cast_3d.get_collision_normal()
			var look_at_pos: Vector3 = hit_pos + hit_normal
	super()
