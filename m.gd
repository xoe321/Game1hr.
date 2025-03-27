extends CharacterBody3D

const SPEED = 2.0
const GRAVITY = 9.8
const TURN_INTERVAL = 1.5  # เปลี่ยนทิศทางทุกๆ 1.5 วินาที

var target_direction = Vector3.ZERO
var time_to_next_turn = 0.0

func _ready() -> void:
	time_to_next_turn = TURN_INTERVAL

func _physics_process(delta: float) -> void:
	# แรงโน้มถ่วง
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# นับถอยหลังเพื่อเปลี่ยนทิศทาง
	time_to_next_turn -= delta
	if time_to_next_turn <= 0:
		pick_new_direction()
		time_to_next_turn = randf_range(1.0, 3.0)

	# เคลื่อนที่ไปข้างหน้าโดยไม่ลอย
	var horizontal_velocity = target_direction * SPEED
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z

	move_and_slide()

func pick_new_direction() -> void:
	# สุ่มทิศทางใหม่ (แบบ 360 องศา)
	var angle = randf_range(0, TAU)
	target_direction = Vector3(cos(angle), 0, sin(angle)).normalized()

	# หมุน NPC ไปในทิศทางใหม่
	look_at(global_transform.origin + target_direction)
