extends Node

@export var save_data:SaveData = SaveData.new()

func _ready():
	if !save_data:
		save_data = SaveData.new()

	if save_data.save_exists():
		save_data = save_data.load_save()

func save():
	if !save_data:
		save_data = SaveData.new()
	
	save_data.write_save()
