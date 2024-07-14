extends Node3D

const PLAYER_MECH = preload("res://entities/player_mech/player_mech.tscn")
var player:PlayerMech

var objectives = []

@onready var entities = $Entities
@onready var player_spawn = $PlayerSpawn
@onready var env_particles = $EnvParticles

# Called when the node enters the scene tree for the first time.
func _ready() ->void:
	Global.check_objectives.connect(check_objectives)
	player = PLAYER_MECH.instantiate()
	entities.add_child(player)
	player.global_position = player_spawn.global_position
	for node in get_tree().get_nodes_in_group("objective"):
		objectives.append(node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta)->void:
	if env_particles != null && player != null:
		env_particles.global_position = player.global_position


func reload_level()->void:
	get_tree().current_scene.reload()


func complete_level()->void:
	#Displayer Victory thing
	#Fade out
	#Change Scene
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
	
func check_objectives()->void:
	print("check_objectives")
	for objective in objectives:
		if objective != null:
			return
	complete_level()
