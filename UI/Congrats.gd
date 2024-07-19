extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	if !SaveManager.save_data.shown_congrats_message && SaveManager.save_data.beaten_levels.size() >= 5:
		show()

func _on_close_button_pressed():
	SaveManager.save_data.shown_congrats_message = true
	SaveManager.save()
	queue_free()
