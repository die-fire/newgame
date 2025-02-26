extends Area2D

var type : PickupResource
var direction :Vector2
var speed :float = 750
var player_reference :CharacterBody2D:
	set(value):
		player_reference = value
		type.player_reference = value

var can_follow : bool =false

func _ready() -> void:
	$Sprite2D.texture =type.icon

func _physics_process(delta):
	if player_reference and can_follow:#当在范围内时，拾取器将朝玩家移动
		direction =(player_reference.position - position).normalized()
		position += direction *speed * delta

func follow(target:CharacterBody2D):
	can_follow = true
	player_reference = target

func _on_body_entered(_body: Node2D) -> void:
	type.activate()
	queue_free()
