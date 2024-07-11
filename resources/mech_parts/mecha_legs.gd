class_name MechaLegs
extends MechaPart

@export var weight_capacity:float
@export var base_movement_speed:float
@export var acceleration:float
@export var boosting_movement_speed:float
@export var jump_power:float

func get_part_info() -> Dictionary:
	var part_info = {}
	part_info["Weight"] = str(weight)
	part_info["Weight Limit"] = str(weight_capacity)
	part_info["Walk Speed"] = str(base_movement_speed)
	part_info["Boost Speed"] = str(boosting_movement_speed)
	part_info["Jump Power"] = str(jump_power)
	
	
	return part_info
