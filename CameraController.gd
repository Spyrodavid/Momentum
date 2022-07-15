extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var oldcam
var newcam

# Called when the node enters the scene tree for the first time.
func _ready():
	oldcam = get_node("CameraArea/Camera2D")
	newcam = get_node("CameraArea/Camera2D")
	for node in get_tree().get_nodes_in_group("CameraAreas"):
		node.connect("Overlap", self, "NewCam")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if oldcam != newcam:
		oldcam.position.linear_interpolate(newcam.position, .5)
	


func NewCam(body):
	if oldcam == body.get_node("Camera2D"):
		return
	newcam = body.get_node("Camera2D")
	
	
