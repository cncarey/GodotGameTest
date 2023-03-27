extends CharacterBody2D

@export var moveSpeed : float  = 100
@export var statingDirection : Vector2 = Vector2(0, 0)
# parameters/Idle/blend_position
var catIdlePB : StringName = "parameters/Idle/blend_position"
var catWalkPB : StringName = "parameters/Walk/blend_position"
var walk : StringName = "Walk"
var idle : StringName = "Idle"

@onready var animationTree = $AnimationTree
@onready var animationMode = animationTree.get("parameters/playback")


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
