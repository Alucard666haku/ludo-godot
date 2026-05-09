extends Node3D

@export var tile_scene: PackedScene
@export var default_material: Material

@export var radius: float = 5.0
@export var step: float = 1.5

@onready var path = $Path # Node enfant avec le script path.gd

var tiles = []
var pawns = []
var player_id: int = 0

func _ready():
	generate_tiles()
	apply_material()
	apply_safe_logic()  # ← après le matériau de base
	path.setup(self, tiles)  # ← initialise le chemin avec les tuiles générées
	spawn_pawns()  # ← génère les 4 pions du joueur

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

func spawn_pawns():
	var container = $Tiles  # On ajoute les pions dans le même conteneur que les tuiles

	# Positions de départ des pions (à la maison)
	# Utilise les tuiles du fond du camp : z=3 et z=4, x=0 et x=1
	var home_coords = [
		Vector2i(3, 0),  # z=3, x=0
		Vector2i(3, 1),  # z=3, x=1
		Vector2i(4, 0),  # z=4, x=0
		Vector2i(4, 1),  # z=4, x=1
	]

	var cols = 3
	for i in range(4):
		var coord = home_coords[i]
		var z = coord.x
		var x = coord.y
		var index = z * cols + x

		if index >= 0 and index < tiles.size():
			var tile = tiles[index]

			# Crée le pion
			var pawn = Node3D.new()
			pawn.script = load("res://scripts/pawn.gd")
			pawn.name = "Pawn" + str(i)

			# Ajoute un MeshInstance3D pour la visualisation
			var mesh = MeshInstance3D.new()
			mesh.mesh = BoxMesh.new()
			mesh.scale = Vector3(0.5, 0.5, 0.5)
			pawn.add_child(mesh)

			container.add_child(pawn)
			pawns.append(pawn)

			# Positionne le pion sur la tuile
			pawn.position = tile.position + Vector3(0, 0.5, 0)
			pawn.set_player_id(player_id)

	print("[Camp] Généré ", pawns.size(), " pions pour le joueur ", player_id)
