extends AttackEmitter

const PROJECTILES = []

enum PROJECTILE_TYPE {}

@export var projectile_type :PROJECTILE_TYPE

func attack():
	var proj_inst:Projectile = PROJECTILES[projectile_type].instantiate()
	proj_inst.global_transform = global_transform
	proj_inst.damage = damage
	get_tree().get_root().add_child(proj_inst)
	proj_inst.add_to_group("instanced")
	proj_inst.set_bodies_to_exclude(bodies_to_exclude)
	super()
