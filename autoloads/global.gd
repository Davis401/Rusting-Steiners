extends Node

signal money_changed(money:int)
signal check_objectives

@export var current_build:MechaBuild
@export var need_to_press_start:=true

const PARTS = [
	#Starting Parts
	preload("res://resources/mech_parts/head/standard_head.tres"),
	preload("res://resources/mech_parts/chest/standard_chest.tres"),
	preload("res://resources/mech_parts/shoulders/missile_launcher_shoulder.tres"),
	preload("res://resources/mech_parts/arms/machine_gun_arm.tres"),
	preload("res://resources/mech_parts/arms/grenade_launcher_arm.tres"),
	preload("res://resources/mech_parts/legs/standard_legs.tres"),
	#Heads
	preload("res://resources/mech_parts/head/fast_missile_head.tres"),
	preload("res://resources/mech_parts/head/accurate_head.tres"),
	#Chests
	preload("res://resources/mech_parts/chest/heavy_chest.tres"),
	preload("res://resources/mech_parts/chest/small_chest.tres"),
 	preload("res://resources/mech_parts/chest/energy_chest.tres"),
	#Shoudlers
	preload("res://resources/mech_parts/shoulders/railgun_shoulder.tres"),
	preload("res://resources/mech_parts/shoulders/large_missile_launcher_shoulder.tres"),
	preload("res://resources/mech_parts/shoulders/medium_missile_shoudlers.tres"),
	#Arms
	preload("res://resources/mech_parts/arms/shotgun_arm.tres"),
	preload("res://resources/mech_parts/arms/rocket_launcher_arm.tres"),
	preload("res://resources/mech_parts/arms/minigun.tres"),
	#Legs
	preload("res://resources/mech_parts/legs/fast_legs.tres"),
	preload("res://resources/mech_parts/legs/heavy_legs.tres"),
	preload("res://resources/mech_parts/legs/jumping_legs.tres"),
]

func _ready():
	if current_build == null:
		current_build = MechaBuild.new()
		current_build.head = PARTS[0]
		current_build.chest = PARTS[1]
		current_build.left_shoulder = PARTS[2]
		current_build.right_shoulder = PARTS[2]
		current_build.left_arm = PARTS[3]
		current_build.right_arm = PARTS[4]
		current_build.legs = PARTS[5]



func update_money(money:int):
	money_changed.emit(money)

func emit_check_objectives():
	check_objectives.emit()
