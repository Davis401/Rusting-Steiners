extends Control



const LEVEL_BUTTON = preload("res://UI/level_button.tscn")

@export var levels :Array[LevelData]


@onready var grid_container = $MarginContainer/GridContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	for level in levels:
		var level_button_inst = LEVEL_BUTTON.instantiate()
		level_button_inst.level_data = level
		level_button_inst.level_selected.connect(on_level_selected)
		grid_container.add_child(level_button_inst)
	

func on_level_selected(level:LevelData):
	get_tree().change_scene_to_packed(level.level_scene)
