extends Area2D


signal Overlap(body)


func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(overlaps_body(get_node("../KinematicBody2D"))):
		print(get_node("..").name)
		
		$Camera2D.current = true
		emit_signal("Overlap", self)
		
