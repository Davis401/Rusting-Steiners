class_name LevelButton
extends Button

signal level_selected(level:LevelData)

@export var level_data:LevelData

# Called when the node enters the scene tree for the first time.
func _ready():
	if level_data != null:
		text = level_data.display_name


func _on_pressed():
	level_selected.emit(level_data)
