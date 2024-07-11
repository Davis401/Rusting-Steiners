class_name MechaPart
extends Resource

@export var id:String
@export var display_name:String
@export var cost:int
@export var weight:int



func get_part_info() -> Dictionary:
	var part_info = {}
	part_info["Weight"] = str(weight)
	
	
	return part_info
