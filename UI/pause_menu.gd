extends Control

signal resume
signal back_to_main_pressed

@onready var game_menu = $Panel/GameMenu
@onready var continue_button = $Panel/GameMenu/VBoxContainer/ContinueButton

func open_pause_menu()->void:
	#Stops game and shows pause menu
	get_tree().paused = true
	show()
	game_menu.show()
	#options_tab_menu.hide()
	continue_button.grab_focus.call_deferred()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func close_pause_menu()->void:
	get_tree().paused = false
	hide()
	emit_signal("resume")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_continue_button_pressed()->void:
	#options_tab_menu.show()
	close_pause_menu()


func _on_settings_button_pressed()->void:
	game_menu.hide()


func _on_exit_mission_button_pressed()->void:
	get_tree().paused = false
	get_tree().call_group("instantiated", "queue_free")
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")

func _on_quit_button_pressed()->void:
	get_tree().quit()
