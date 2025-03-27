extends CharacterBody3D

@export var mouse_sensitivity: float = 0.1
var pitch: float = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		# หมุนแนวราบ (Yaw) ที่ CharacterBody3D
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		
		# คำนวณและจำกัดการหมุนแนวตั้ง (Pitch)
		pitch = clamp(pitch - event.relative.y * mouse_sensitivity, -90, 90)
		# ระบุเส้นทาง Node ที่ถูกต้อง
		get_node("Camera3D").rotation_degrees.x = pitch
