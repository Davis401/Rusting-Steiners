extends CSGBox3D
@onready var health_component:HealthComponent = $HealthComponent

@onready var explosion_fire_ball = $ExplosionFireBall

func _ready():
	health_component.death.connect(on_die)

func hurt(damage_data:DamageData):
	health_component.subtract(damage_data.amount)
	
func on_die():
	use_collision = false
	explosion_fire_ball.restart()


func _on_explosion_fire_ball_finished():
	queue_free()
