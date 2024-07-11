extends MarginContainer

signal close

const PART_BUTTON = preload("res://UI/part_button.tscn")

@export var is_open = false


var head_parts: Array[MechaHead] = []
var chest_parts: Array[MechaChest] = []
var arm_parts: Array[MechaArm] = []
var shoulder_parts: Array[MechaShoulder] = []
var legs_parts: Array[MechaLegs] = []

var focused_part:MechaPart
var focused_part_button:Button

@onready var part_list = $HBoxContainer/PartListContianer/PartList
@onready var mech_stats = %MechStats


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = is_open


func open():
	head_parts = []
	chest_parts = []
	arm_parts = []
	shoulder_parts = []
	legs_parts = []
	is_open = true
	for part:MechaPart in Global.PARTS:
		if SaveManager.save_data.owned_parts.has(part.id):
			pass
		elif part is MechaHead:
			head_parts.append(part)
		elif part is MechaChest:
			chest_parts.append(part)
		elif part is MechaArm:
			arm_parts.append(part)
		elif part is MechaShoulder:
			shoulder_parts.append(part)
		elif part is MechaLegs:
			legs_parts.append(part)
	show()
	
	

func _on_head_button_pressed() -> void:
	for child in part_list.get_children():
		child.queue_free()
	if head_parts.size() > 0:
		for head_part:MechaHead in head_parts:
			var btn = PART_BUTTON.instantiate()
			part_list.add_child(btn)
			btn.text = head_part.display_name
			btn.pressed.connect(show_part_data.bind(head_part, btn))
			
	else:
		var label = Label.new()
		label.text = "None"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.custom_minimum_size = Vector2(500, 50)
		part_list.add_child(label)
	

func _on_chest_button_pressed() -> void:
	for child in part_list.get_children():
		child.queue_free()
	if chest_parts.size() > 0:
		for chest_part:MechaChest in chest_parts:
			var btn = PART_BUTTON.instantiate()
			part_list.add_child(btn)
			btn.text = chest_part.display_name
			btn.pressed.connect(show_part_data.bind(chest_part, btn))
			
	else:
		var label = Label.new()
		label.text = "None"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.custom_minimum_size = Vector2(500, 50)
		part_list.add_child(label)
	

func _on_shoulder_button_pressed() -> void:
	for child in part_list.get_children():
		child.queue_free()
	if shoulder_parts.size() > 0:
		for shoulder_part:MechaShoulder in shoulder_parts:
			var btn = PART_BUTTON.instantiate()
			part_list.add_child(btn)
			btn.text = shoulder_part.display_name
			btn.pressed.connect(show_part_data.bind(shoulder_part, btn))
	else:
		var label = Label.new()
		label.text = "None"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.custom_minimum_size = Vector2(500, 50)
		part_list.add_child(label)
	

func _on_arm_button_pressed() -> void:
	for child in part_list.get_children():
		child.queue_free()
	if arm_parts.size() > 0:
		for arm_part:MechaArm in arm_parts:
			var btn = PART_BUTTON.instantiate()
			part_list.add_child(btn)
			btn.text = arm_part.display_name
			btn.pressed.connect(show_part_data.bind(arm_part, btn))
	else:
		var label = Label.new()
		label.text = "None"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.custom_minimum_size = Vector2(500, 50)
		part_list.add_child(label)
	
	


func _on_legs_button_pressed() -> void:
	for child in part_list.get_children():
		child.queue_free()
	if legs_parts.size() > 0:
		for legs_part:MechaLegs in legs_parts:
			var btn = PART_BUTTON.instantiate()
			btn.text = legs_part.display_name
			btn.pressed.connect(show_part_data.bind(legs_part, btn))
			btn.custom_minimum_size = Vector2(500, 50)
			part_list.add_child(btn)
	else:
		var label = Label.new()
		label.text = "None"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.custom_minimum_size = Vector2(500, 50)
		part_list.add_child(label)
		


func show_part_data(part:MechaPart, button:Button) -> void:
	for child in part_list.get_children():
		child.selected = false
	button.selected = true
	focused_part = part
	focused_part_button = button
	
	for child in mech_stats.get_children():
		child.queue_free()
	var part_info:Dictionary = part.get_part_info()
	for key:String in part_info.keys():
		var h_box_container:HBoxContainer = HBoxContainer.new()
		h_box_container.custom_minimum_size = Vector2(500,50)
		h_box_container.alignment = BoxContainer.ALIGNMENT_CENTER
		
		var label:Label = Label.new()
		label.text = str(key)
		label.custom_minimum_size = Vector2(0,50)
		label.size_flags_horizontal = Control.SIZE_EXPAND
		h_box_container.add_child(label)
		
		var value_label:Label = Label.new()
		value_label.text = str(part_info[key])
		value_label.custom_minimum_size = Vector2(0,50)
		value_label.size_flags_horizontal = Control.SIZE_SHRINK_END
		h_box_container.add_child(value_label)
		
		mech_stats.add_child(h_box_container)
		
	var buy_button = Button.new()
	buy_button.text = "¤ " + str(focused_part.cost)
	buy_button.custom_minimum_size = Vector2(500,50)
	buy_button.size_flags_vertical = Control.SIZE_SHRINK_END
	mech_stats.add_child(buy_button)
	buy_button.pressed.connect(_on_buy_button_pressed)
	

func _on_quit_button_pressed() -> void:
	is_open = false
	hide()
	close.emit()
	

func _on_buy_button_pressed() -> void:
	if SaveManager.save_data.money >= focused_part.cost && !SaveManager.save_data.owned_parts.has(focused_part.id):
		SaveManager.save_data.money -= focused_part.cost
		SaveManager.save_data.owned_parts[focused_part.id] = true
		Global.update_money(SaveManager.save_data.money)
		focused_part_button.queue_free()
