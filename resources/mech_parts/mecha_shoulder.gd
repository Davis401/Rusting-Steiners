class_name MechaShoulder
extends MechaPart

@export var shoulder_controller:PackedScene
@export var max_lock_on:int
@export var ammo:int

func get_part_info() -> Dictionary:
	var part_info = {}
	part_info["Weight"] = str(weight)
	part_info["Max Targets"] = str(max_lock_on)
	part_info["Ammo Count"] = str(ammo)
	
	return part_info
