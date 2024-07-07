class_name PlayerMech
extends CharacterBody3D

@export var build:MechaBuild

@export_group("Movement Properties")
@export var MOUSE_SENS : float = 0.25
@export var LERP_SPEED : float = 10.0

var turning_sounds = [preload("res://assets/sfx/Ovani/Tractor Gear Shift A.wav"), preload("res://assets/sfx/Ovani/Tractor Gear Shift B.wav"), preload("res://assets/sfx/Ovani/Tractor Gear Shift C.wav")]
@onready var turn_player = $AudioPlayers/TurnPlayer
@onready var thruster = $AudioPlayers/Thruster

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
@onready var energy_component:EnergyComponent = $EnergyComponent
@onready var health_component:HealthComponent = $HealthComponent

@onready var neck: Node3D  = $Neck
@onready var head: Node3D  = $Neck/Head
@onready var camera:Camera3D = $Neck/Head/Camera3D
@onready var animation_player:AnimationPlayer = $Neck/Head/AnimationPlayer

@onready var left_arm_weapon: Node3D = %LeftArmWeapon
@onready var right_arm_weapon: Node3D = %RightArmWeapon
@onready var left_shoulder_weapon: Node3D = %LeftShoulderWeapon
@onready var right_shoulder_weapon: Node3D = %RightShoulderWeapon

@onready var step_timer: Timer = $StepTimer

@onready var pause_menu = $CanvasLayer/PauseMenu


@onready var step_left = $AudioPlayers/StepLeft
@onready var step_right = $AudioPlayers/StepRight
var step_players = []
var step_idx = 0

var wish_jump = false

#Leaning
var wish_lean = 0.0

@onready var self_rid: RID = self.get_rid()

func _ready() ->void:
	step_players = [step_left, step_right]
	randomize() 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	energy_component.energy_drained.connect(on_energy_drained)
	if build != null:
		if build.head != null:
			pass
		if build.chest != null:
			health_component.set_health_attribute(build.chest.max_health, build.chest.max_health)
			energy_component.set_energy_attribute(build.chest.max_energy, build.chest.max_energy)
		if build.left_arm != null:
			var left_arm_controller = build.left_arm.arm_controller.instantiate()
			left_arm_weapon.add_child(left_arm_controller)
		if build.right_arm != null:
			var right_arm_controller = build.right_arm.arm_controller.instantiate()
			right_arm_weapon.add_child(right_arm_controller)
		if build.left_shoulder != null:
			var left_shoulder_controller = build.left_shoulder.shoulder_controller.instantiate()
			left_shoulder_weapon.add_child(left_shoulder_controller)
		if build.right_shoulder != null:
			var right_shoulder_controller = build.right_shoulder.shoulder_controller.instantiate()
			right_shoulder_weapon.add_child(right_shoulder_controller)
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
		if !turn_player.playing:
			turn_player.stream = turning_sounds.pick_random()
			turn_player.pitch_scale = randf_range(0.9, 1.1)
			turn_player.play()
	#Arm Weapons
	if event.is_action_pressed("fire_left_arm") && left_arm_weapon.get_child(0) != null && left_arm_weapon.get_child(0) is WeaponController:
		left_arm_weapon.get_child(0).on_press()
	if event.is_action_pressed("fire_right_arm") && right_arm_weapon.get_child(0) != null && right_arm_weapon.get_child(0) is WeaponController:
		right_arm_weapon.get_child(0).on_press()
	if event.is_action_released("fire_left_arm") && left_arm_weapon.get_child(0) != null && left_arm_weapon.get_child(0) is WeaponController:
		left_arm_weapon.get_child(0).on_release()
	if event.is_action_released("fire_right_arm") && right_arm_weapon.get_child(0) != null && right_arm_weapon.get_child(0) is WeaponController:
		right_arm_weapon.get_child(0).on_release()
	
	#Shoudler Weapons
	if event.is_action_pressed("fire_left_shoulder") && left_shoulder_weapon.get_child(0) != null && left_shoulder_weapon.get_child(0) is WeaponController:
		left_shoulder_weapon.get_child(0).on_press()
	if event.is_action_pressed("fire_right_shoulder") && right_shoulder_weapon.get_child(0) != null && right_shoulder_weapon.get_child(0) is WeaponController:
		right_shoulder_weapon.get_child(0).on_press()
	if event.is_action_released("fire_left_shoulder") && left_shoulder_weapon.get_child(0) != null && left_shoulder_weapon.get_child(0) is WeaponController:
		left_shoulder_weapon.get_child(0).on_release()
	if event.is_action_released("fire_right_shoulder") && right_shoulder_weapon.get_child(0) != null && right_shoulder_weapon.get_child(0) is WeaponController:
		right_shoulder_weapon.get_child(0).on_release()
	
	if event.is_action_pressed("boost"):
		if !is_boosting and energy_component and energy_component.current_energy > 0:
			is_boosting = true
		else:
			is_boosting = false
			
	if is_on_floor() && event.is_action_pressed("jump"):
		wish_jump = true
	if !is_on_floor() && event.is_action_pressed("jump") and energy_component and energy_component.current_energy > 0:
		is_jump_jetting = true
		
	if is_jump_jetting && event.is_action_released("jump"):
		is_jump_jetting = false
		
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
		
		#Lean on strafe
	if is_boosting && input_dir.x >= 0.5:
		wish_lean = deg_to_rad(-3.0)
	elif is_boosting && input_dir.x <= -0.5:
		wish_lean = deg_to_rad(3.0)
	else:
		wish_lean = 0.0
	
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Handle jump.
	
	if wish_jump:
		velocity.y = jump_power
		wish_jump = false
	if is_jump_jetting:
		if !is_on_floor() and energy_component and energy_component.current_energy > 0:
			velocity.y = jump_power
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
	
	if is_on_floor() and !is_boosting and velocity.length() >= 0.2:
		if step_timer.time_left <= 0:
			var sfx_player = step_players[step_idx]
			step_idx = (step_idx + 1) % 2
			sfx_player.pitch_scale = randf_range(0.8, 1.2)
			sfx_player.play()
			step_timer.start(0.8)

func _process(delta)->void:
	neck.rotation.z = lerp_angle(neck.rotation.z, wish_lean, delta * LERP_SPEED)
	if Input.is_action_pressed("fire_left_arm") && left_arm_weapon.get_child(0) != null && left_arm_weapon.get_child(0) is WeaponController:
		left_arm_weapon.get_child(0).on_hold()
	if Input.is_action_pressed("fire_right_arm") && right_arm_weapon.get_child(0) != null && right_arm_weapon.get_child(0) is WeaponController:
		right_arm_weapon.get_child(0).on_hold()
	if Input.is_action_pressed("fire_left_shoulder") && left_shoulder_weapon.get_child(0) != null && left_shoulder_weapon.get_child(0) is WeaponController:
		left_shoulder_weapon.get_child(0).on_hold()
	if Input.is_action_pressed("fire_right_shoulder") && right_shoulder_weapon.get_child(0) != null && right_shoulder_weapon.get_child(0) is WeaponController:
		right_shoulder_weapon.get_child(0).on_hold()
	if is_boosting:
		thruster.play()
	else:
		thruster.stop()

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
	
func on_energy_drained():
	is_boosting = false
	is_jump_jetting = false
