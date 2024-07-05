extends AttackEmitter

@export var attack_radius := 1.0
@export var offset_by_radius := false
@onready var ray_cast_3d = $RayCast3D

func attack():
	var query_params := PhysicsShapeQueryParameters3D.new()
	query_params.shape = SphereShape3D.new()
	query_params.shape.radius = attack_radius
	query_params.collision_mask = 2
	var tr = global_transform
	if offset_by_radius:
		tr.origin = to_global(Vector3.FORWARD * attack_radius)
	query_params.transform = tr
	query_params.exclude = bodies_to_exclude
	var intersect_results : Array[Dictionary] = get_world_3d().direct_space_state.intersect_shape(query_params)
	for intersect_data in intersect_results:
		var collider : Node3D = intersect_data.collider
		if collider.has_method("hurt"):
			collider.hurt(damage)
			
	super()
	
	
func has_los(collider:Node3D) -> bool:
	ray_cast_3d.enabled = true
	ray_cast_3d.target_position = ray_cast_3d.to_local(collider.global_position + Vector3.UP)
	ray_cast_3d.force_raycast_update()
	var in_los = !ray_cast_3d.is_colliding()
	ray_cast_3d.enabled = false
	return in_los
