class_name MechaArm
extends MechaPart

@export var arm_controller:PackedScene
@export var ammo:int

func get_part_info() -> Dictionary:
	var part_info = {}
	part_info["Weight"] = str(weight)
	part_info["Ammo Count"] = str(ammo)
	
	
	return part_info
