extends AnimatableBody2D

var isOpen = false

@onready var touchArea = $Area2D
@onready var animationTree = $AnimationTree
@onready var animationMode = animationTree.get("parameters/playback")

func _ready():
	pass

func _on_area_2d_body_entered(body):
	var player := body as CharacterBody2D
	
	if player && body != self:
		
		animationMode.travel("OpenDown")
		if isOpen == false:
			#drop the loot the first time we touch
			pass # Replace with function body.
		
		isOpen = true
