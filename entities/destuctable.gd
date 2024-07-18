extends StaticBody3D

@onready var explosion_fire_ball = $ExplosionFireBall
@onready var health_component = $HealthComponent
@onready var mesh_instance_3d = $MeshInstance3D


func _on_health_component_death()->void:
	explosion_fire_ball.restart()
	mesh_instance_3d.hide()


func hurt(damage_data:DamageData)->void:
	health_component.subtract(damage_data.amount)


func _on_explosion_fire_ball_finished():
	if is_in_group("objective"):
		Global.emit_check_objectives()
	queue_free()
