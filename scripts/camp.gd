extends Node3D

@export var tile_scene: PackedScene
@export var default_material: Material

@export var radius: float = 5.0
@export var step: float = 1.5

var tiles = []

func _ready():
	generate_tiles()
	apply_material()

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
				(x - 1) * spacing,  # centrer sur X
				0,
				z * spacing        # vers l'avant
			)

			var tile = create_tile(pos)

			# 👉 LOGIQUE SAFE
			if x == 0 and z == 2:
				tile.set_safe(true)   # gauche (1)
			elif x == 1 and z in [0,1,2,3]:
				tile.set_safe(true)   # milieu (4)
			elif x == 2 and z == 2:
				tile.set_safe(true)   # droite (1)

func create_tile(pos: Vector3):
	var tile = tile_scene.instantiate()
	$Tiles.add_child(tile)

	tile.position = pos
	tiles.append(tile)

	return tile

func apply_material():
	for tile in tiles:
		tile.set_material(default_material)
