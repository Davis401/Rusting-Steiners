extends MarginContainer

@export var health_component:HealthComponent
@export var energy_component:EnergyComponent
@onready var health_value = $PanelContainer/VBoxContainer/HBoxContainer/HealthValue
@onready var energy_value = $PanelContainer/VBoxContainer/HBoxContainer2/EnergyValue

# Called when the node enters the scene tree for the first time.
func _ready():
	health_component.health_changed.connect(update_hp)
	energy_component.energy_changed.connect(update_energy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_hp(current_health:float, max_health:float, has_increased:bool):
	health_value.text = str(current_health)
	
	
func update_energy(current_energy:float, max_energy:float, has_increased:bool):
	energy_value.text = str(current_energy)
