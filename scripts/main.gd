extends Node3D

# 👉 Tu assignes Camp.tscn ici dans l'Inspector
@export var camp_scene: PackedScene

func _ready():
	setup_camera()
	setup_light()
	spawn_camp()  # 👉 pour l’instant on spawn UN camp

# 🎥 Configuration caméra (vue du dessus)
func setup_camera():
	var cam = $CameraTop
	
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = 20
	
	cam.position = Vector3(0, 20, 0)
	cam.rotation_degrees = Vector3(-90, 0, 0)
	
	cam.current = true

# 💡 Lumière simple
func setup_light():
	var light = $DirectionalLight3D
	light.rotation_degrees = Vector3(-45, 45, 0)

# 🧱 Instancier un Camp
func spawn_camp():
	var camp = camp_scene.instantiate()
	add_child(camp)
