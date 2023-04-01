@tool
extends Resource

class_name _item

@export var itemName : StringName
@export var itemTexture : AtlasTexture
@export var quanity : int
@export var hoverText : StringName
@export var hasGlow : bool
@export var shape : Shape2D
@export var hasCollision: bool
@export var collisionRatio: float

func addQuanity(q: int):
	quanity += q
	
func getTexture() -> AtlasTexture:	
	return itemTexture
func getQuanity() -> int:	
	return quanity

