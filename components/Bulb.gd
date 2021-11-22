extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dragEnabled: bool = false
var oldPosition = Vector2(0, 0)
var onlyInput = null
export var identifier = "Q"
var truthTable = null

var state: bool = false
var active: bool = false

onready var uiConnector = get_node("/root/ConnectorUi")
onready var onImage = preload("res://assets/lightbulb.png")
onready var offImage = preload("res://assets/darkbulb.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = identifier

func _process(delta):
	if dragEnabled:
		var newPosition = get_global_mouse_position()
		var movement = newPosition - oldPosition
		oldPosition = newPosition
		move_and_collide(movement)

func set_identifier(newId):
	if newId == null:
		$Label.hide()
	else:
		identifier = newId
		$Label.text = identifier
		$Label.show()


func remove_input(connector):
	if onlyInput == connector:
		onlyInput = null
	update_state()
	
func update_state():
	if onlyInput == null:
		state = false
		active = false
	else:
		state = onlyInput.state
		active = true
	if state:
		$Sprite.texture = onImage
	else:
		$Sprite.texture = offImage
		
	if truthTable != null:
		truthTable.update_current_row()
		
	
func _on_DragCollider_input_event(viewport, event, shape_idx):
	if onlyInput == null and uiConnector.origin == null:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				oldPosition = get_global_mouse_position()
				dragEnabled = event.pressed

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			dragEnabled = false

func _on_InputCollider_input_event(viewport, event, shape_idx):
	if onlyInput != null:
		return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if uiConnector.origin != null:
				var connector = uiConnector.handle_wire_end(self,
					$LeftInputPosition.global_position,
					$RightInputPosition.global_position)
				if connector != null:
					onlyInput = connector
					update_state()
