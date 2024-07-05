extends Projectile

@onready var area_damage_emitter:AreaDamageEmitter = $AreaDamageEmitter


func on_hit(hit_collider: Node3D, hit_pos:Vector3, hit_normal: Vector3)->void:
	super(hit_collider, hit_pos, hit_normal)
	area_damage_emitter.damage = damage
	area_damage_emitter.attack()
