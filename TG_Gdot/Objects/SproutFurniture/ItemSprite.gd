@tool

extends TextureRect

@export var item : _item : set = _setItem

@onready var label = $rtl_quantity

func _ready():
	#label.text = str(item.getQuanity())
	pass

func addQuanity(q : int):
	item.addQuanity(q)

func _setItem(newItem : _item):
	item = newItem
	self.texture = item.getTexture()
