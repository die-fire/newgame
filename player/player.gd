extends CharacterBody2D

@onready var playerAni = $playerAni
@onready var playerUI = $playerUI
@onready var godTime = $godTime
var damage_popup_node = preload("res://UI/damage.tscn")
var flip = false
var now_state = 1
var speed : float = 700
var hp_ui = null
var xp_ui = null
var level_ui =null
var god : float = 1:
	set(value):
		god = value
		godTime.wait_time = value
#血量
var health : float = 100:
	set(value):
		health = value
		hp_ui.value = value
		if health <= 0:
			fail()

#经验值
var XP:int = 0:
	set(value):
		XP = value
		xp_ui.value = value
var total_XP:int = 0
var level: int = 1:
	set(value):
		xp_ui.max_value=value*10
		level = value
		level_ui.text="Lv"+ str(value)
		#playerUI.Options.show_option()

func _ready() -> void:
	hp_ui = playerUI.get_node("HP")
	hp_ui.max_value = health
	hp_ui.value = health
	xp_ui = playerUI.get_node("XP")
	level_ui = playerUI.get_node("XP/LEVEL")
	choosePlayer("player1")
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	state(now_state)
	move_and_collide(velocity * delta)
	check_XP()

func choosePlayer(type):
	var player_path="res://player/assets/"
	var sprite_frames_custom = SpriteFrames.new()
	sprite_frames_custom.add_animation("defaults")
	sprite_frames_custom.set_animation_loop("defaults",true)
	var texture_size = Vector2(960,240)
	var sprite_size = Vector2(240,240)
	var full_texture : Texture = load(player_path+type+"/"+type+"-sheet.png")
	
	var num_columns = int(texture_size.x/sprite_size.x)
	var num_row = int(texture_size.y/sprite_size.y)
	
	for x in range(num_columns):
		for y in range(num_row):
			var frame = AtlasTexture.new()
			frame.atlas = full_texture
			frame.region = Rect2(Vector2(x,y)*sprite_size,sprite_size)
			sprite_frames_custom.add_frame("defaults",frame)
	
	playerAni.sprite_frames = sprite_frames_custom
	playerAni.play("defaults")
	pass

func state(s:int) -> void:
	if s==1:
		velocity = Input.get_vector("left","right","up","down") * speed
		if velocity==Vector2.ZERO:
			playerAni.pause()
		else:
			playerAni.play("defaults")
		if velocity.x < 0:
			flip = true
		else:
			flip = false
		playerAni.flip_h = flip

func fail():
	get_tree().change_scene_to_file("res://UI/fail.tscn")

#无敌时间
func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled",true)
	%Collision.set_deferred("disabled",false)
	
func gain_XP(amount):
	XP += amount
	total_XP += amount
	
func check_XP():
	if XP>= xp_ui.max_value:
		XP -= xp_ui.max_value
		level += 1

func _on_pickup_area_entered(area: Area2D) -> void:
	if area.has_method("follow"):
		area.follow(self)
	pass # Replace with function body.

func take_damage(amount):
	if godTime.is_stopped():
		godTime.start()
	var tween = get_tree().create_tween()
	tween.tween_property($playerAni,"modulate",Color(1,1,1,0),god/4)
	tween.chain().tween_property($playerAni,"modulate", Color(1,1,1,1),god/4)
	tween.chain().tween_property($playerAni,"modulate",Color(1,1,1,0),god/4)
	tween.chain().tween_property($playerAni,"modulate", Color(1,1,1,1),god/4)
	tween.bind_node(self)
	damage_popup(amount)
	health -= amount

func damage_popup(amount):
	var popup= damage_popup_node.instantiate()
	popup.text = str(amount)
	popup.modulate = Color.RED
	popup.position=position+Vector2(-100,-50)
	get_tree().current_scene.add_child(popup)

func _on_god_time_timeout() -> void:
	$hurtbox/CollisionShape2D.set_deferred("disabled",true)
	$hurtbox/CollisionShape2D.set_deferred("disabled",false)


func _on_hurtbox_body_entered(body: Node2D) -> void:
	take_damage(body.damage)
	pass # Replace with function body.
