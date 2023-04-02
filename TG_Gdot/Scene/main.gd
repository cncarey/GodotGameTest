extends Node2D

@onready var sprite = $PlayerCat
@onready var shrubsTimer = $shrubsTimer
@onready var starterShrub1 = $ItemSprite
@onready var starterShrub2 = $ItemSprite2

var shrubTime = 8;
var shrub = preload("res://Objects/SproutFurniture/ItemSprite.tscn")
var shrubTexture = preload("res://Objects/SproutFurniture/Grass.tres")

func _ready():
	if Global.lastLocation.has(Global.sceneMain):
		sprite.position = Global.lastLocation.get(Global.sceneMain)
	if Global.shrubs.is_empty() == false:
		for key in Global.shrubs:
			print(Global.shrubs[key])
			var s = newShrub(Global.shrubs[key].location)
			s.pickUpItem.connect(_on_item_sprite_pick_up_item)
			add_child(s)
		
		#these are just placeholders
		remove_child(starterShrub1)
		remove_child(starterShrub2)
	else:
		Global.addShrub(starterShrub1)
		Global.addShrub(starterShrub2)	
			
	setShrubTimer()


func _on_timer_timeout():
	if Global.shrubs.size() < Global.maxShrubs:
		var spawnedShrub = newShrub(Vector2(randi_range(-250, 250), randi_range(-250, 250)))
		spawnedShrub.pickUpItem.connect(_on_item_sprite_pick_up_item)
		add_child(spawnedShrub)
		Global.addShrub(spawnedShrub)
	setShrubTimer()
	#spawn more grass in a random spot
	pass # Replace with function body.

func newShrub(loc: Vector2):
	var spawnedShrub = shrub.instantiate();
	spawnedShrub.item = shrubTexture
	spawnedShrub.position = loc
	return spawnedShrub
	
func setShrubTimer():
	if Global.shrubs.size() < Global.maxShrubs:
		shrubsTimer.start(shrubTime)
	else:
		shrubsTimer.stop()


func _on_item_sprite_pick_up_item(item, body, label, isTouching):
	print("hit in the main")
	print(item)
	var player := body as CharacterBody2D
	print("in emit")
	
	if player :
		if "isAnimal" in body && "RemainingHunger" in body && "MaxHunger" in body && "HealthRemaining" in item:
			if isTouching == true && body.RemainingHunger < body.MaxHunger:
				var maxEating = body.MaxHunger - body.RemainingHunger
				var grassFed = 0
				
				if maxEating < player.eatSpeed:
					if item.HealthRemaining >= maxEating:
						grassFed = maxEating
					else:
						grassFed = item.HealthRemaining	
				else :
					grassFed = player.eatSpeed
					
				item.HealthRemaining -= grassFed
				player.RemainingHunger += grassFed	
				
				# let's not drag on having a bunch of only one food shrubs 
				# so if there's less then half a food just remove it	
				print("before")
				print(str(Global.shrubs.size()))
				
				if item.HealthRemaining < 2:
					Global.removeShrub(item)
					remove_child(item)
					if shrubsTimer.is_stopped:
						setShrubTimer()
				else:
					Global.updateShrub(item)
				
				print("after")
				print(str(Global.shrubs.size()))
				
				if item:
					label.text = str(item.HealthRemaining)
				
			pass
		else:
			pass #for now it's the player and we should add this to the inventory
	pass # Replace with function body.
