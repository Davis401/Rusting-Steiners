class_name HealthComponent
extends Node

signal damage_taken()
signal health_changed(current_health:float, max_health:float, has_increased:bool)
signal health_reached_zero(value_current:float, value_max:float)
signal death()

@export var max_health : float
var current_health : float

var parent_position : Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health
	health_reached_zero.connect(on_death)
	health_changed.connect(on_health_change)
	health_changed.emit(current_health,max_health,true)
	

func on_health_change(_health_current:float, _health_max:float, has_increased:bool):
	if !has_increased:
		damage_taken.emit()


func on_death():
	death.emit()
	parent_position = get_parent().global_position
	
	
func add(amount):
	current_health += amount
	
	if current_health > max_health:
		current_health = max_health
	health_changed.emit(current_health,max_health,true)


func subtract(amount):
	current_health -= amount
	
	if current_health <= 0:
		current_health = 0
		health_reached_zero.emit(current_health,max_health)
		
	health_changed.emit(current_health,max_health,false)
