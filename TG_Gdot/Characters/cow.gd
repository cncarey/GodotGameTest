extends CharacterBody2D

enum CowState {Idle, Walk, Lick}

@export var moveSpeed: float = 20;
@export var idleTime: float = 5;
@export var walkTime: float = 2;

#figure out how to make this global so i don't need it everywhere
var walk : StringName = "Walk"
var idle : StringName = "Idle"

@onready var animationTree = $AnimationTree
@onready var animationMode = animationTree.get("parameters/playback")
@onready var sprite = $BrownCow
@onready var timer = $Timer

var moveDirection : Vector2 = Vector2.ZERO
var currentState : CowState = CowState.Idle

func _ready():
	selectNewDirection()
	pickNewState()

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
			


func _on_timer_timeout():
	pickNewState()
