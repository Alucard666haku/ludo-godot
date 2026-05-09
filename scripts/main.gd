extends Node3D

@export var camp_scene: PackedScene
@export var player_count: int = 4   # 👉 change ici pour tester (2,3,4...)

func _ready():
	setup_camera()
	setup_light()
	spawn_camps()

# 🎥 caméra vue du dessus
func setup_camera():
	var cam = $CameraTop
	
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = 30
	
	cam.position = Vector3(0, 30, 0)
	cam.rotation_degrees = Vector3(-90, 0, 0)
	
	cam.current = true

# 💡 lumière
func setup_light():
	var light = $DirectionalLight3D
	light.rotation_degrees = Vector3(-45, 45, 0)

# 🔥 génération multi camps
func spawn_camps():
	for i in range(player_count):
		var camp = camp_scene.instantiate()
		add_child(camp)

		# 👉 angle selon nombre de joueurs
		var angle = i * (360.0 / player_count)

		# 👉 rotation du camp
		camp.rotation_degrees.y = angle

		# 👉 position autour du centre
		var distance = 10
		camp.position = Vector3(0, 0, -distance).rotated(Vector3.UP, deg_to_rad(angle))
