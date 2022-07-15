extends KinematicBody2D

var time_frozen = false
var oldSpeed = Vector2.ZERO

#movement stats
var maxSpeed = 320
#air accel is higher than grounded to allow for greater air control
var accelDelta = 0.04
var decelDelta = 0.2
var airAccelDelta = 0.1
var airDecelDelta = 0.12
var jumpForce = 220

var curAccel = accelDelta
var curDecel = decelDelta

var curGrav
var jumpReq

#snap vector variables
var snapVec = Vector2(0, 6)
var curSnap = snapVec

#player input + the motion vector
var input = Vector2.ZERO
var motion = Vector2.ZERO

#constants (gravity, strong gravity, terminal velocity)
const GRAV = 9.8
const STRGRAV = GRAV * 1.7
const TERMINAL = 500

func _ready():
	curGrav = GRAV

func _process(delta):
	#take player input in a vector 2. both axes are on a scale of -1 to 1.
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	#allow the player to request a jump in 60fps since physics tick is less than 60fps
	if is_on_floor() && Input.is_action_just_pressed("ui_jump"):
		jumpReq = true
	
func _physics_process(delta):
	if time_frozen:
		return
		
	DoMotion()
	
	if jumpReq:
		Jump()
	
	var speed = move_and_slide_with_snap(motion, curSnap, Vector2.UP, true)
	ApplyGravity()
	
	
	print(speed, oldSpeed, is_on_wall())
	if abs(speed.x - oldSpeed.x) > 100 && is_on_wall():
		
		Jump()
	
	oldSpeed = speed
	
	
	
	#clamp the x and y motion to terminal velocity const
	motion.x = clamp(motion.x, -TERMINAL, TERMINAL)
	motion.y = clamp(motion.y, -TERMINAL, TERMINAL)
	
	
	
	
		
func Jump():
	curSnap = Vector2.ZERO
	jumpReq = false
	motion.y = -jumpForce
	#print("yumped")
	
func DoMotion():
	#if the player is pressing an x direction, lerp x motion to max speed
	if input.x > 0:
		motion.x = lerp(motion.x, maxSpeed, curAccel)
	elif input.x < 0:
		motion.x = lerp(motion.x, -maxSpeed, curAccel)
		
	#if the player is not pressing an x direction, lerp x motion to 0
	if input.x == 0:
		motion.x = lerp(motion.x, 0, curDecel) 
	
	#if the player's x motion is low enough, set it to 0 (lerp bug workaround)
	if abs(motion.x) < 1 && input.x == 0:
		motion.x = 0
	
	#set proper accel/decel deltas depending on if the player is grounded or aerial
	if is_on_floor():
		curAccel = accelDelta
		curDecel = decelDelta
	else:
		curAccel = airAccelDelta
		curDecel = airDecelDelta
		curSnap = snapVec
	
func ApplyGravity():
	#if player is grounded
	if !is_on_floor():
		motion.y += curGrav
		
		#variable jump code
		#if the jump button is held
		if Input.is_action_pressed("ui_jump"):
			#gravity = normal gravity if player is travelling upwards
			if motion.y < 0:
				curGrav = GRAV
			#gravity = strong gravity if player is travelling downwards
			elif motion.y > 0:
				curGrav = STRGRAV
		#if the jump button is not held
		else:
			#gravity = strong gravity
			curGrav = STRGRAV
		
		#if jump button is released and player is travelling up
		if Input.is_action_just_released("ui_jump") && motion.y < 0:
			#cut player's vertical momentum to 1/3 of what it once was
			#gives greater control over jump height
			motion.y /= 3
			
	#if player is not grounded
	else:
		#set y motion to 1 (slightly down) to work around is_on_floor bug
		motion.y = 1
