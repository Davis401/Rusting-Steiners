extends Node3D

func _ready():
	add_to_group("instantiated")
	$GPUParticles3D.restart()

func _on_gpu_particles_3d_finished():
	queue_free()
