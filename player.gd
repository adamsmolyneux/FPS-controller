extends CharacterBody3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed : float = 10.0
@export var crouch_speed : float = 4
var current_speed = speed
var lerp_speed = 0.5
var jump_speed = 5
var is_crouching = false
var is_jumping = false
@export var mouse_sensitivity : float = 0.002
var camera_height : float = 2
var crouch_height : float = 0.5
@onready var animation_player = get_node("CameraController/Camera/GunHandler/Pistol/AnimationPlayer")


func _ready():
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	
	velocity.y -= gravity * delta
	
	if is_jumping and not is_crouching:
		velocity.y += jump_speed
		is_jumping = false
		
	var input = Input.get_vector("left", "right", "up", "down")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = lerp(velocity.x, movement_dir.x * current_speed, lerp_speed)
	velocity.z = lerp(velocity.z, movement_dir.z * current_speed, lerp_speed)
	
	move_and_slide()

func _input(event):
	
	if event.is_action_pressed("exit"):
		get_tree().quit()
		
	if event.is_action_pressed("jump") and is_on_floor() and not is_crouching:
		is_jumping = true
		
	if event.is_action_pressed("crouch") and is_on_floor():
		is_crouching = true
		current_speed = crouch_speed
	elif event.is_action_released("crouch"):
		is_crouching = false
		current_speed = speed
		
	if Input.is_action_just_pressed("fire"):
		animation_player.play("GunFire")

		
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$CameraController/Camera.rotate_x(-event.relative.y * mouse_sensitivity)
		$CameraController/Camera.rotation.x = clampf($CameraController/Camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _process(_delta):
	
	if is_crouching:
		$CameraController/Camera.transform.origin.y = lerp($CameraController/Camera.transform.origin.y, crouch_height, lerp_speed)
	else:
		$CameraController/Camera.transform.origin.y = lerp($CameraController/Camera.transform.origin.y, camera_height, lerp_speed)



		

