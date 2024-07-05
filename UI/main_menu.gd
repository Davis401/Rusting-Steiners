extends Control

const LEVEL_SELECT = preload("res://UI/level_select.tscn")

@export var sound_hover : AudioStream
@export var sound_click : AudioStream

@onready var game_menu = $GameMenu
@onready var start_menu = $StartMenu
@onready var start_button = $StartMenu/VBoxContainer/StartButton
@onready var store_button = $GameMenu/VBoxContainer/StoreButton


func _ready() ->void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Global.need_to_press_start:
		game_menu.hide()
		start_button.grab_focus()
	else:
		start_button.hide()
		game_menu.show()
		store_button.grab_focus()

#func open_settings_menu():
	#options_tab_menu.show()
	#options_tab_menu.nodes_to_focus[0].grab_focus.call_deferred()
	#game_menu.hide()

func _on_start_button_pressed() ->void:
	Global.need_to_press_start = false
	start_button.hide()
	game_menu.show()
	store_button.grab_focus()
	

func _on_store_button_pressed() ->void:
	pass # Replace with function body.


func _on_build_button_pressed() ->void:
	pass # Replace with function body.

func _on_missions_button_pressed() ->void:
	get_tree().change_scene_to_packed(LEVEL_SELECT)
	


func _on_quit_button_pressed() ->void:
	get_tree().quit()
