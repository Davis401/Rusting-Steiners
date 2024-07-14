class_name MovementComponent
extends Node3D

@export var max_speed = 15.0
@export var move_accel = 4.0
@export var stop_drag = 0.9
@export var turn_speed = 300.0

var body:CharacterBody3D

var move_drag :=  0.0
var move_dir:Vector3
var facing_dir:Vector3

var moving = false

@onready var navigation_agent_3d = $NavigationAgent3D


func _ready()->void:
	body = get_parent()
	move_drag = move_accel / max_speed
	facing_dir = -body.global_transform.basis.z
	

func set_facing_dir(new_face_dir:Vector3)->void:
	facing_dir = new_face_dir
	facing_dir.y = 0.0
	

func set_move_dir(new_move_dir:Vector3)->void:
	move_dir = new_move_dir
	move_dir.y = 0.0
	move_dir = move_dir.normalized()
	

func move_to_point(point:Vector3)->void:
	moving = true
	navigation_agent_3d.target_position = point
	

func stop_moving()->void:
	moving = false
	set_move_dir(Vector3.ZERO)
	

func _physics_process(delta)->void:
	var drag = move_drag
	if move_dir.is_zero_approx():
		drag = stop_drag
		
	var flat_velo = body.velocity
	flat_velo.y = 0.0
	body.velocity += move_accel * move_dir - flat_velo * drag
	body.move_and_slide()
	
	#Movement
	if moving:
		set_move_dir(navigation_agent_3d.get_next_path_position() - global_position)
	
	# FACE DIR
	var fwd = -body.global_transform.basis.z
	var right = body.global_transform.basis.x
	var angle_diff = fwd.angle_to(facing_dir)
	var turn_dir = 1
	if right.dot(facing_dir) > 0:
		turn_dir = -1
		
	var turn_amnt = delta * deg_to_rad(turn_speed)
	if turn_amnt > angle_diff:
		turn_amnt = angle_diff
		
	body.global_rotation.y += turn_amnt * turn_dir
