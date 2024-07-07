extends Node3D
@onready var smoke_particles = $SmokeParticles

func _ready()->void:
	add_to_group("instantiated")
	$GPUParticles3D.restart()
	smoke_particles.restart()

func _on_gpu_particles_3d_finished() ->void:
	queue_free()
