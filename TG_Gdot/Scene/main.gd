extends Node2D

@onready var sprite = $PlayerCat

func _ready():
	if Global.lastLocation.has(Global.sceneMain):
		sprite.position = Global.lastLocation.get(Global.sceneMain)

