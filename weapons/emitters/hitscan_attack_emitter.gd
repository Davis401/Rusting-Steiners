extends AttackEmitter

const HIT_SPARK = preload("res://particles/hit_spark.tscn")

@onready var ray_cast_3d = $RayCast3D


func set_bodies_to_exclude(bodies:Array)->void:
	super(bodies)
	for body in bodies:
		ray_cast_3d.add_exception(body)
		
		
func attack() ->void:
	if ray_cast_3d.is_colliding():
		if ray_cast_3d.get_collider().has_method("hurt"):
			ray_cast_3d.get_collider().hurt(damage)
		else:
			var hit_effect_inst : Node3D = HIT_SPARK.instantiate()
			get_tree().get_root().add_child(hit_effect_inst)
			var hit_pos = ray_cast_3d.get_collision_point()
			var hit_normal: Vector3 = ray_cast_3d.get_collision_normal()
			var look_at_pos: Vector3 = hit_pos + hit_normal
			hit_effect_inst.global_position = hit_pos
			
			if hit_normal.is_equal_approx(Vector3.UP) or hit_normal.is_equal_approx(Vector3.DOWN):
				hit_effect_inst.look_at(look_at_pos, Vector3.RIGHT)
			else:
				hit_effect_inst.look_at(look_at_pos)
	super()
