extends Node3D

var mesh_instance: MeshInstance3D

# Identifiant du joueur propriétaire
var player_id: int = 0

# Position sur le chemin (-1 = à la maison)
var path_position: int = -1

# Si le pion est en sécurité
var is_safe: bool = false

# Couleurs pour les joueurs
const PLAYER_COLORS = [
	Color(1, 0, 0),  # Rouge
	Color(0, 1, 0),  # Vert
	Color(0, 0, 1),  # Bleu
	Color(1, 1, 0),  # Jaune
	Color(1, 0, 1),  # Magenta
	Color(0, 1, 1),  # Cyan
	Color(1, 0.5, 0),  # Orange
	Color(0.5, 0, 1),  # Violet
]

func _ready():
	# Récupère la référence au MeshInstance3D
	mesh_instance = $MeshInstance3D
	
	# Applique la couleur du joueur
	apply_player_color()

func apply_player_color():
	if mesh_instance:
		var mat = StandardMaterial3D.new()
		mat.albedo_color = PLAYER_COLORS[player_id % PLAYER_COLORS.size()]
		mesh_instance.material_override = mat

func set_player_id(id: int):
	player_id = id
	apply_player_color()  # Met à jour la couleur si changé après _ready

func set_path_position(pos: int):
	path_position = pos

func set_safe(value: bool):
	is_safe = value
	# Changer la couleur ou l'apparence pour indiquer sécurité
	if value:
		if mesh_instance and mesh_instance.material_override:
			var mat = mesh_instance.material_override.duplicate()
			mat.albedo_color = Color(0, 1, 1)  # Cyan pour sécurité
			mesh_instance.material_override = mat

# Fonction pour déplacer le pion (à implémenter plus tard)
func move_to_tile(tile: Node3D):
	if tile:
		position = tile.position + Vector3(0, 0.5, 0)  # Légèrement au-dessus de la tuile