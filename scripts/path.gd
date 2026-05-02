# path.gd
# Gère la séquence de tuiles qui forment le chemin d'un joueur :
# - Le chemin circulaire (aller) : contour en U du camp
# - La voie de retour (milieu) : colonne centrale vers le centre
extends Node

# --------------------------------------------------
# CONSTANTES DE STRUCTURE DU CAMP
# --------------------------------------------------

# Nombre de rangées et colonnes de la grille d'un camp
const ROWS = 5
const COLS = 3

# --------------------------------------------------
# SÉQUENCE DES TUILES
# --------------------------------------------------

# Chemin circulaire (aller) — ordre des coordonnées (z, x)
# Le joueur entre par (0,2), descend la colonne droite,
# traverse le bas, remonte la colonne gauche jusqu'à (0,0)
# puis repart vers le camp du joueur suivant
const CIRCULAR_PATH = [
	Vector2i(0, 2),  # 1  — entrée du camp (côté centre, colonne droite)
	Vector2i(1, 2),  # 2
	Vector2i(2, 2),  # 3
	Vector2i(3, 2),  # 4
	Vector2i(4, 2),  # 5  — coin bas-droite
	Vector2i(4, 1),  # 6  — bas milieu
	Vector2i(4, 0),  # 7  — coin bas-gauche
	Vector2i(3, 0),  # 8
	Vector2i(2, 0),  # 9
	Vector2i(1, 0),  # 10
	Vector2i(0, 0),  # 11 — sortie vers le camp suivant
]

# Voie de retour (milieu) — utilisée quand le joueur a fait le tour complet
# Il entre à nouveau par (0,2), descend jusqu'en bas,
# puis remonte par la colonne centrale jusqu'à (0,1)
# La case (0,1) est la dernière avant d'entrer au centre (victoire)
const RETURN_PATH = [
	Vector2i(0, 2),  # R1  — même entrée que le chemin circulaire
	Vector2i(1, 2),  # R2
	Vector2i(2, 2),  # R3
	Vector2i(3, 2),  # R4
	Vector2i(4, 2),  # R5  — coin bas-droite
	Vector2i(4, 1),  # R6  — bas milieu (jonction avec le chemin circulaire)
	Vector2i(3, 1),  # R7  — bascule sur la colonne centrale
	Vector2i(2, 1),  # R8
	Vector2i(1, 1),  # R9
	Vector2i(0, 1),  # R10 — dernière case avant le centre (victoire !)
]

# --------------------------------------------------
# VARIABLES D'ÉTAT
# --------------------------------------------------

# Référence vers le camp parent (Node3D avec les tuiles)
var camp = null

# Tableau des tuiles dans l'ordre du chemin circulaire
var circular_tiles = []

# Tableau des tuiles dans l'ordre de la voie de retour
var return_tiles = []

# --------------------------------------------------
# INITIALISATION
# --------------------------------------------------

# À appeler depuis camp.gd après generate_tiles()
# Prend en paramètre la référence au camp et son tableau de tuiles
func setup(camp_node: Node3D, tiles: Array) -> void:
	camp = camp_node

	# On résout les séquences de coordonnées en références de tuiles réelles
	circular_tiles = _resolve_path(CIRCULAR_PATH, tiles)
	return_tiles   = _resolve_path(RETURN_PATH,   tiles)

	print("[Path] Chemin circulaire : ", circular_tiles.size(), " tuiles")
	print("[Path] Voie de retour    : ", return_tiles.size(),   " tuiles")

# --------------------------------------------------
# RÉSOLUTION DES COORDONNÉES → TUILES
# --------------------------------------------------

# Convertit une liste de Vector2i(z, x) en liste de références de tuiles
# On retrouve l'index dans le tableau flat : index = z * COLS + x
func _resolve_path(coords: Array, tiles: Array) -> Array:
	var result = []

	for coord in coords:
		var z = coord.x  # coord.x = z (rangée)
		var x = coord.y  # coord.y = x (colonne)

		# Calcul de l'index dans le tableau flat de tiles
		var index = z * COLS + x

		# Vérification que l'index est valide
		if index >= 0 and index < tiles.size():
			result.append(tiles[index])
		else:
			push_warning("[Path] Coordonnée invalide : z=%d x=%d (index=%d)" % [z, x, index])

	return result

# --------------------------------------------------
# ACCESSEURS
# --------------------------------------------------

# Retourne la tuile à la position donnée dans le chemin circulaire
# position : index de 0 à circular_tiles.size()-1
func get_circular_tile(position: int) -> Node3D:
	if position < 0 or position >= circular_tiles.size():
		push_warning("[Path] Position circulaire invalide : %d" % position)
		return null
	return circular_tiles[position]

# Retourne la tuile à la position donnée dans la voie de retour
func get_return_tile(position: int) -> Node3D:
	if position < 0 or position >= return_tiles.size():
		push_warning("[Path] Position retour invalide : %d" % position)
		return null
	return return_tiles[position]

# Retourne la longueur du chemin circulaire (utile pour le déplacement)
func circular_length() -> int:
	return circular_tiles.size()

# Retourne la longueur de la voie de retour
func return_length() -> int:
	return return_tiles.size()
