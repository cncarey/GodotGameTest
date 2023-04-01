extends CharacterBody2D

enum CowState {Idle, Walk, Lick}

var isAnimal : bool = true
var RemainingHunger: float = 20 : set = _setRemainingtHunger
var MaxHunger: float = 30


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
@onready var timer = $MoveTimer
@onready var hungerTimer = $HungerTimer
@onready var hungerLabel = $HungerLabel

var moveDirection : Vector2 = Vector2.ZERO
var currentState : CowState = CowState.Idle

func _ready():
	selectNewDirection()
	pickNewState()
	_on_hunger_timer_timeout()

func _setRemainingtHunger(x : float):
	RemainingHunger = x
	hungerLabel.text = str(x)

func _physics_process(delta):
	if currentState == CowState.Walk:
		velocity = moveDirection * moveSpeed
		move_and_slide()
	
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
	
	
