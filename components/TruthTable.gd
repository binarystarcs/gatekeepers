extends Node2D


const CONNECTOR_LETTERS = ["F", "G", "H", "J", "K", "L", "M", "N", "P", "U", "W", "Z"]

onready var inputsTable = $TableContainer/InputsContainer/InputsTable
onready var connectorsTable = $TableContainer/ConnectorsContainer/ConnectorsTable
onready var outputsTable = $TableContainer/OutputsContainer/OutputsTable

onready var tableCellScene = preload("res://components/TableCell.tscn")
onready var titleCellScene = preload("res://components/TitleCell.tscn")


var inputs = []
var outputs = []
var gates = []
var rowCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("truthtables")

func sort_by_identifier(a, b):
	return (a.identifier < b.identifier)
	
func sort_by_x_coordinate(a, b):
	return (a.global_position.x < b.global_position.x)

func get_current_row():
	var currentRow = 0
	for input in inputs:
		currentRow *= 2
		if input.state:
			currentRow += 1
	return currentRow
	
func highlight_row_in_table(table, row):
	var labels = table.get_children()
	for label in labels:
		if label.row == row:
			label.highlight()
		elif label.row >= 0:
			label.unhighlight()
	return null
	
func highlight_row(row):
	highlight_row_in_table(inputsTable, row)
	highlight_row_in_table(connectorsTable, row)
	highlight_row_in_table(outputsTable, row)
	

func get_label_from_table(table, row, column):
	var labels = table.get_children()
	for label in labels:
		if label.row == row and label.column == column:
			return label
	return null

func update_current_row():
	var row = get_current_row()

	var column = 0
	for input in inputs:
		var label = get_label_from_table(inputsTable, row, column)
		label.set_state(input.state)
		column += 1

	column = 0
	for gate in gates:
		var label = get_label_from_table(connectorsTable, row, column)
		label.set_state(gate.state)
		column += 1
		
	column = 0
	for output in outputs:
		var label = get_label_from_table(outputsTable, row, column)
		label.set_state(output.state)
		column += 1
		
	highlight_row(row)
		
		
func self_destruct():
	for output in outputs:
		output.truthTable = null
	for gate in gates:
		gate.set_identifier(null)
	queue_free()

func setup():
	var raw_inputs = get_tree().get_nodes_in_group("inputs")
	inputs = []
	for input in raw_inputs:
		if input.outputs.size() > 0:
			inputs.append(input)
	inputs.sort_custom(self, "sort_by_identifier")
	rowCount = 1 << inputs.size()
	inputsTable.columns = inputs.size()
	
	for input in inputs:
		var titleLabel = titleCellScene.instance()
		titleLabel.text = input.identifier
		inputsTable.add_child(titleLabel)

	for row in range(rowCount):
		var input_id = 0
		for input in inputs:
			var ordinaryLabel = tableCellScene.instance()
			ordinaryLabel.clear()
			ordinaryLabel.row = row
			ordinaryLabel.column = input_id
			inputsTable.add_child(ordinaryLabel)
			input_id += 1
	
	
	
	var connectors = get_tree().get_nodes_in_group("gates")
	gates = []
	for connector in connectors:
		if connector.active:
			gates.append(connector)
	gates.sort_custom(self, "sort_by_x_coordinate")
	connectorsTable.columns = gates.size()
	var column = 0
	for connector in gates:
		connector.set_identifier(CONNECTOR_LETTERS[column]) 
		column += 1
		
	for gate in gates:
		var titleLabel = titleCellScene.instance()
		titleLabel.text = gate.identifier
		connectorsTable.add_child(titleLabel)

	for row in range(rowCount):
		var input_id = 0
		for gate in gates:
			var ordinaryLabel = tableCellScene.instance()
			ordinaryLabel.clear()
			ordinaryLabel.row = row
			ordinaryLabel.column = input_id
			connectorsTable.add_child(ordinaryLabel)
			input_id += 1
	
	
	
	outputs = get_tree().get_nodes_in_group("outputs")
	outputs.sort_custom(self, "sort_by_identifier")
	outputsTable.columns = outputs.size()
	for output in outputs:
		var titleLabel = titleCellScene.instance()
		titleLabel.text = output.identifier
		output.set_identifier(output.identifier)
		outputsTable.add_child(titleLabel)
		output.truthTable = self

	for row in range(rowCount):
		var input_id = 0
		for output in outputs:
			var ordinaryLabel = tableCellScene.instance()
			ordinaryLabel.clear()
			ordinaryLabel.row = row
			ordinaryLabel.column = input_id
			outputsTable.add_child(ordinaryLabel)
			input_id += 1
			
	update_current_row()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
