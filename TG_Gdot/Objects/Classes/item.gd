@tool
extends Resource

class_name _item

@export var itemName : StringName
@export var itemTexture : AtlasTexture
@export var quanity : int
@export var hoverText : StringName
@export var hasGlow : bool

func addQuanity(q: int):
	quanity += q
	
func getTexture() -> AtlasTexture:	
	return itemTexture
func getQuanity() -> int:	
	return quanity

