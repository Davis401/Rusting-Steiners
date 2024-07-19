extends Area3D

@export_multiline var tip:String

@onready var label = $CanvasLayer/CenterContainer/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = tip
	label.hide()
	for b in get_overlapping_bodies():
		if b is PlayerMech:
			label.show()


func _on_body_entered(body):
	if body is PlayerMech:
		label.show()


func _on_body_exited(body):
	if body is PlayerMech:
		label.hide()
