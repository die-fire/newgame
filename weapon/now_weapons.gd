extends Node2D

@onready var ranged = load("res://weapon/ranged/ranged.tscn")
var weapon_radius = 230
var weapon_num = 6
var has_weapons : Array[Weapon]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_weapons()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_weapons():
	for i in weapon_num:
		get_weapons_child()
	get_weapons_pos()

func get_weapons_child():
	var rangeds = ranged.instantiate()
	self.add_child(rangeds)

func get_weapons_pos():
	weapon_num = self.get_child_count()
	var unit = TAU / weapon_num
	var weapons = self.get_children()
	
	for i in len(weapons):
		var weapon = weapons[i]
		var weapon_rad = unit * i
		var end_pos = weapon.position + Vector2(weapon_radius,0).rotated(weapon_rad)
		weapon.position = end_pos

	
