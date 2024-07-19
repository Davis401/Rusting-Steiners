class_name SaveData
extends Resource

var player_save_file : String = "user://player_save.res"

@export var shown_congrats_message = false

@export var money:int = 10000


@export var owned_parts:Dictionary = {
	"standard_head":true,
	"standard_chest":true,
	"machine_gun_arm":true,
	"missile_shoulder":true,
	"standard_legs":true
}

@export var beaten_levels:Array[int] = []
#Levels beaten
#Equipment purchased state
#Save builds(s?)


func write_save() -> void:
	ResourceSaver.save(self, player_save_file, ResourceSaver.FLAG_CHANGE_PATH)
	print("Player data saved at ", player_save_file)

func save_exists() -> bool:
	return ResourceLoader.exists(player_save_file)
 

func load_save() -> Resource:
	return ResourceLoader.load(player_save_file, "", ResourceLoader.CACHE_MODE_IGNORE)
