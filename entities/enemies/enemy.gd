class_name Enemy
extends CharacterBody3D

enum State {
	IDLE,
	ATTACK,
	DEAD
}

const LASER_SOUNDS = [
	preload("res://assets/sfx/Ovani/Plasma Turret Single 001.wav"),
	preload("res://assets/sfx/Ovani/Plasma Turret Single 002.wav"),
	preload("res://assets/sfx/Ovani/Plasma Turret Single 003.wav"),
	preload("res://assets/sfx/Ovani/Plasma Turret Single 004.wav")
	]

var state:State = State.IDLE

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var attack_range:float

var _animation_player:AnimationPlayer

@export var minimum_distance_to_player := 1.0

var knockback:Vector3 = Vector3.ZERO
@onready var player = get_tree().get_first_node_in_group("player") 

@onready var health_component:HealthComponent = $HealthComponent
@onready var vision_component:VisionComponent = $VisionComponent
@onready var movement_component:MovementComponent = $MovementComponent

@onready var alert_area:Area3D = $AlertArea
@onready var label_3d:Label3D = $Label3D
@onready var attack_emitter:AttackEmitter = $AttackEmitter


# Called when the node enters the scene tree for the first time.
func _ready()->void:
	health_component.health_changed.connect(update_label)
	health_component.death.connect(die)
	for child in get_children():
		if child is AttackEmitter:
			child.set_bodies_to_exclude([self])
	

func _physics_process(delta)->void:
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	match state:
		State.IDLE:
			process_idle_state(delta)
		State.ATTACK:
			process_attack_state(delta)
		State.DEAD:
			pass
	

func set_state(_state:State)->void:
	if state == State.DEAD:
		return
	state = _state
	match state:
		State.IDLE:
			if _animation_player != null && is_instance_valid(_animation_player):
				_animation_player.play("idle")
		State.ATTACK:
			pass
		State.DEAD:
			if _animation_player != null && is_instance_valid(_animation_player):
				_animation_player.play("die")
			collision_layer = 0
			collision_mask = 0
	

func process_idle_state(delta)->void:
	if vision_component.can_see_target(player):
		alert()
	

func process_attack_state(delta)->void:
	var is_attacking = false
	if _animation_player != null && is_instance_valid(_animation_player):
		is_attacking = _animation_player.current_animation == "attack"
	var vec_to_player = player.global_position - global_position
	
	if vec_to_player.length() <= attack_range:
		movement_component.stop_moving()
		if !is_attacking and vision_component.is_facing_target(player):
			start_attack()
		elif !is_attacking:
			movement_component.set_facing_dir(vec_to_player)
	elif !is_attacking:
		movement_component.set_facing_dir(movement_component.move_dir)
		if vec_to_player.length() > minimum_distance_to_player:
			movement_component.move_to_point(player.global_position)
			if _animation_player != null && is_instance_valid(_animation_player):
				_animation_player.play("walk")
	move_and_slide()
	

func alert()->void:
	if state == State.IDLE:
		set_state(State.ATTACK)
	

func alert_nearby()->void:
	for b in alert_area.get_overlapping_bodies():
		if b is Enemy:
			b.alert()
			

func hurt(damage_data:DamageData)->void:
	health_component.subtract(damage_data.amount)
	alert()
	alert_nearby()
	

func update_label(current,max,damaged)->void:
	label_3d.text = str(int(current))
	

func die()->void:
	set_state(State.DEAD)
	

func finish_die()->void:
	if is_in_group("objective"):
		Global.emit_check_objectives()
	queue_free()
	

func start_attack()->void:
	if _animation_player != null && is_instance_valid(_animation_player):
		_animation_player.play("attack")
	

func do_attack()->void:
	var sfx = AudioManager.play_sound3D(LASER_SOUNDS.pick_random())
	sfx.volume_db = -20.0
	sfx.global_position = global_position
	attack_emitter.attack()
	

