class_name Enemy
extends CharacterBody3D

enum State {
	IDLE,
	CHASE,
	ATTACK,
	DEAD
}

var state:State = State.IDLE

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var knockback:Vector3 = Vector3.ZERO
@onready var player = get_tree().get_first_node_in_group("player") 

@onready var health_component:HealthComponent = $HealthComponent
@onready var vision_component:VisionComponent = $VisionComponent
@onready var movement_component:MovementComponent = $MovementComponent

@onready var alert_area:Area3D = $AlertArea

@onready var label_3d:Label3D = $Label3D

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	health_component.health_changed.connect(update_label)
	health_component.death.connect(die)
	
	

func _physics_process(delta)->void:
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	match state:
		State.IDLE:
			process_idle_state(delta)
		State.CHASE:
			process_chase_state(delta)
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
			pass
		State.CHASE:
			pass
		State.ATTACK:
			pass
		State.DEAD:
			collision_layer = 0
			collision_mask = 0
	

func process_chase_state(delta)->void:
	movement_component.set_facing_dir(player.global_position - global_position)
	movement_component.move_to_point(player.global_position)
	move_and_slide()
	

func process_idle_state(delta)->void:
	if vision_component.can_see_player():
		alert()

func process_attack_state(delta)->void:
	movement_component.set_facing_dir(player.global_position - global_position)
	movement_component.move_to_point(player.global_position)
	move_and_slide()

func alert()->void:
	if state == State.IDLE:
		set_state(State.CHASE)


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
	

func die() ->void:
	queue_free()
	
