extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var column = 0
var row = 0


func clear():
	text = ""
	
func highlight():
	$Highlight.show()
	
func unhighlight():
	$Highlight.hide()
	
func set_state(newState):
	if newState:
		text = " 1 "
		set("custom_colors/font_color", Color.green)
	else:
		text = " 0 "
		set("custom_colors/font_color", Color.red)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
