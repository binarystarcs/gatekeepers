extends Node2D

var uiConnector
onready var truthTableScene = preload("res://components/TruthTable.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	uiConnector = get_node("/root/ConnectorUi")
	uiConnector.current_level = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ToggleTruth_pressed():
	for output in get_tree().get_nodes_in_group("outputs"):
		if not output.active:
			return
	get_tree().call_group("truthtables", "self_destruct")
	var table = truthTableScene.instance()
	add_child(table, true)
	table.setup()

