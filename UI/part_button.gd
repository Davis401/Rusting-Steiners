extends Button

@export var selected = false :
	set(value):
		if value:
			selected = true
			add_theme_color_override("font_color", "#2b2b2b")
			add_theme_color_override("font_pressed_color", "#2b2b2b")
			add_theme_color_override("font_hover_color", "#2b2b2b")
			add_theme_color_override("font_focus_color", "#2b2b2b")
			add_theme_color_override("font_hover_pressed_color", "#2b2b2b")

			var new_stylebox_normal = get_theme_stylebox("normal").duplicate()
			new_stylebox_normal.bg_color = Color("e3e3e3")
			add_theme_stylebox_override("normal", new_stylebox_normal)
			add_theme_stylebox_override("hover", new_stylebox_normal)
			add_theme_stylebox_override("pressed", new_stylebox_normal)
			add_theme_stylebox_override("focus", new_stylebox_normal)
		else:
			selected = false
			add_theme_color_override("font_color", "#e3e3e3")
			add_theme_color_override("font_pressed_color", "#e3e3e3")
			add_theme_color_override("font_hover_color", "#e3e3e3")
			add_theme_color_override("font_focus_color", "#e3e3e3")
			add_theme_color_override("font_hover_pressed_color", "#e3e3e3")
			remove_theme_stylebox_override("normal")
			remove_theme_stylebox_override("hover")
			remove_theme_stylebox_override("pressed")
			remove_theme_stylebox_override("focus")
