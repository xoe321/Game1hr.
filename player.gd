extends CharacterBody3D

# ความเร็วการเดินและกระโดด
const SPEED = 5.0
const JUMP_VELOCITY = 0

# ความไวเมาส์
@export var mouse_sensitivity: float = 0.2

# กล้อง
@onready var camera = $Camera3D
var rotation_x: float = 0.0

func _ready() -> void:
	# ล็อคเมาส์ตรงกลางจอ
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# เพิ่มแรงโน้มถ่วง
	if not is_on_floor():
		velocity.y -= 9.8 * delta

	# กระโดด
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# รับค่าการกดปุ่ม
	var input_dir = Input.get_vector("a", "d", "s", "w")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# หมุนตามกล้อง (เคลื่อนที่ไปข้างหน้า-ถอยหลัง-ซ้าย-ขวา)
	if direction:
		var forward = -camera.global_transform.basis.z
		var right = camera.global_transform.basis.x
		var move_dir = (forward * input_dir.y + right * input_dir.x).normalized()
		velocity.x = move_dir.x * SPEED
		velocity.z = move_dir.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	# หมุนกล้องด้วยเมาส์
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		rotation_x += -event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, -90, 90)
		camera.rotation_degrees.x = rotation_x
