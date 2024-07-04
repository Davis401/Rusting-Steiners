class_name EnergyComponent
extends Node

signal energy_changed(value_current:float, value_max:float, has_increased:bool)
signal energy_drained(value_current:float, value_max:float)


@export var energy_regen_speed : float = 1
@export var boost_drain_speed : float = 1
@export var regenerate_after : float = 2
@export var auto_regenerate : bool = true

@export var max_energy : float
var current_energy : float

var regen_timer : Timer
var energy_regen_wait : float
var is_regenerating : bool
var player : Node3D


func _ready():
	current_energy = max_energy
	player = get_parent()
	regen_timer = Timer.new()
	regen_timer.wait_time = regenerate_after
	add_child(regen_timer)
	regen_timer.timeout.connect(_on_regen_timer_timeout)


func _process(delta):
	if is_regenerating:
		add(energy_regen_speed * delta)
		if current_energy >= max_energy:
			is_regenerating = false
	
	if player.is_boosting and player.velocity.length() > 0.1:
		regen_timer.stop()
		is_regenerating = false
		subtract(boost_drain_speed * delta)
	
	if !is_regenerating and regen_timer.is_stopped() and current_energy < max_energy and !player.is_boosting:
		regen_timer.start()
	
	
func _on_regen_timer_timeout():
	if !is_regenerating:
		is_regenerating = true
	
func add(amount):
	current_energy += amount
	
	if current_energy > max_energy:
		current_energy = max_energy
	energy_changed.emit(current_energy,max_energy,true)


func subtract(amount):
	current_energy -= amount
	
	if current_energy <= 0:
		current_energy = 0
		energy_drained.emit(current_energy,max_energy)
		
	energy_changed.emit(current_energy,max_energy,false)
