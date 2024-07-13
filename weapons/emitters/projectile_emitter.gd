extends AttackEmitter

const PROJECTILES = [preload("res://weapons/projectiles/grenade.tscn"), 
	preload("res://weapons/projectiles/rocket.tscn"),
	preload("res://weapons/projectiles/missile.tscn"),
	preload("res://weapons/projectiles/laser.tscn")]

enum PROJECTILE_TYPE {GRENADE,ROCKET,MISSILE,LASER}

@export var projectile_type :PROJECTILE_TYPE

func attack(params = null):
	var proj_inst = PROJECTILES[projectile_type].instantiate()
	proj_inst.global_transform = global_transform
	proj_inst.damage = damage
	if proj_inst is Missile && params != null:
		proj_inst.missile_target = params
	get_tree().get_root().add_child(proj_inst)
	proj_inst.add_to_group("instanced")
	proj_inst.set_bodies_to_exclude(bodies_to_exclude)
	super()
