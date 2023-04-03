extends CharacterBody2D

@export var moveSpeed : float  = 100
@export var statingDirection : Vector2 = Vector2(0, 0)
# parameters/Idle/blend_position
var catIdlePB : StringName = "parameters/Idle/blend_position"
var catWalkPB : StringName = "parameters/Walk/blend_position"
var walk : StringName = "Walk"
var idle : StringName = "Idle"

var charName : StringName = "PlayerCat"

var followers = []
signal signalFollowers(player, curTouching, isStarting)

@onready var animationTree = $AnimationTree
@onready var animationMode = animationTree.get("parameters/playback")

#add value for following
#add arrar or dictionary to hold what is following us
#add functiont to turn it on and off


func _ready():
	animationTree.set(catIdlePB, statingDirection)
	
func _physics_process(_delta):
	
	#Get input direction
	var inputDirection = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)	
	
	updateAnimationParams(inputDirection)
	
	#Update velocity
	velocity = inputDirection.normalized() * moveSpeed
	
	#move and slide function uses velocity body to move character on map
	move_and_slide()
	setState()
	startFollow()
	stopFollow()
	
func updateAnimationParams(movingInput : Vector2):	
	if(movingInput != Vector2.ZERO):
		animationTree.set(catIdlePB, movingInput)
		animationTree.set(catWalkPB, movingInput)
		
func setState():
	if(velocity != Vector2.ZERO):
		animationMode.travel(walk)
	else:
		animationMode.travel(idle)	
		
func _on_Button_pressed():
	Global.goto_scene(Global.sceneInside)		

func startFollow():
	if isTouching && Input.is_action_just_pressed("select"):
		print("selected")
		print(curTouching)
		for key in curTouching:
			curFollowing[key] = curTouching[key]
		
		signalFollowers.emit(self, curTouching, true)
		pass #TODO check if there is something in the touching block

#TODO figure out how to allow selecting what to stop following
func stopFollow():
	if Input.is_action_just_pressed("cancel"):
		if curFollowing.is_empty() == false:
			signalFollowers.emit(self, curFollowing, false)		
			curFollowing = {}

var isTouching : bool = false
var curTouching : Dictionary = {}
var curFollowing : Dictionary = {}
func _on_touch_area_body_entered(body):
	if(body != self && "charName" in body ): 
		isTouching = true
		curTouching[body.charName]= body
	pass # Replace with function body.


func _on_touch_area_body_exited(body):
	if("charName" in body) && curTouching.has(body.charName):
		curTouching.erase(body.charName)
		#If ther is nothig else touching hide emote
		isTouching = false
	
	pass # Replace with function body.
