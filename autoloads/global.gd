extends Node

@export var current_build:MechaBuild
@export var need_to_press_start:=true

const PARTS = [
	preload("res://resources/mech_parts/head/standard_head.tres"),
	preload("res://resources/mech_parts/chest/standard_chest.tres"),
	preload("res://resources/mech_parts/shoulders/missile_launcher_shoulder.tres"),
	preload("res://resources/mech_parts/arms/machine_gun_arm.tres"),
	preload("res://resources/mech_parts/arms/grenade_launcher_arm.tres"),
	preload("res://resources/mech_parts/legs/standard_legs.tres")
]
