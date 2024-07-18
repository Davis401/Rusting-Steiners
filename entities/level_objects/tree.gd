extends StaticBody3D

const PHYSICS_TREE = preload("res://entities/level_objects/physics_tree.tscn")

@onready var health_component:HealthComponent = $HealthComponent

func _ready()-> void:
	health_component.death.connect(on_die)
	

func hurt(damage_data:DamageData)-> void:
	health_component.subtract(damage_data.amount)
	

func on_die() -> void:
	var physics_tree = PHYSICS_TREE.instantiate()
	get_tree().get_first_node_in_group("entities_layer").add_child(physics_tree)
	physics_tree.global_position = global_position + Vector3(0.1, 1.184, 0)
	queue_free()
