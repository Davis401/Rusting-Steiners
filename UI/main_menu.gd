extends Control

const LEVEL_SELECT = preload("res://UI/level_select.tscn")

@export var sound_hover : AudioStream
@export var sound_click : AudioStream

var settings_open := false

@onready var game_menu = $GameMenu
@onready var start_menu = $StartMenu
@onready var start_button = $StartMenu/VBoxContainer/StartButton
@onready var store_button = $GameMenu/VBoxContainer/StoreButton
@onready var settings_menu = $SettingsMenu
@onready var player_profile = $PlayerProfile

@onready var store_menu = $StoreMenu

@onready var build_menu = $BuildMenu


func _ready() ->void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	settings_menu.back_pressed.connect(on_setting_closed.bind(settings_menu))
	build_menu.close.connect(close_build_menu)
	settings_menu.hide()
	build_menu.hide()
	store_menu.hide()
	start_menu.show()
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
	build_menu.open()
	game_menu.hide()
	start_menu.hide()
	

func _on_missions_button_pressed() ->void:
	get_tree().change_scene_to_packed(LEVEL_SELECT)
	


func _on_quit_button_pressed() ->void:
	get_tree().quit()


func _on_settings_button_pressed()-> void:
	settings_menu.open()
	settings_open = true
	game_menu.hide()
	start_menu.hide()
	player_profile.hide()

func on_setting_closed(settings_node: Node) -> void:
	settings_menu.hide()
	settings_open = false
	player_profile.show()
	start_menu.show()
	
	if Global.need_to_press_start:
		start_button.grab_focus.call_deferred()
	else:
		game_menu.show()
		start_button.hide()
		store_button.grab_focus.call_deferred()
		
func close_build_menu() ->void:
	game_menu.show()
	start_menu.show()
