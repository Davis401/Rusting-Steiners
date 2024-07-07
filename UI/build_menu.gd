extends MarginContainer


@onready var head_part_label = %HeadPartLabel
@onready var chest_part_label = %ChestPartLabel
@onready var left_shoulder_part_label = %LeftShoulderPartLabel
@onready var right_shoulder_part_label = %RightShoulderPartLabel
@onready var left_arm_weapon_label = %LeftArmWeaponLabel
@onready var right_arm_weapon_label = %RightArmWeaponLabel
@onready var legs_label = %LegsLabel

var part_idx = 0
var head_idx = 0
var chest_idx = 0
var left_arm_idx = 0
var right_arm_idx = 0
var legs_idx = 0

var owned_head_parts: Array[MechaHead] = []
var owned_chest_parts: Array[MechaChest] = []
var owned_arm_parts: Array[MechaArm] = []
var owned_shoulder_parts: Array[MechaShoulder] = []
var owned_legs_parts: Array[MechaLegs] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.current_build != null:
		update_labels(Global.current_build)
	for part:MechaPart in Global.PARTS:
		if !SaveManager.save_data.owned_parts.has(part.id):return
		if part is MechaHead:
			owned_head_parts.append(part.id)
		elif part is MechaChest:
			owned_chest_parts.append(part.id)
		elif part is MechaArm:
			owned_arm_parts.append(part.id)
		elif part is MechaShoulder:
			owned_shoulder_parts.append(part.id)
		elif part is MechaLegs:
			owned_legs_parts.append(part.id)
	
func _unhandled_input(event):
	if event.is_action_pressed("move_back"):
		part_idx = min(part_idx + 1, 6)
	elif event.is_action_pressed("move_forward"):
		part_idx = min(part_idx - 1, 0)
	elif event.is_action_pressed("move_right"):
		next_part()
	elif event.is_action_pressed("move_back"):
		prev_part()

func next_part() -> void:
	match part_idx:
		0:
			head_idx = min(head_idx + 1, owned_head_parts.size() - 1)
		1:
			chest_idx = min(chest_idx + 1, owned_chest_parts.size() - 1)
	
	
func prev_part():
	pass

func update_labels(build:MechaBuild) -> void:
	if build.head != null:
		head_part_label = build.head.display_name
	if build.chest != null:
		head_part_label = build.chest.display_name
	if build.left_arm != null:
		head_part_label = build.left_arm.display_name
	if build.right_arm != null:
		head_part_label = build.right_arm.display_name
	if build.left_shoulder != null:
		head_part_label = build.left_shoulder.display_name
	if build.right_shoulder != null:
		head_part_label = build.right_shoulder.display_name
	if build.legs != null:
		head_part_label = build.legs.display_name
