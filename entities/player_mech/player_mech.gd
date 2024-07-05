class_name PlayerMech
extends CharacterBody3D

@export var build:MechaBuild

@export_group("Movement Properties")
@export var MOUSE_SENS : float = 0.25
@export var LERP_SPEED : float = 10.0

var normal_speed := 5.0
var boosting_speed := 8.0
var jump_power := 4.5
var acceleration := 10.0

var gravity_vec : Vector3 = Vector3.ZERO
var current_speed : float = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction : Vector3 = Vector3.ZERO
var is_moving : bool = false
var is_boosting : bool = false
var is_jump_jetting : bool = false
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
@onready var left_weapon = %LeftWeapon
@onready var right_weapon = %RightWeapon

@onready var pause_menu = $CanvasLayer/PauseMenu

@onready var self_rid: RID = self.get_rid()

func _ready() ->void:
	randomize() 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if build != null:
		if build.head != null:
			pass
		if build.chest != null:
			health_component.set_health_attribute(build.chest.max_health, build.chest.max_health)
			energy_component.set_energy_attribute(build.chest.max_energy, build.chest.max_energy)
		if build.left_arm != null:
			var left_arm_controller = build.left_arm.arm_controller.instantiate()
			left_weapon.add_child(left_arm_controller)
		if build.right_arm != null:
			var right_arm_controller = build.right_arm.arm_controller.instantiate()
			right_weapon.add_child(right_arm_controller)
			left_weapon.get_child(0)
		if build.legs != null:
			normal_speed =  build.legs.base_movement_speed
			boosting_speed =  build.legs.boosting_movement_speed
			jump_power =  build.legs.jump_power
			acceleration =  build.legs.acceleration
		
	
	if pause_menu != null:
		pause_menu.resume.connect(_on_pause_menu_resume) # Hookup resume signal from Pause Menu
		pause_menu.close_pause_menu()


func _input(event) ->void:
	if event is InputEventMouseMotion and !is_movement_paused:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
		neck.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
		neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	if event.is_action_pressed("fire_left_arm") && left_weapon.get_child(0) != null && left_weapon.get_child(0) is WeaponController:
		left_weapon.get_child(0).on_press()
	if event.is_action_pressed("fire_right_arm") && right_weapon.get_child(0) != null && right_weapon.get_child(0) is WeaponController:
		right_weapon.get_child(0).on_press()
	if event.is_action_pressed("boost"):
		if !is_boosting and energy_component and energy_component.current_energy > 0:
			is_boosting = true
		else:
			is_boosting = false
	if event.is_action_pressed("pause"):
		if !is_movement_paused and !is_dead:
			_on_pause_movement()
			pause_menu.open_pause_menu()
	
func _physics_process(delta) ->void:
	var input_dir
	if !is_movement_paused:
		input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	else:
		input_dir = Vector2.ZERO
	
	if is_boosting and energy_component and energy_component.current_energy > 0:
		current_speed = lerp(current_speed, boosting_speed, delta * acceleration)
		is_boosting = true
	else:
		current_speed = lerp(current_speed, normal_speed, delta * acceleration)
		is_boosting = false
		
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	

	
	# Handle jump.
	if Input.is_action_pressed("jump") and energy_component and energy_component.current_energy > 0:
		velocity.y = jump_power
		is_jump_jetting = true
	elif Input.is_action_just_released("jump") and is_on_floor():
		velocity.y = jump_power
		is_jump_jetting = false
	else:
		is_jump_jetting = false
		
	
	if is_on_floor():
		gravity_vec = Vector3.ZERO
	else:
		gravity_vec = Vector3.DOWN * gravity * delta
		
	#current_speed = clamp(current_speed, 3.0, 12.0)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	last_velocity = velocity
	
	velocity += gravity_vec
	move_and_slide()

func _process(_delta)->void:
	if Input.is_action_pressed("fire_left_arm") && left_weapon.get_child(0) != null && left_weapon.get_child(0) is WeaponController:
		left_weapon.get_child(0).on_hold()
	if Input.is_action_pressed("fire_right_arm") && right_weapon.get_child(0) != null && right_weapon.get_child(0) is WeaponController:
		right_weapon.get_child(0).on_hold()

# Signal from Pause Menu
func _on_pause_menu_resume() ->void:
	_reload_options()
	_on_resume_movement()
	
func _on_pause_movement() ->void:
	if !is_movement_paused:
		is_movement_paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_resume_movement() ->void:
	if is_movement_paused:
		is_movement_paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		
# reload options user may have changed while paused.
func _reload_options() ->void:
	pass
