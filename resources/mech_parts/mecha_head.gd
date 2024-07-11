class_name MechaHead
extends MechaPart

@export var accuracy:int #Scale 1-100 (100 - acc/10) = arc
@export var missile_lock_on_time:float
@export var max_lock_range:float

func get_part_info() -> Dictionary:
	var part_info = {}
	part_info["Weight"] = str(weight)
	part_info["Accuracy"] = str(accuracy)
	part_info["Lock time"] = str(missile_lock_on_time)
	
	return part_info
