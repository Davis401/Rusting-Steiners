extends CanvasLayer

@onready var crt = $CRT

func turn_on_crt_filter() ->void:
	crt.show()
	
func turn_off_crt_filter() ->void:
	crt.hide()
