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
	player.rotate_y(PI)
	for node in get_tree().get_nodes_in_group("objective"):
		objectives.append(node)
	Global.emit_update_targets_max(str(objectives.size()))


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
	Global.emit_level_complete()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
	
func check_objectives()->void:
	var targets_destroyed = 0
	var targets_left = 0
	await get_tree().create_timer(0.1).timeout
	for objective in objectives:
		if is_instance_valid(objective) && objective != null:
			targets_left += 1
		else:
			targets_destroyed += 1
			
	Global.emit_update_targets_defeated(str(targets_destroyed))
	if targets_left == 0:
		complete_level()
