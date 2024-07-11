class_name WeaponController
extends Node3D

signal ammo_changed(value:int)

@export var starting_ammo = 100 :
	set(value):
		starting_ammo = value
		current_ammo = starting_ammo
	

var current_ammo:int = starting_ammo :
	set(value):
		current_ammo = value
		ammo_changed.emit(current_ammo)
	

var camera
var spawn_point_node:Node3D

func _ready()->void:
	camera = get_viewport().get_camera_3d()
	
#Call first time is pressed
func on_press()->void:
	pass
#Called every frame is pressed
func on_hold()->void:
	pass
#Called when released
func on_release()->void:
	pass
