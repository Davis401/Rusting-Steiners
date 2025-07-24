extends Node

signal money_changed(money:int)
signal check_objectives
signal update_targets_defeated(str:String)
signal update_targets_max(str:String)
signal level_complete

@export var current_build:MechaBuild
@export var need_to_press_start:=true

var current_level:LevelData

const PARTS = [
	#Starting Parts
	preload("res://resources/mech_parts/head/standard_head.tres"),
	preload("res://resources/mech_parts/chest/standard_chest.tres"),
	preload("res://resources/mech_parts/shoulders/missile_launcher_shoulder.tres"),
	preload("res://resources/mech_parts/arms/machine_gun_arm.tres"),
	preload("res://resources/mech_parts/legs/standard_legs.tres"),
	#Heads
	preload("res://resources/mech_parts/head/fast_missile_head.tres"),
	preload("res://resources/mech_parts/head/accurate_head.tres"),
	#Chests
	preload("res://resources/mech_parts/chest/heavy_chest.tres"),
	preload("res://resources/mech_parts/chest/small_chest.tres"),
 	preload("res://resources/mech_parts/chest/energy_chest.tres"),
	#Shoudlers
	#preload("res://resources/mech_parts/shoulders/railgun_shoulder.tres"),
	preload("res://resources/mech_parts/shoulders/large_missile_launcher_shoulder.tres"),
	preload("res://resources/mech_parts/shoulders/medium_missile_shoudlers.tres"),
	#Arms
	preload("res://resources/mech_parts/arms/shotgun_arm.tres"),
	preload("res://resources/mech_parts/arms/rocket_launcher_arm.tres"),
	preload("res://resources/mech_parts/arms/minigun.tres"),
	preload("res://resources/mech_parts/arms/grenade_launcher_arm.tres"),
	#Legs
	preload("res://resources/mech_parts/legs/fast_legs.tres"),
	preload("res://resources/mech_parts/legs/heavy_legs.tres"),
	preload("res://resources/mech_parts/legs/jumping_legs.tres"),
]

func _ready() ->void:
	if current_build == null:
		current_build = MechaBuild.new()
		current_build.head = PARTS[0]
		current_build.chest = PARTS[1]
		current_build.left_shoulder = PARTS[2]
		current_build.right_shoulder = PARTS[2]
		current_build.left_arm = PARTS[3]
		current_build.right_arm = PARTS[3]
		current_build.legs = PARTS[4]
	


func update_money(money:int)->void:
	money_changed.emit(money)
	

func emit_check_objectives()->void:
	check_objectives.emit()
	
	
func emit_update_targets_defeated(str:String)->void:
	update_targets_defeated.emit(str)
	

func emit_update_targets_max(str:String)->void:
	update_targets_max.emit(str)
	

func emit_level_complete()->void:
	if current_level != null:
		SaveManager.save_data.money += current_level.reward
		if !SaveManager.save_data.beaten_levels.has(current_level.index):
			SaveManager.save_data.beaten_levels.push_back(current_level.index)
		SaveManager.save()
		current_level = null
	level_complete.emit()
