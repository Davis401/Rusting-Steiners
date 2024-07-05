extends Control

@export var health_component:HealthComponent
@export var energy_component:EnergyComponent

@onready var energy_number = %EnergyNumber
@onready var energy_bar = %EnergyBar
@onready var health_number = %HealthNumber
@onready var health_bar = %HealthBar

func _ready() ->void:
	health_component.health_changed.connect(update_hp)
	energy_component.energy_changed.connect(update_energy)


func update_hp(current_health:float, max_health:float, has_increased:bool) ->void:
	health_number.text = "%05d" % current_health
	health_bar.value = int(current_health)
	health_bar.max_value = int(max_health)
	
	
func update_energy(current_energy:float, max_energy:float, has_increased:bool) ->void:
	energy_number.text = "%05d" % current_energy
	energy_bar.value = int(current_energy)
	energy_bar.max_value = int(max_energy)
