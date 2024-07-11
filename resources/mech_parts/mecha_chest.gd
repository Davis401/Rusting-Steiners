class_name MechaChest
extends MechaPart

@export var max_health:float
@export var max_energy:float

func get_part_info() -> Dictionary:
	var part_info = {}
	part_info["Weight"] = str(weight)
	part_info["Health"] = str(max_health)
	part_info["Energy"] = str(max_energy)
	
	return part_info
