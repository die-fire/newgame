extends CharacterBody2D

@export var player_reference : CharacterBody2D
var damage_popup_node = preload("res://UI/damage.tscn")
var drop = preload("res://pickup/pickup.tscn")
var hurtAni = preload("res://emeny/hurt_ani.tscn")
var dir : Vector2
var speed = 300
var target = null
var knockback : Vector2 #击退使敌人更流畅跟随
var damage : float #攻击力
var health = 10:#生命值
	set(value):
		health = value
		if health <= 0:
			drop_item()
			queue_free()

var type : Enemy: #敌人类型
	set(value):
		type = value
		#$AnimatedSprite2D.texture = value.texture
		damage = value.damage
		health = value.health

var elite : bool = false: #加载精英怪
	set(value):
		elite = value
		if value:
			scale = Vector2(1.5,1.5)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_tree().get_nodes_in_group("player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target or target.size()!=0:
		player_reference = target[0]
		knockback_update(delta)
		#dir = (target[0].global_position - self.global_position).normalized()
		#velocity = dir * speed
		#move_and_slide()
	pass

func take_damage(amount):
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D,"modulate",Color(3,0.25,0.25),0.2)
	tween.chain().tween_property($AnimatedSprite2D,"modulate", Color(1,1,1),0.2)
	tween.bind_node(self)
	damage_popup(amount)
	health -= amount

func damage_popup(amount):
	var popup= damage_popup_node.instantiate()
	popup.text = str(amount)
	popup.position=position+Vector2(-100,-50)
	get_tree().current_scene.add_child(popup)

func knockback_update(_delta):
	if self.get_node("knockback").is_stopped():
		self.get_node("knockback").start()
		#knockback = knockback.move_toward(Vector2.ZERO,1)
		#velocity += knockback
		#var collider = move_and_collide(velocity * delta)
		#prints(velocity)
		#if collider:
			#collider.get_collider().knockback =(collider.get_collider().global_position-global_position).normalized()
	velocity = (player_reference.position - position + knockback).normalized() * speed
	move_and_slide()


func drop_item():
	if type.drops.size()== 0:
		return
	var item = type.drops.pick_random()
	var item_to_drop = drop.instantiate()
	var dead = hurtAni.instantiate()
	dead.position = position
	item_to_drop.type = item
	item_to_drop.position = position
	item_to_drop.player_reference = player_reference
	get_tree().current_scene.call_deferred("add_child",item_to_drop)
	get_tree().current_scene.call_deferred("add_child",dead)


func _on_knockback_timeout() -> void:
	knockback = Vector2.ZERO
	#knockback = lerp(knockback, Vector2.ZERO, 0.5)
	pass # Replace with function body.
