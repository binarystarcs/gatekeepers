extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dragEnabled: bool = false
var oldPosition = Vector2(0, 0)
var leftInput = null
var rightInput = null
var outputs = []
export var identifier = "A"


var state: bool = false
var active: bool = false

onready var uiConnector = get_node("/root/ConnectorUi")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_identifier(newId):
	if newId == null:
		identifier = ""
		$Label.hide()
	else:
		identifier = newId
		$Label.text = identifier
		$Label.show()

func _process(delta):
	if dragEnabled:
		var newPosition = get_global_mouse_position()
		var movement = newPosition - oldPosition
		oldPosition = newPosition
		move_and_collide(movement)


func remove_output(connector):
	var position = outputs.find(connector)
	if position != -1:
		outputs.remove(position)

func remove_input(connector):
	if leftInput == connector:
		leftInput = null
	if rightInput == connector:
		rightInput = null
	update_state()
	
func update_state():
	if leftInput == null or rightInput == null:
		state = false
		active = false
	else:
		state = leftInput.state or rightInput.state
		active = true
	for connector in outputs:
		connector.change_state(state)
	
func _on_DragCollider_input_event(viewport, event, shape_idx):
	if outputs.size() == 0 and leftInput == null and rightInput == null and uiConnector.origin == null:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				oldPosition = get_global_mouse_position()
				dragEnabled = event.pressed

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			dragEnabled = false

func _on_OutputCollider_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if uiConnector.origin == null:
				uiConnector.handle_wire_start(self, 
					$LeftOutputPosition.global_position,
					$RightOutputPosition.global_position)


func _on_FirstInputCollider_input_event(viewport, event, shape_idx):
	if leftInput != null:
		return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if uiConnector.origin != null:
				var connector = uiConnector.handle_wire_end(self, 
					$LeftFirstInputPosition.global_position, 
					$RightFirstInputPosition.global_position)
				if connector != null:
					leftInput = connector
					update_state()
			# Add ELIF for no plugging to self

func _on_SecondInputCollider_input_event(viewport, event, shape_idx):
	if rightInput != null:
		return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if uiConnector.origin != null:
				var connector = uiConnector.handle_wire_end(self,
					$LeftSecondInputPosition.global_position,
					$RightSecondInputPosition.global_position)
				if connector != null:
					rightInput = connector
					update_state()
					
