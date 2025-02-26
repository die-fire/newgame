extends Label

func _ready() -> void:
	pop()

func pop():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"scale",Vector2(6,6),0.1)
	tween.chain().tween_property(self,"scale",Vector2(1,1),0.5)
	await tween.finished
	queue_free()
