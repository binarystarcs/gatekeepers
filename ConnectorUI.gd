extends Node2D

# This handles UI for connecting nodes

var origin = null
var originLeftPos = Vector2(0, 0)
var originRightPos = Vector2(0, 0)
var current_level = null
var tempLine = null

onready var connectorScene = load("res://components/Connector.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func handle_wire_start(source, leftStart, rightStart):
	origin = source
	originLeftPos = leftStart
	originRightPos = rightStart
	# Get some temporary stuff
	
	tempLine = Line2D.new()
	tempLine.add_point(get_global_mouse_position())
	tempLine.add_point(get_global_mouse_position())
	current_level.add_child(tempLine)
	
func reset_state():
	if tempLine != null:
		tempLine.queue_free()
	tempLine = null
	origin = null
	originLeftPos = Vector2(0, 0)
	originRightPos = Vector2(0, 0)
	
func handle_wire_end(destination, leftEnd, rightEnd):
	if origin == null: return null
	if origin == destination: return null
	if originRightPos.x > leftEnd.x: return null

	var connector = connectorScene.instance()
	connector.add_point(originLeftPos)
	connector.add_point(originRightPos)
	connector.add_point(leftEnd)
	connector.add_point(rightEnd)
	connector.origin = origin
	connector.destination = destination
	connector.change_state(origin.state)
	origin.outputs.append(connector)
	current_level.add_child(connector)
	get_tree().call_group("truthtables", "self_destruct")
	reset_state()
	return connector
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			reset_state()

func _process(delta):
	if tempLine != null:
		tempLine.set_point_position(1, get_global_mouse_position())
