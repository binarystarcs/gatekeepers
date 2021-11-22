extends Line2D

const DESTRUCTION_CLICK_TOLERANCE = 12

var origin = null
var destination = null
var state: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_state(new_state):
	# this should be coloured in...
	state = new_state
	if not state:
		default_color = Color.darkgray
	else:
		default_color = Color.green
	if destination != null:
		destination.update_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func self_destruct():
	origin.remove_output(self)
	destination.remove_input(self)
	get_tree().call_group("truthtables", "self_destruct")
	queue_free()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			var mouseClick = get_global_mouse_position()
			var closest_point = Geometry.get_closest_point_to_segment_2d(mouseClick, global_position + points[1], global_position + points[2])
			if closest_point.distance_to(mouseClick) < DESTRUCTION_CLICK_TOLERANCE:
				self_destruct()
