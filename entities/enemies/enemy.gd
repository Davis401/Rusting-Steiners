class_name Enemy
extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var knockback = Vector3.ZERO

@onready var health_component:HealthComponent = $HealthComponent
@onready var label_3d = $Label3D

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	health_component.health_changed.connect(update_label)
	health_component.death.connect(die)

func _physics_process(delta)->void:
	knockback = knockback.lerp(Vector3.ZERO, delta * 20)
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
	velocity += knockback
	move_and_slide()

func hurt(damage_data:DamageData)->void:
	health_component.subtract(damage_data.amount)


func update_label(current,max,damaged)->void:
	label_3d.text = str(int(current))

func die() ->void:
	queue_free()
