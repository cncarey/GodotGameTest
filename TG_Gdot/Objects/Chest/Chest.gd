extends AnimatableBody2D

var isOpen = false

@onready var touchArea = $Area2D
@onready var animationTree = $AnimationTree
@onready var animationMode = animationTree.get("parameters/playback")

var itemScene = preload("res://Objects/SproutFurniture/ItemSprite.tscn")
var coinTexture = preload("res://Objects/SproutFurniture/coin.tres")

signal lootDropped(loot)

func _ready():
	pass

func _on_area_2d_body_entered(body):
	var player := body as CharacterBody2D
	
	if player && body != self:
		
		animationMode.travel("OpenDown")
		if isOpen == false:
			var lootCount = randi_range(1, 3)
			var lootPosition = Vector2(player.position.x + 20, player.position.y + 20)
			
			var spawnedLoot = dropLoot(lootPosition)
			#spawnedLoot.pickUpItem.connect(_on_item_sprite_pick_up_item)
			lootDropped.emit(spawnedLoot)
			#drop the loot the first time we touch
			pass # Replace with function body.
		
		isOpen = true
		
func dropLoot(loc: Vector2):
	var spawnedLoot = itemScene.instantiate();
	spawnedLoot.item = coinTexture
	spawnedLoot.position = loc
	spawnedLoot.scale = Vector2(.5, .5)
	return spawnedLoot
