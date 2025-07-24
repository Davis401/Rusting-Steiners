extends MarginContainer

signal close

enum PART_TYPE {
	HEAD,
	CHEST,
	L_SHLDR,
	R_SHLDR,
	L_ARM,
	R_ARM,
	LEGS
}

const PART_BUTTON = preload("res://UI/part_button.tscn")

@export var is_open = false

var working_build = MechaBuild.new()

var head_parts: Array[MechaHead] = []
var chest_parts: Array[MechaChest] = []
var left_arm_parts: Array[MechaArm] = []
var right_arm_parts: Array[MechaArm] = []
var left_shoulder_parts: Array[MechaShoulder] = []
var right_shoulder_parts: Array[MechaShoulder] = []
var legs_parts: Array[MechaLegs] = []

@onready var part_list = $HBoxContainer/PartListContianer/PartList

@onready var weight_value = %WeightValue
@onready var max_weight_value = %MaxWeightValue
@onready var walk_speed_value = %WalkSpeedValue
@onready var boost_speed_value = %BoostSpeedValue
@onready var health_value = %HealthValue
@onready var energy_value = %EnergyValue
@onready var accuracy_value = %AccuracyValue
@onready var missile_lock_on_time_value = %MissileLockOnTimeValue
@onready var jump_power_value = %JumpPowerValue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = is_open

func open():
	is_open = true
	head_parts = []
	chest_parts = []
	left_arm_parts = []
	right_arm_parts = []
	left_shoulder_parts = []
	right_shoulder_parts = []
	legs_parts = []
	
	if Global.current_build != null:
		working_build = Global.current_build
	for part:MechaPart in Global.PARTS:
		if !SaveManager.save_data.owned_parts.has(part.id):
			pass
		elif part is MechaHead:
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
	
	update_stats_labels()
	show()


func _on_head_button_pressed():
	for child in part_list.get_children():
		child.queue_free()
	if head_parts.size() > 0:
		for head_part:MechaHead in head_parts:
			var btn = PART_BUTTON.instantiate()
			part_list.add_child(btn)
			btn.text = head_part.display_name
			btn.pressed.connect(equip_head.bind(head_part, btn))
			if head_part.id == working_build.head.id:
				btn.selected = true
			
	else:
		var label = Label.new()
		label.text = "None"
		label.custom_minimum_size = Vector2(500, 50)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		part_list.add_child(label)


func _on_chest_button_pressed():
	for child in part_list.get_children():
		child.queue_free()
	if chest_parts.size() > 0:
		for chest_part:MechaChest in chest_parts:
			var btn = PART_BUTTON.instantiate()
			part_list.add_child(btn)
			btn.text = chest_part.display_name
			btn.pressed.connect(equip_chest.bind(chest_part, btn))
			if chest_part.id == working_build.chest.id:
				btn.selected = true
			
	else:
		var label = Label.new()
		label.text = "None"
		label.custom_minimum_size = Vector2(500, 50)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		part_list.add_child(label)


func _on_left_shoulder_button_pressed():
	for child in part_list.get_children():
		child.queue_free()
	if left_shoulder_parts.size() > 0:
		for left_shoulder_part:MechaShoulder in left_shoulder_parts:
			var btn = PART_BUTTON.instantiate()
			part_list.add_child(btn)
			btn.text = left_shoulder_part.display_name
			btn.pressed.connect(equip_left_shoulder.bind(left_shoulder_part, btn))
			if left_shoulder_part.id == working_build.left_shoulder.id:
				btn.selected = true
			
	else:
		var label = Label.new()
		label.text = "None"
		label.custom_minimum_size = Vector2(500, 50)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		part_list.add_child(label)


func _on_right_shoulder_button_pressed():
	for child in part_list.get_children():
		child.queue_free()
	if right_shoulder_parts.size() > 0:
		for right_shoulder_part:MechaShoulder in right_shoulder_parts:
			var btn = PART_BUTTON.instantiate()
			part_list.add_child(btn)
			btn.text = right_shoulder_part.display_name
			btn.pressed.connect(equip_right_shoulder.bind(right_shoulder_part, btn))
			if right_shoulder_part.id == working_build.right_shoulder.id:
				btn.selected = true
	else:
		var label = Label.new()
		label.text = "None"
		label.custom_minimum_size = Vector2(500, 50)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		part_list.add_child(label)


func _on_left_arm_button_pressed():
	for child in part_list.get_children():
		child.queue_free()
	if left_arm_parts.size() > 0:
		for left_arm_part:MechaArm in left_arm_parts:
			var btn = PART_BUTTON.instantiate()
			part_list.add_child(btn)
			btn.text = left_arm_part.display_name
			btn.pressed.connect(equip_left_arm.bind(left_arm_part, btn))
			if left_arm_part.id == working_build.left_arm.id:
				btn.selected = true
			
	else:
		var label = Label.new()
		label.text = "None"
		label.custom_minimum_size = Vector2(500, 50)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		part_list.add_child(label)


func _on_right_arm_button_pressed():
	for child in part_list.get_children():
		child.queue_free()
	if right_arm_parts.size() > 0:
		for right_arm_part:MechaArm in right_arm_parts:
			var btn = PART_BUTTON.instantiate()
			part_list.add_child(btn)
			btn.text = right_arm_part.display_name
			btn.pressed.connect(equip_right_arm.bind(right_arm_part, btn))
			if right_arm_part.id == working_build.right_arm.id:
				btn.selected = true
			
	else:
		var label = Label.new()
		label.text = "None"
		label.custom_minimum_size = Vector2(500, 50)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		part_list.add_child(label)


func _on_legs_button_pressed():
	for child in part_list.get_children():
		child.queue_free()
	if legs_parts.size() > 0:
		for legs_part:MechaLegs in legs_parts:
			var btn = PART_BUTTON.instantiate()
			part_list.add_child(btn)
			btn.text = legs_part.display_name
			btn.pressed.connect(equip_legs.bind(legs_part, btn))
			if legs_part.id == working_build.legs.id:
				btn.selected = true

	else:
		var label = Label.new()
		label.text = "None"
		label.custom_minimum_size = Vector2(500, 50)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		part_list.add_child(label)
		


func equip_head(head_part:MechaHead, btn:Button)->void:
	for child in part_list.get_children():
		child.selected = false
	btn.selected = true
	working_build.head = head_part
	update_stats_labels()

func equip_chest(chest_part:MechaChest, btn:Button)->void:
	for child in part_list.get_children():
		child.selected = false
	btn.selected = true
	working_build.chest = chest_part
	update_stats_labels()

func equip_left_shoulder(left_shoulder_part:MechaShoulder, btn:Button)->void:
	for child in part_list.get_children():
		child.selected = false
	btn.selected = true
	working_build.left_shoulder = left_shoulder_part
	update_stats_labels()

func equip_right_shoulder(right_shoulder_part:MechaShoulder, btn:Button)->void:
	for child in part_list.get_children():
		child.selected = false
	btn.selected = true
	working_build.right_shoulder = right_shoulder_part
	update_stats_labels()

func equip_left_arm(left_arm_part:MechaArm, btn:Button)->void:
	for child in part_list.get_children():
		child.selected = false
	btn.selected = true
	working_build.left_arm = left_arm_part
	update_stats_labels()

func equip_right_arm(right_arm_part:MechaArm, btn:Button)->void:
	for child in part_list.get_children():
		child.selected = false
	btn.selected = true
	working_build.right_arm = right_arm_part
	update_stats_labels()

func equip_legs(legs_part:MechaLegs, btn:Button)->void:
	for child in part_list.get_children():
		child.selected = false
	btn.selected = true
	working_build.legs = legs_part
	update_stats_labels()

func _on_quit_button_pressed()->void:
	if working_build.total_weight <= working_build.legs.weight_capacity:
		Global.current_build = working_build
		close.emit()
		hide()


func update_stats_labels() ->void:
	working_build.total_weight = working_build.head.weight + working_build.chest.weight + working_build.left_shoulder.weight  + working_build.right_shoulder.weight  + working_build.left_arm.weight + working_build.right_arm.weight  + working_build.legs.weight
	weight_value.text = str(working_build.total_weight)
	max_weight_value.text = str(working_build.legs.weight_capacity)
	walk_speed_value.text = str(working_build.legs.base_movement_speed)
	boost_speed_value.text = str(working_build.legs.boosting_movement_speed)
	health_value.text = str(working_build.chest.max_health)
	energy_value.text = str(working_build.chest.max_energy)
	accuracy_value.text = str(working_build.head.accuracy)
	missile_lock_on_time_value.text = str(working_build.head.missile_lock_on_time)
	jump_power_value.text = str(working_build.legs.jump_power)
