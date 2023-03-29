extends Area2D

var entered : bool = false

func _on_body_entered(body: PhysicsBody2D):
	var player := body as CharacterBody2D
	
	if not player :
		print (body)
	else :
		Global.setLastLocation(Global.sceneMain, player.position)
	
	entered = true
	
	


func _on_body_exited(body):
	entered = false
	
func _process(delta):
	if entered == true:
		get_tree().change_scene_to_file(Global.sceneInside)
