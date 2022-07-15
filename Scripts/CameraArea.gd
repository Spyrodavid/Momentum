extends Area2D


signal Overlap(body)

var defaultCamPosition


func _ready():
	defaultCamPosition = $Camera2D.global_position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(overlaps_body(get_node("../Player"))):
		
		emit_signal("Overlap", self)

func cam():
	return $Camera2D
