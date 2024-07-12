extends WeaponController

const PROTON_HEAVY_GUN_A = preload("res://assets/sfx/Ovani/Proton Heavy Gun A.wav")

@export var ammo_count:int
@export var charge_time:float

var charging:bool = false
var firing:bool = false
var fully_locked:bool = false
var lock_on_target:Node3D
var fire_delay:float = 0.2

@onready var charge_timer:Timer = $ChargeTimer
@onready var cooldown_timer:Timer  = $CooldownTimer

@onready var attack_emitter = $AttackEmitter

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	if spawn_point_node != null:
		attack_emitter.global_position = spawn_point_node.global_position
	if Global.current_build.head != null:
		charge_time = Global.current_build.head.missile_lock_on_time
	

func on_press()->void:
	if charging || firing || current_ammo <= 0 || !cooldown_timer.is_stopped():
		return
		
	
	var lock_on_nodes = get_tree().get_nodes_in_group("lock_on_target")
	for node in lock_on_nodes:
		if camera.is_position_in_frustum(node.global_position) && !node.locked_on && node.global_position.distance_to(global_position) < Global.current_build.head.max_lock_range:
			if lock_on_target == null:
				lock_on_target = node
			elif node.global_position.distance_to(camera.global_position) < lock_on_target.global_position.distance_to(camera.global_position):
				lock_on_target = node
	
	if lock_on_target != null:
		charging = true
		charge_timer.start(charge_time)
	

#Called when released
func on_release()->void:
	if fully_locked:
		current_ammo -= 1
		attack_emitter.attack()
		fully_locked = false
		lock_on_target.locked_on = false
		AudioManager.play_sound3D(PROTON_HEAVY_GUN_A)
		
	charging = false
	charge_timer.stop()
	cooldown_timer.start(time_between_attacks)

func _on_charge_timer_timeout():
	if charging:
		fully_locked = true
		lock_on_target.locked_on = true
		
