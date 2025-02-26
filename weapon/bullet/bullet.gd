extends Area2D

var dir = Vector2.ZERO
var speed = 2000
var hurt :float
var knockback :float

func _process(delta: float) -> void:
	position += dir * delta * speed

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(hurt)
		body.knockback += dir * knockback * 100 #击退
		queue_free()
	pass # Replace with function body.

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	pass # Replace with function body.

	
