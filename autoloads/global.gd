extends Node

@export var current_build:MechaBuild
@export var need_to_press_start:=true

const PARTS = [
	preload("res://resources/mech_parts/head/standard_head.tres"),
	preload("res://resources/mech_parts/chest/standard_chest.tres"),
	preload("res://resources/mech_parts/legs/standard_legs.tres"),
	preload("res://resources/mech_parts/arms/machine_gun_arm.tres"),
	preload("res://resources/mech_parts/arms/grenade_launcher_arm.tres"),
	preload("res://resources/mech_parts/shoulders/missile_launcher_shoulder.tres")

]

func _ready():
	if current_build == null:
		current_build = MechaBuild.new()
		current_build.head = PARTS[0]
		current_build.chest = PARTS[1]
		current_build.left_arm = PARTS[3]
		current_build.right_arm = PARTS[3]
		current_build.left_shoulder = PARTS[5]
		current_build.right_shoulder = PARTS[5]
		current_build.legs = PARTS[2]
