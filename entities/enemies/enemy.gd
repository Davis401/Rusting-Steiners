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

var knockback = Vector3.ZERO

@onready var health_component:HealthComponent = $HealthComponent
@onready var vision_component:VisionComponent = $VisionComponent

@onready var label_3d = $Label3D

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	health_component.health_changed.connect(update_label)
	health_component.death.connect(die)
	

func _physics_process(delta)->void:
	match state:
		State.IDLE:
			process_idle_state(delta)
		State.CHASE:
			process_chase_state(delta)
		State.ATTACK:
			process_attack_state(delta)
		State.DEAD:
			return
	

func set_state(_state:State)->void:
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
	move_and_slide()
	

func process_idle_state(delta)->void:
	#print(vision_component.can_see_player())
	pass

func process_attack_state(delta)->void:
	pass
	

func hurt(damage_data:DamageData)->void:
	health_component.subtract(damage_data.amount)
	

func update_label(current,max,damaged)->void:
	label_3d.text = str(int(current))
	

func die() ->void:
	queue_free()
	
