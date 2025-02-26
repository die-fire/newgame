extends Node2D

@onready var rangedAni = $AnimatedSprite2D
@onready var shoot_pos = $shoot_pos
@onready var ASP = $ASP
@onready var bullet = preload("res://weapon/bullet/bullet.tscn")

var shootTime = 0.5:
	set(value):
		shootTime = value
		ASP.wait_time = value
var speed = 2000
var hurt = 1
var attack_enemies = []
var knockback = 5

const levelColor = {
	level_1 = "#b0c3d9",
	level_2 = "#4b69ff",
	level_3 = "#d32ce6",
	level_4 = "#8847ff",
	level_5 = "#eb4b4b"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rangedAni.material.set_shader_parameter("color",Color(levelColor['level_1']))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if attack_enemies.size()!=0:
		if ASP.is_stopped():
			ASP.start()
			ASP.wait_time = shootTime
			_on_asp_timeout()
		self.look_at(attack_enemies[0].position)
		
	else:
		rotation_degrees = 0
		ASP.stop()
	pass


func _on_asp_timeout() -> void:
	if attack_enemies.size()!=0:
		var new_bullet = bullet.instantiate()
		new_bullet.speed = speed
		new_bullet.hurt = hurt
		new_bullet.knockback = knockback
		new_bullet.position = shoot_pos.global_position
		new_bullet.dir = (attack_enemies[0].global_position - new_bullet.position).normalized()
		get_tree().root.add_child(new_bullet)
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and !attack_enemies.has(body):
		attack_enemies.append(body)
	sort_enemies()
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and attack_enemies.has(body):
		attack_enemies.remove_at(attack_enemies.find(body))
	sort_enemies()
	pass # Replace with function body.

func sort_enemies():
	if attack_enemies.size()!=0:
		attack_enemies.sort_custom(
			func(x,y):
				return x.global_position.distance_to(self.global_position) < y.global_position.distance_to(self.global_position)
		)
	pass
