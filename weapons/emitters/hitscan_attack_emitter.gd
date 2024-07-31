extends AttackEmitter

const HITSPARK:PackedScene = preload("res://particles/hitspark.tscn")
const BULLET_TRACER:PackedScene = preload("res://particles/bullet_tracer.tscn")

@export var tracer_start_position:Node3D

@onready var ray_cast_3d:RayCast3D = $RayCast3D


func set_bodies_to_exclude(bodies:Array)->void:
	super(bodies)
	for body in bodies:
		ray_cast_3d.add_exception(body)
		
		
func attack(params = null) ->void:
	ray_cast_3d.force_raycast_update()
	if ray_cast_3d.is_colliding():
		var hit_pos = ray_cast_3d.get_collision_point()
		var hit_normal: Vector3 = ray_cast_3d.get_collision_normal()
		
		var tracer: Node3D = BULLET_TRACER.instantiate()
		tracer.start = tracer_start_position.global_position
		tracer.end = hit_pos
		get_tree().get_root().add_child(tracer)
		tracer.global_rotation = global_rotation
		tracer.global_position = tracer_start_position.global_position
		
		var hit_effect_inst : Node3D = HITSPARK.instantiate()
		get_tree().get_root().add_child(hit_effect_inst)
		var look_at_pos: Vector3 = hit_pos + hit_normal
		hit_effect_inst.global_position = hit_pos
			
		if hit_normal.is_equal_approx(Vector3.UP) or hit_normal.is_equal_approx(Vector3.DOWN):
			hit_effect_inst.look_at(look_at_pos, Vector3.RIGHT)
		else:
			hit_effect_inst.look_at(look_at_pos)
				
		if ray_cast_3d.get_collider() != null && ray_cast_3d.get_collider().has_method("hurt"):
			var damage_data = DamageData.new()
			damage_data.amount = damage
			damage_data.hit_pos = hit_pos
			damage_data.hit_normal = hit_normal
			ray_cast_3d.get_collider().hurt(damage_data)
	super(params)
