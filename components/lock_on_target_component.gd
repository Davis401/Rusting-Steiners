extends Node3D

const DEFAULT_CROSSHAIR = preload("res://assets/reticles/crosshair043.png")
const LOCKED_ON_CROSSHAIR = preload("res://assets/reticles/crosshair045.png")

var camera
var locked_on:bool = false : 
	set(value) : 
		locked_on = value
		if locked_on:
			hud_icon.texture = LOCKED_ON_CROSSHAIR
		else:
			hud_icon.texture = DEFAULT_CROSSHAIR


var reticle_offset = Vector2(32,32)

@onready var hud_icon = $HUDIcon

func _ready()->void:
	camera = get_viewport().get_camera_3d()
	

func _process(delta)->void:
	if camera == null:
		camera = get_viewport().get_camera_3d()
		return
	if camera.is_position_in_frustum(global_position):
		hud_icon.show()
		var reticle_position = camera.unproject_position(global_position)
		hud_icon.set_global_position(reticle_position - reticle_offset)
	else:
		hud_icon.hide()

