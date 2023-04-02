extends Sprite2D

@onready var animate = $AnimationPlayer

func _ready():
	animate.play("pointer")
	pass
