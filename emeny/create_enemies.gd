extends Node2D

@onready var enemy = load("res://emeny/enemy.tscn")
@onready var location = load("res://emeny/location.tscn")
@onready var lotime = $location
var tilemap = null
@export var player : CharacterBody2D
@export var enemy_types : Array[Enemy]
var pos = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap = get_tree().get_nodes_in_group("map")[1]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func create_pos():
	var ran = RandomNumberGenerator.new()
	var num = ran.randi_range(0,len(tilemap.get_used_cells())-1)
	var local_position= tilemap.map_to_local(tilemap.get_used_cells()[num])
	return local_position * Vector2(6,6)

func create_type(posthis):
	if self.get_child_count()<50:
		var enemyTemp=enemy.instantiate()
		enemyTemp.type=enemy_types[0]
		enemyTemp.position = posthis
		# 多人游戏需要改
		enemyTemp.player_reference = player
		self.add_child(enemyTemp)

func _on_timer_timeout() -> void:
	pos = create_pos()
	var lpos = location.instantiate()
	lpos.position = pos
	var tween = get_tree().create_tween()
	tween.tween_property(lpos,"scale",Vector2(100,100),0.5)
	tween.tween_callback(func():lpos.queue_free())
	tween.bind_node(lpos)
	self.add_child(lpos)
	if lotime.is_stopped():
		lotime.start()
	pass # Replace with function body.


func _on_location_timeout() -> void:
	create_type(pos)
	pass # Replace with function body.
