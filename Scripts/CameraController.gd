extends Node2D

# node references
var oldnode
var newnode

# bool if camera is switching
var transition = false

var timer

func _ready():
	#setup timer
	timer = Timer.new()
	timer.connect("timeout", self, "end_pause") 
	add_child(timer)
	
	#camera defaults to area named "StartCamera"
	oldnode = get_node("StartCamera")
	newnode = get_node("StartCamera")
	newnode.cam().current = true
	for node in get_tree().get_nodes_in_group("CameraAreas"):
		node.connect("Overlap", self, "NewCam")


func _process(delta):
	if transition:
		#interpolate if transitioning
		oldnode.cam().global_position = newnode.defaultCamPosition.linear_interpolate(oldnode.defaultCamPosition, timer.time_left)
	


#callback from area nodes
func NewCam(body):
	if body != newnode:
		get_node("Player").time_frozen = true
		newnode = body
		transition = true
		timer.start(1)
		
		#get_node("Player").paused = true
	
func end_pause():
	get_node("Player").time_frozen = false
	oldnode = newnode
	oldnode.cam().global_position = oldnode.defaultCamPosition 
	newnode.cam().global_position = newnode.defaultCamPosition 
	newnode.cam().current = true
	transition = false
	
