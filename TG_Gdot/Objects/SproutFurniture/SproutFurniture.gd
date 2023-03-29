extends Node2D

@export var FurniturType : StringName = "Bed"
@export var color : StringName = "Green"
@export var direction : StringName = "Up"



@onready var basicFurn = $BasicFurniture
@onready var colission = $StaticBody2D/CollisionShape2D

func _ready():
	getFuniture()
	
func getFuniture():
	var f = FileAccess.open("res://Objects/SproutFurniture/SproutFurniture.json", FileAccess.READ)
	var fContent = f.get_as_text()
	var furnitureJson = JSON.parse_string(fContent)
	
	print(furnitureJson[FurniturType])
	var fOptions = furnitureJson[FurniturType] as Array
	
	if fOptions.size()  <= 0:
		#Blue lamp hard coding for now
		basicFurn.region_rect = Rect2 (67, 16, 11, 10)
	elif  fOptions.size() == 1:
		basicFurn.region_rect = Rect2(fOptions[0].x, fOptions[0].y, fOptions[0].w, fOptions[0].h)
	else:
		basicFurn.region_rect = Rect2(fOptions[0].x, fOptions[0].y, fOptions[0].w, fOptions[0].h)
	#for now just get the first one while i proof of concept this and make sure im not going about this wrong
	#filter to find if any of the items i the list match the other set criteria
	#[].filter(functionName)
	#func functionName
	# check if there is a color field
	# check if there is a direction field
