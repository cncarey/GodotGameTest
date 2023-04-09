@tool

extends TextureRect

signal pickUpItem(item, body, label, istouching)

@export var HealthRemaining: float 

var id : int 
@export var item : _item : set = _setItem

@onready var label = $rtl_quantity
@onready var rb2 = $RigidBody2D
@onready var colShape = $RigidBody2D/CollisionShape2D
@onready var areaShare = $RigidBody2D/Area2D/CollisionShape2D

func _ready():
	#check if we have a collision and disable it if we don't need it
	
	var v2 = item.getTexture().region.size
	var s = RectangleShape2D.new()
	s.size = v2 * .5 #change to ratio
	colShape.shape = s
	colShape.global_position = self.global_position
	
	var c = CircleShape2D.new()
	if(v2.x >= v2.y):
		c.radius = v2.x * 2
	else: 
		c.radius = v2.y * 2
		
	areaShare.shape = c
	
	if "StartingHealth" in item:
		HealthRemaining = item.StartingHealth
		label.text = str(HealthRemaining)
	label.visible = true;
	pass

func addQuanity(q : int):
	item.addQuanity(q)

func _setItem(newItem : _item):
	item = newItem
	#if "remainingHealth" in item:
	#	self.HealthRemaining = item.remainingHealth
	#	label.text = str(HealthRemaining)
	self.texture = item.getTexture()

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	
	var player := body as CharacterBody2D
	
	if player :
		label.visible = true;
		pickUpItem.emit(self, body, label, true)
	else :
		pass # Replace with function body.

func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	label.text = str(HealthRemaining)
	pickUpItem.emit(self, body, label, false)
	pass # Replace with function body.
