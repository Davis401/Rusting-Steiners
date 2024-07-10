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
@onready var buy_button = %BuyButton


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
	
	

func _on_head_button_pressed():
	print("SHow Head")
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


func _on_chest_button_pressed():
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

func _on_shoulder_button_pressed():
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


func _on_arm_button_pressed():
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
	
	


func _on_legs_button_pressed():
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
		


func show_part_data(part:MechaPart, button:Button):
	for child in part_list.get_children():
		child.selected = false
	button.selected = true
	focused_part = part
	focused_part_button = button
	buy_button.text = str(focused_part.cost)


func _on_quit_button_pressed():
	is_open = false
	hide()
	close.emit()





func _on_buy_button_pressed():
	print("Buy")
	if SaveManager.save_data.money >= focused_part.cost && !SaveManager.save_data.owned_parts.has(focused_part.id):
		SaveManager.save_data.money -= focused_part.cost
		SaveManager.save_data.owned_parts[focused_part.id] = true
		Global.update_money(SaveManager.save_data.money)
		focused_part_button.queue_free()
