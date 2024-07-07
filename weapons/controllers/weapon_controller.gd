class_name WeaponController
extends Node3D

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
