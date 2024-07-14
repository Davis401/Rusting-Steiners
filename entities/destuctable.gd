extends StaticBody3D

@onready var explosion_fire_ball = $ExplosionFireBall
@onready var health_component = $HealthComponent


func _on_health_component_death()->void:
	if is_in_group("objective"):
		Global.emit_check_objectives()
	explosion_fire_ball.emitting = true
	await get_tree().create_timer(1.0)
	queue_free()

func hurt(damage_data:DamageData)->void:
	health_component.subtract(damage_data.amount)
