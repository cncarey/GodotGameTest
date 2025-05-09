extends Node

var current_scene = null
var sceneMain : StringName = "res://Scene/main.tscn"
var sceneInside : StringName = "res://Scene/homeInside.tscn"

@export var maxShrubs : float = 25
@export var maxCows : float = 25

@onready var lastLocation : Dictionary = {};
@onready var shrubs : Dictionary = {};
@onready var cows : Dictionary = {};

@onready var coinCount: int = 0

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)

func addShrub(newShrub):
	var maxId = 0
	if shrubs.is_empty() == false: 
		maxId = shrubs.keys().max()
	
	while shrubs.has(maxId):
		maxId +=1
	
	newShrub.id = maxId
	shrubs[maxId] = { 
		"location" : newShrub.position,
		"HealthRemaining" : newShrub.HealthRemaining
	}

func updateShrub(existingShrub):
	shrubs[existingShrub.id] = { 
		"location" : existingShrub.position,
		"HealthRemaining" : existingShrub.HealthRemaining
	}

func removeShrub(existingShrub):
	shrubs.erase(existingShrub.id)

func setLastLocation(path: StringName, location):
	lastLocation[path] = location;
	
func getLastLocation(path: StringName):
	if lastLocation.has(path) :
		lastLocation.get(path)
	else:
		lastLocation[path] = null	

func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)	
