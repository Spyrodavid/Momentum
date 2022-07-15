extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_down"):
		position.y += 10
	if Input.is_action_pressed("ui_left"):
		position.x -= 10
	if Input.is_action_pressed("ui_up"):
		position.y -= 10
	if Input.is_action_pressed("ui_right"):
		position.x += 10
