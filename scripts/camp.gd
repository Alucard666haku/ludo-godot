extends Node3D

@export var tile_scene: PackedScene
@export var default_material: Material

@export var radius: float = 5.0
@export var step: float = 1.5

@onready var path = $Path # Node enfant avec le script path.gd

var tiles = []

func _ready():
	generate_tiles()
	apply_material()
	apply_safe_logic()  # ← après le matériau de base
	path.setup(self, tiles)  # ← initialise le chemin avec les tuiles générées

func generate_tiles():
	var container = $Tiles

	for c in container.get_children():
		c.queue_free()

	tiles.clear()

	var rows = 5
	var cols = 3
	var spacing = 1.2

	for z in range(rows):
		for x in range(cols):
			var pos = Vector3(
				(x - 1) * spacing,
				0,
				z * spacing
			)
			create_tile(pos)

func create_tile(pos: Vector3):
	var tile = tile_scene.instantiate()
	$Tiles.add_child(tile)
	tile.position = pos
	tiles.append(tile)
	return tile

func apply_material():
	for tile in tiles:
		tile.set_material(default_material)

func apply_safe_logic():
	var cols = 3
	for i in range(tiles.size()):
		var x = i % cols
		var z : int
		@warning_ignore("integer_division")
		z = (i / cols)

		if x == 0 and z == 2:
			tiles[i].set_safe(true)
		elif x == 1 and z in [1, 2, 3, 4]:
			tiles[i].set_safe(true)
		elif x == 2 and z == 1:
			tiles[i].set_safe(true)
