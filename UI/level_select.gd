extends Control

const LEVEL_BUTTON = preload("res://UI/level_button.tscn")
#const MAIN_MENU = preload("res://UI/main_menu.tscn")

@export var levels :Array[LevelData]
@onready var mission_list = %MissionList

# Called when the node enters the scene tree for the first time.
func _ready() ->void:
	for level in levels:
		var level_button_inst = LEVEL_BUTTON.instantiate()
		level_button_inst.level_data = level
		level_button_inst.level_selected.connect(on_level_selected)
		mission_list.add_child(level_button_inst)
	if mission_list.get_child(0) is Button:
		mission_list.get_child(0).grab_focus()
	

func on_level_selected(level:LevelData) ->void:
	get_tree().change_scene_to_packed(level.level_scene)


func _on_button_pressed():
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
