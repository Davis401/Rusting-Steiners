extends CSGBox3D
@onready var health_component:HealthComponent = $HealthComponent

@onready var explosion_fire_ball = $ExplosionFireBall

func _ready():
	health_component.death.connect(on_die)
	var height_change = randi_range(1, 3)
	global_position.y += height_change
	size.y += height_change * 2

func hurt(damage_data:DamageData):
	health_component.subtract(damage_data.amount)
	
func on_die():
	use_collision = false
	explosion_fire_ball.restart()


func _on_explosion_fire_ball_finished():
	if is_in_group("objective"):
		Global.emit_check_objectives()
	queue_free()
