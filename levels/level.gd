extends Node3D

const PLAYER_MECH = preload("res://entities/player_mech/player_mech.tscn")
var player:PlayerMech

@onready var entities = $Entities
@onready var player_spawn = $PlayerSpawn

# Called when the node enters the scene tree for the first time.
func _ready():
	player = PLAYER_MECH.instantiate()
	entities.add_child(player)
	player.global_position = player_spawn.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
