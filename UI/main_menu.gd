extends Control

signal start_game_pressed

const LEVEL_SELECT = preload("res://UI/level_select.tscn")

@export var first_focus_button: Button
@export var sound_hover : AudioStream
@export var sound_click : AudioStream

func _ready() ->void:
	first_focus_button.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

#func open_settings_menu():
	#options_tab_menu.show()
	#options_tab_menu.nodes_to_focus[0].grab_focus.call_deferred()
	#game_menu.hide()

func quit() ->void:
	get_tree().quit()


func _on_start_button_pressed() ->void:
	get_tree().change_scene_to_packed(LEVEL_SELECT)
	emit_signal("start_game_pressed")
