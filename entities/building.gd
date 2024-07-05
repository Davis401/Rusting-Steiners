extends CSGBox3D
@onready var health_component:HealthComponent = $HealthComponent

func _ready():
	health_component.death.connect(on_die)

func hurt(damage_data:DamageData):
	health_component.subtract(damage_data.amount)
	
func on_die():
	queue_free()
