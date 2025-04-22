class_name HitboxComponent
extends Area2D

signal HitHurtbox(hurtboxComponent)

@export var oneShot : bool
@export var ApplyKnockback : bool
@export var shouldFree : bool

func _ready():
	pass
		

func _physics_process(_delta):
	if (shouldFree):
		queue_free()
	shouldFree = oneShot;

func _on_area_entered(area: Area2D):
	#	if otherArea.owner is BulletComponent:
#		emit_signal("hit_with_bullet", otherArea.owner)
#	else:
#		emit_signal("hit", otherArea)
	HitHurtbox.emit(area)
	pass # Replace with function body.
