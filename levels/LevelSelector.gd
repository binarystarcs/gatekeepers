extends HBoxContainer

const BUTTON_COUNT = 9
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for levelNumber in range(1, BUTTON_COUNT + 1):
		var button = Button.new()
		button.text = str(levelNumber)
		add_child(button)
		button.connect("pressed", self, "_on_button_pressed", [levelNumber])

func _on_button_pressed(levelNumber):
	print("Button pressed", levelNumber)
	var levelPath = "res://levels/Level" + str(levelNumber) + ".tscn"
	get_tree().change_scene(levelPath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
