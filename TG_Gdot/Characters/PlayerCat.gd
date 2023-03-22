extends CharacterBody2D

@export var moveSpeed : float  = 100

func _physics_process(_delta):
	#Get input direction
	var inputDirection = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	print(inputDirection)
	
	#Update velocity
	velocity = inputDirection * moveSpeed
	
	#move and slide function uses velocity body to move character on map
	move_and_slide()
