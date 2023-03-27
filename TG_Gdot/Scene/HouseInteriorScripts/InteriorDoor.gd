extends Area2D

var entered : bool = false

func _process(delta):
	if entered == true:
		get_tree().change_scene_to_file(Global.sceneMain)

func _on_body_entered(body: PhysicsBody2D):
	entered = true

func _on_body_exited(body: PhysicsBody2D):
	entered = false
