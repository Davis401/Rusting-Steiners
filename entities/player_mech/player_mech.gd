class_name PlayerMech
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export_group("Movement Properties")
@export var MOUSE_SENS : float = 0.25
@export var LERP_SPEED : float = 10.0

var gravity_vec : Vector3 = Vector3.ZERO
var current_speed : float = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction : Vector3 = Vector3.ZERO
var is_moving : bool = false
var is_boosting : bool = false
var last_velocity : Vector3= Vector3.ZERO
var is_movement_paused : bool = false
var is_dead : bool = false

#Components
@onready var energy_component = $EnergyComponent
@onready var health_component = $HealthComponent


@onready var neck = $Neck
@onready var head = $Neck/Head
@onready var camera = $Neck/Head/Camera3D
@onready var animation_player = $Neck/Head/AnimationPlayer


@onready var self_rid: RID = self.get_rid()

func _ready():
	randomize() 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion and !is_movement_paused:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
		neck.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
		neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir
	if !is_movement_paused:
		input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	else:
		input_dir = Vector2.ZERO
		
	if Input.is_action_pressed("boost") and energy_component and energy_component.current_energy > 0:
		is_boosting = true
		#current_speed = lerp(current_speed, BOOSTING_SPEED, delta * LERP_SPEED)
		
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	current_speed = clamp(current_speed, 3.0, 12.0)
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	last_velocity = velocity
	
	velocity += gravity_vec
	move_and_slide()
