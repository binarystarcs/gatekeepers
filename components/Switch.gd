extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var outputs = []

var state: bool = false
var active: bool = true

onready var uiConnector = get_node("/root/ConnectorUi")
onready var offImage = preload("res://assets/offswitch.png")
onready var onImage = preload("res://assets/onswitch.png")
export var identifier = "A"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = identifier


func remove_output(connector):
	var position = outputs.find(connector)
	if position != -1:
		outputs.remove(position)

func update_state():
	if state:
		$Sprite.texture = onImage
	else:
		$Sprite.texture = offImage
	active = true
	for connector in outputs:
		connector.change_state(state)
	

func _on_OutputCollider_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if uiConnector.origin == null:
				uiConnector.handle_wire_start(self, 
					$LeftOutputPosition.global_position,
					$RightOutputPosition.global_position)


func _on_TurnOnArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			state = true
			update_state()


func _on_TurnOffArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			state = false
			update_state()
