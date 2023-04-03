extends CharacterBody2D

enum CowState {Idle, Walk, Lick, Follow, FindFood}

var charName : StringName = "Cow"

var isAnimal : bool = true
var RemainingHunger: float = 20 : set = _setRemainingtHunger
var MaxHunger: float = 30
var isTouching : bool = false
var isFollowing : bool = false

var curTouching = {};

@export var eatSpeed: float = 5
@export var moveSpeed: float = 20;
@export var idleTime: float = 5;
@export var walkTime: float = 2;
@export var hungerTime: float = 10;



#figure out how to make this global so i don't need it everywhere
var walk : StringName = "Walk"
var idle : StringName = "Idle"

@onready var animationTree = $AnimationTree
@onready var animationMode = animationTree.get("parameters/playback")
@onready var sprite = $BrownCow
#@onready var emote = $Emote
@onready var timer = $MoveTimer
@onready var hungerTimer = $HungerTimer
@onready var hungerLabel = $HungerLabel
@onready var touchArea = $TouchArea
@onready var touchIndicator = $touchIndicator

var moveDirection : Vector2 = Vector2.ZERO
var currentState : CowState = CowState.Idle

func _ready():
	selectNewDirection()
	pickNewState()
	_on_hunger_timer_timeout()
	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

func _setRemainingtHunger(x : float):
	RemainingHunger = x
	hungerLabel.text = str(x)

func _physics_process(delta):
	if currentState == CowState.Walk:
		velocity = moveDirection * moveSpeed
		move_and_slide()
	if currentState == CowState.Follow:
		follow(delta)
		pass # add functionaity to follow the player
		

	
func selectNewDirection():
	moveDirection = Vector2(randi_range(-1, 1), randi_range(-1, 1))
	
	if  moveDirection.x < 0 :
		sprite.flip_h = true
	elif moveDirection.x > 0:
		sprite.flip_h = false
	
func pickNewState():
	match currentState:
		CowState.Idle:
			animationMode.travel(walk)
			currentState = CowState.Walk
			timer.start(walkTime)
			selectNewDirection()
		CowState.Walk:   
			animationMode.travel(idle)
			currentState = CowState.Idle
			timer.start(idleTime)
		CowState.Follow:
			timer.stop()
			if(velocity != Vector2.ZERO):
				animationMode.travel(walk)
			else:
				animationMode.travel(idle)	
			pass
	#TODO when we finish path finding add in
	#	  animations for eating the grass
	#TODO if we are near water do a the licking animation
			
func _on_timer_timeout():
	pickNewState()

#create animal needs section
#add functionaity to track bond, hunger and thurst
#add funcionality to depleat bond, hunger and thurst over time
#if a cow is hungry and near food it will eat on its own
#add functionality to follow the player when prompted
#add path finding functionality

func pathFinding():
	pass #add functionaity so that a cow will go to 

func _on_hunger_timer_timeout():	
	if RemainingHunger > 0:
		#reduce the hunger
		RemainingHunger -= 1
		pass
	
	if RemainingHunger > 15:
		pass #hide the hunger warning
	elif RemainingHunger <= 15 && RemainingHunger >= 5:
		pass # show the hunger warning	
	elif RemainingHunger < 5:
		pass # show death warning	
	else:
		pass # TODO remove the cow from the scene
	# and play death cut scene

	hungerTimer.start(hungerTime)
	
func _on_touch_area_body_entered(body):
	if(body != self && "charName" in body):
		isTouching = true
		curTouching[body.charName]= body
		touchIndicator.visible = true
		#show emote
	pass # Replace with function body.


func _on_touch_area_body_exited(body):
	if("charName" in body) && curTouching.has(body.charName):
		curTouching.erase(body.charName)
		#If ther is nothig else touching hide emote
		if curTouching.is_empty():
			touchIndicator.visible = false
			isTouching = false
	pass # Replace with function body.

var FarFollowSpeed = 55
var CloseFollowSpeed = 25
var followDistance = 25
var followStopDistance = 70
var whatToFollow = null

func startFollow(newWhatToFollow):
	whatToFollow = newWhatToFollow
	currentState = CowState.Follow
	
func stopFollow():
	whatToFollow = null
	currentState = CowState.Idle
	pickNewState()

func follow(delta):
	if(whatToFollow && self.position.distance_to(whatToFollow.position) > followDistance):
		touchIndicator.visible = false
		
		var distance = Vector2(whatToFollow.position - self.position )
		pickNewState()
		
		var curFollowSpeed = FarFollowSpeed if (self.position.distance_to(whatToFollow.position) > followDistance * 2) else CloseFollowSpeed 
		var desiredVelocity = curFollowSpeed * distance.normalized()
		if  distance.x < 0 :
			sprite.flip_h = true
		elif distance.x > 0:
			sprite.flip_h = false
		
		var steering = (desiredVelocity - velocity) * delta *2.5
		velocity += steering
		move_and_slide()
