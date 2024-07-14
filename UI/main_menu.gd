extends Control

const LEVEL_SELECT = preload("res://UI/level_select.tscn")

@export var sound_hover : AudioStream
@export var sound_click : AudioStream
var playback : AudioStreamPlaybackPolyphonic

var settings_open := false

@onready var game_menu:MarginContainer = $GameMenu
@onready var start_menu:MarginContainer = $StartMenu
@onready var start_button:Button = $StartMenu/VBoxContainer/StartButton
@onready var store_button:Button = $GameMenu/VBoxContainer/StoreButton
@onready var settings_menu = $SettingsMenu
@onready var player_profile:MarginContainer = $PlayerProfile

@onready var store_menu:MarginContainer = $StoreMenu
@onready var build_menu:MarginContainer = $BuildMenu

@onready var current_money = %CurrentMoney

func _enter_tree() -> void:
	# Create an audio player
	var player = AudioStreamPlayer.new()
	add_child(player)

	# Create a polyphonic stream so we can play sounds directly from it
	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.play()
	# Get the polyphonic playback stream to play sounds
	playback = player.get_stream_playback()
	get_tree().node_added.connect(_on_node_added)
	

func _on_node_added(node:Node) -> void:
	if node is Button:
		# If the added node is a button we connect to its mouse_entered and pressed signals
		# and play a sound
		node.mouse_entered.connect(_play_hover)
		node.pressed.connect(_play_pressed)
	

func _play_hover() -> void:
	playback.play_stream(sound_hover, 0, 0, 1)
	

func _play_pressed() -> void:
	playback.play_stream(sound_click, 0, 0, 1)


func _ready() ->void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	settings_menu.back_pressed.connect(on_setting_closed.bind(settings_menu))
	build_menu.close.connect(restore_main)
	store_menu.close.connect(restore_main)
	settings_menu.hide()
	build_menu.hide()
	store_menu.hide()
	start_menu.show()
	if Global.need_to_press_start:
		game_menu.hide()
	else:
		start_button.hide()
		game_menu.show()
	Global.money_changed.connect(update_money)
	update_money(SaveManager.save_data.money)
	

func _on_start_button_pressed() ->void:
	Global.need_to_press_start = false
	start_button.hide()
	game_menu.show()


func _on_store_button_pressed() ->void:
	store_menu.open()
	game_menu.hide()
	start_menu.hide()


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
		

func restore_main() ->void:
	game_menu.show()
	start_menu.show()
	


func update_money(money_in:int)->void:
	current_money.text = "¤ "+ str(money_in)


func _on_credits_button_pressed():
	pass # Replace with function body.
