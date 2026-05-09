extends Node3D

@onready var mesh_instance = $MeshInstance3D

var is_safe = false

func set_material(mat: Material):
	mesh_instance.material_override = mat

func set_safe(value: bool):
	is_safe = value

	if value:
		var mat = mesh_instance.material_override
		if mat:
			mat = mat.duplicate()
			mat.albedo_color = Color(0, 1, 0)
			mesh_instance.material_override = mat
		else:
			# Fallback si pas de matériau assigné
			var fallback = StandardMaterial3D.new()
			fallback.albedo_color = Color(0, 1, 0)
			mesh_instance.material_override = fallback
