extends Control

signal start_game_pressed

@export var first_focus_button: Button
@export var sound_hover : AudioStream
@export var sound_click : AudioStream

func _ready():
	first_focus_button.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_start_game_button_pressed():
	emit_signal("start_game_pressed")

#func open_settings_menu():
	#options_tab_menu.show()
	#options_tab_menu.nodes_to_focus[0].grab_focus.call_deferred()
	#game_menu.hide()

func quit():
	get_tree().quit()
