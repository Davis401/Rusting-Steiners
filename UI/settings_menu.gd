extends CenterContainer

signal back_pressed
signal settings_updated

const WINDOW_MODE_ARRAY : Array[String] = [
	"Full screen",
	"Windowed"
]

const RESOLUTION_DICTIONARY : Dictionary = {
	"1280x720 (16:9)" : Vector2i(1280,720),
	"1280x800 (16:10)" : Vector2i(1280,800),
	"1366x768 (16:9)" : Vector2i(1366,768),
	"1440x900 (16:10)" : Vector2i(1440,900),
	"1600x900 (16:9)" : Vector2i(1600,900),
	"1920x1080 (16:9)" : Vector2i(1920,1080),
	"2560x1440 (16:9)" : Vector2i(2560,1440),
	"3840x2160 (16:9)" : Vector2i(3840,2160),
}


var config = ConfigFile.new()

var gp_looksens : float
var mouse_sens : float

#Audio
var sfx_bus_index
var music_bus_index

# GRAPHICS
var render_resolution : Vector2i
var render_scale_val : float

@onready var resolution_option_button:OptionButton = %ResolutionOptionButton
@onready var window_mode_option_button:OptionButton = %WindowModeOptionButton

@onready var render_scale_current_value_label:Label = %RenderScaleCurrentValueLabel
@onready var render_scale_slider:Slider = %RenderScaleSlider

@onready var music_volume_slider:Slider = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer_Music_Volume/MusicVolumeSlider
@onready var sfx_volume_slider:Slider = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer_Sfx_Volume/SfxVolumeSlider
@onready var sensitivity_slider:Slider = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer_Sensitivity/SensitivitySlider

@onready var sensitivity_current_value_label:Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer_Sensitivity/SensitivityCurrentValueLabel
@onready var music_volume_current_value_label:Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer_Music_Volume/MusicVolumeCurrentValueLabel
@onready var sfx_volume_current_value_label:Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer_Sfx_Volume/SfxVolumeCurrentValueLabel

@onready var close_button:Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/CloseButton


# Called when the node enters the scene tree for the first time.
func _ready()->void:
	add_window_mode_items()
	add_resolution_items()
	window_mode_option_button.item_selected.connect(on_window_mode_selected)
	resolution_option_button.item_selected.connect(on_resolution_selected)
	load_options()
	

func open()->void:
	show()
	close_button.call_deferred("grab_focus")

# Adding window modes to the window mode button.
func add_window_mode_items() -> void:
	for mode in WINDOW_MODE_ARRAY:
		window_mode_option_button.add_item(mode)


# Adding resolutions to the resolution button.
func add_resolution_items() -> void:
	for resolution_text in RESOLUTION_DICTIONARY:
		resolution_option_button.add_item(resolution_text)


# Function to change window modes. Hooked up to the window_mode_option_button.
func on_window_mode_selected(index: int) -> void:
	match index:
		0: #Full screen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #Borderless windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)


func refresh_render()->void:
	print("refresh_render")
	get_window().content_scale_size = render_resolution
	get_window().scaling_3d_scale = render_scale_val
	
	

# Function to change resolution. Hooked up to the resolution_option_button.
func on_resolution_selected(index:int) -> void:
	render_resolution = RESOLUTION_DICTIONARY.values()[index]
	refresh_render()
	get_window().size = render_resolution
	

# Saves the options
func save_options()->void:
	config.set_value("Settings", "window_mode", window_mode_option_button.selected)
	config.set_value("Settings", "resolution_index", resolution_option_button.selected)
	config.set_value("Settings", "render_scale", render_scale_slider.value);
	config.set_value("Settings", "mouse_sens", mouse_sens)
	config.set_value("Settings", "sfx_volume", sfx_volume_slider.value)
	config.set_value("Settings", "music_volume", music_volume_slider.value)
	
	config.save("user://settings.cfg")


# Loads Settings
func load_options()->void:
	var err = config.load("user://settings.cfg")
	if err != 0:
		print("Loading options config failed. Assuming and saving defaults.")
		
	var window_mode = config.get_value("Settings", "window_mode", 1)
	var resolution_index = config.get_value("Settings", "resolution_index", 5)
	var render_scale = config.get_value("Settings", "render_scale", 1)
	mouse_sens = config.get_value("Settings", "mouse_sens", 0.25)
	
	var sfx_volume = config.get_value("Settings", "sfx_volume", 1)
	var music_volume = config.get_value("Settings", "music_volume", 1)

	
	sensitivity_slider.value = mouse_sens
	sensitivity_current_value_label.text = str(mouse_sens)


	# LOADING AUDIO CFG
	sfx_volume_slider.value = sfx_volume
	music_volume_slider.value = music_volume
	# LOADING GRAPHICS CFG
	render_scale_slider.value = render_scale
	render_scale_val = render_scale
	
	window_mode_option_button.selected = window_mode
	window_mode_option_button.item_selected.emit(window_mode)
	resolution_option_button.selected = resolution_index
	resolution_option_button.item_selected.emit(resolution_index)
	
	refresh_render()
	window_mode_option_button.item_selected.emit(window_mode_option_button.selected)


func _on_close_button_pressed() -> void:
	back_pressed.emit()
	window_mode_option_button.item_selected.emit(window_mode_option_button.selected)
	save_options()
	settings_updated.emit()


func _on_render_scale_slider_value_changed(value)-> void:
	render_scale_val = value
	render_scale_current_value_label.text = str(value)
	refresh_render()


func _on_crt_filter_button_toggled(toggled_on)-> void:
	if toggled_on:
		%CrtFilterButton.text = "on"
		ScreenShader.turn_on_crt_filter()
	else:
		%CrtFilterButton.text = "off"
		ScreenShader.turn_off_crt_filter()


func _on_sensitivity_slider_value_changed(value:float)-> void:
	mouse_sens = value
	sensitivity_current_value_label.text = str(value)

func _on_music_volume_slider_value_changed(value:float)-> void:
	var bus_index = AudioServer.get_bus_index("music")
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func _on_sfx_volume_slider_value_changed(value:float)-> void:
	var bus_index = AudioServer.get_bus_index("sfx")
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
