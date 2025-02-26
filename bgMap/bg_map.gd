extends Node2D

@onready var tilemap = $TileMapLayer2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random_tile()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func random_tile():
	#tilemap.clear()
	var bg1_cells = tilemap.get_used_cells()
	var ran = RandomNumberGenerator.new()
	make_tile(bg1_cells,Vector2i(18,1),ran)
	pass

func make_tile(cells:Array[Vector2i],new_cell:Vector2i,ran:RandomNumberGenerator):
	for cell_pos in cells:
		var num = ran.randi_range(0,100)
		if num <= 5:
			tilemap.set_cell(cell_pos,0,new_cell,0)
	pass
	
