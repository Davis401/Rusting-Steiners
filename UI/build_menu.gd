extends MarginContainer

signal close


@onready var head_part_label = %HeadPartLabel
@onready var chest_part_label = %ChestPartLabel
@onready var left_shoulder_part_label = %LeftShoulderPartLabel
@onready var right_shoulder_part_label = %RightShoulderPartLabel
@onready var left_arm_weapon_label = %LeftArmWeaponLabel
@onready var right_arm_weapon_label = %RightArmWeaponLabel
@onready var legs_label = %LegsLabel

@export var is_open = false

var working_build = MechaBuild.new()

var part_idx = 0
var head_idx = 0
var chest_idx = 0
var left_arm_idx = 0
var right_arm_idx = 0
var left_shoulder_idx = 0
var right_shoulder_idx = 0
var legs_idx = 0

var head_parts: Array[MechaHead] = []
var chest_parts: Array[MechaChest] = []
var left_arm_parts: Array[MechaArm] = []
var right_arm_parts: Array[MechaArm] = []
var left_shoulder_parts: Array[MechaShoulder] = []
var right_shoulder_parts: Array[MechaShoulder] = []
var legs_parts: Array[MechaLegs] = []

var highlighted_node:Control
@onready var part_slots :Array[Control]= [%HeadContainer, %ChestContainer, %LeftShoulder, %RightShoulder, %LeftArmContainer, %RightArmContainer, %LegsContainer]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = is_open
	if Global.current_build != null:
		working_build = Global.current_build
		update_labels()
	for part:MechaPart in Global.PARTS:
		if !SaveManager.save_data.owned_parts.has(part.id):return
		if part is MechaHead:
			head_parts.append(part)
		elif part is MechaChest:
			chest_parts.append(part)
		elif part is MechaArm:
			left_arm_parts.append(part)
			right_arm_parts.append(part)
		elif part is MechaShoulder:
			left_shoulder_parts.append(part)
			right_shoulder_parts.append(part)
		elif part is MechaLegs:
			legs_parts.append(part)

func open():
	is_open = true
	show()
	part_idx = 0
	change_highlights(part_slots[part_idx],part_slots[part_idx])

func _unhandled_input(event):
	if event.is_action_pressed("move_back"):
		var old_idx = part_idx
		part_idx = min(part_idx + 1, 6)
		change_highlights(part_slots[old_idx],part_slots[part_idx])
	elif event.is_action_pressed("move_forward"):
		var old_idx = part_idx
		part_idx = max(part_idx - 1, 0)
		change_highlights(part_slots[old_idx],part_slots[part_idx])
	elif event.is_action_pressed("move_right"):
		next_part()
	elif event.is_action_pressed("move_back"):
		prev_part()

func next_part() -> void:
	match part_idx:
		0:
			head_idx = min(head_idx + 1, head_parts.size() - 1)
			working_build.head = head_parts[head_idx]
		1:
			chest_idx = min(chest_idx + 1, chest_parts.size() - 1)
			working_build.chest = chest_parts[chest_idx]
		2:
			left_shoulder_idx = min(left_shoulder_idx + 1, left_shoulder_parts.size() - 1)
			working_build.left_shoulder = left_shoulder_parts[left_shoulder_idx]
		3:
			right_shoulder_idx = min(right_shoulder_idx + 1,right_shoulder_parts.size() - 1)
			working_build.right_shoulder = right_shoulder_parts[right_shoulder_idx]
		4:
			left_arm_idx = min(left_arm_idx + 1, left_arm_parts.size() - 1)
			working_build.chest = left_arm_parts[left_arm_idx]
		5:
			right_arm_idx = min(right_arm_idx + 1, right_arm_parts.size() - 1)
			working_build.chest = right_arm_parts[right_arm_idx]
		6:
			legs_idx = min(legs_idx + 1, legs_parts.size() - 1)
			working_build.legs = legs_parts[legs_idx]
	update_labels()
	
func prev_part():
	pass

func update_labels() -> void:
	print("update_labels")
	if working_build.head != null:
		head_part_label = working_build.head.display_name
	if working_build.chest != null:
		head_part_label = working_build.chest.display_name
	if working_build.left_arm != null:
		head_part_label = working_build.left_arm.display_name
	if working_build.right_arm != null:
		head_part_label = working_build.right_arm.display_name
	if working_build.left_shoulder != null:
		head_part_label = working_build.left_shoulder.display_name
	if working_build.right_shoulder != null:
		head_part_label = working_build.right_shoulder.display_name
	if working_build.legs != null:
		head_part_label = working_build.legs.display_name


func _on_back_button_pressed():
	is_open = false
	close.emit()
	hide()


func change_highlights(old_container:Control, new_container:Control):
	for child:Label in old_container.get_children():
		child.set("theme_override_colors/font_color","#e3e3e3")
	for child:Label in new_container.get_children():
		child.set("theme_override_colors/font_color", "#2b2b2b")
		
