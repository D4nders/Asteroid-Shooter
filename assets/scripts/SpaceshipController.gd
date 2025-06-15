extends CharacterBody2D

@export_group("Movement")
@export var engine_power: float = 500.0
@export var max_speed: float = 600.0
@export_range(0.0, 1.0) var friction: float = 0.05

@export_group("Rotation")
@export var rotation_speed: float = 3.5

@export_group("Visuals")
@export var tint_color: Color = Color.RED

@export_group("Shooting")
@export var laser_scene: PackedScene
@export var fire_rate: float = 0.2

@onready var sprite: Sprite2D = $Sprite2D
@onready var muzzle: Marker2D = $Muzzle

var shader_material: ShaderMaterial
var _fire_cooldown: float = 0.0

func _ready() -> void:
	if sprite.material is ShaderMaterial:
		shader_material = sprite.material.duplicate()
		sprite.material = shader_material

func _physics_process(delta: float) -> void:
	if _fire_cooldown > 0:
		_fire_cooldown -= delta

	if Input.is_action_pressed("fire"):
		if _fire_cooldown <= 0:
			fire()
			_fire_cooldown = fire_rate

	handle_rotation(delta)
	handle_movement(delta)

func _process(delta: float) -> void:
	update_tint_color()

func handle_rotation(delta: float) -> void:
	var rotation_input = Input.get_axis("turn_left", "turn_right")
	rotation += rotation_input * rotation_speed * delta

func handle_movement(delta: float) -> void:
	var thrust_input = Input.get_axis("thrust_backward", "thrust_forward")
	var direction = Vector2.UP.rotated(rotation)

	if thrust_input != 0:
		velocity += direction * thrust_input * engine_power * delta

	velocity = velocity.lerp(Vector2.ZERO, friction)
	velocity = velocity.limit_length(max_speed)
	move_and_slide()

func update_tint_color() -> void:
	if shader_material:
		shader_material.set_shader_parameter("tint_color", tint_color)

func fire() -> void:
	if not laser_scene or not muzzle:
		print("Cannot fire: LaserScene or Muzzle not set up.")
		return

	var laser = laser_scene.instantiate()
	get_tree().root.add_child(laser)
	laser.global_transform = muzzle.global_transform
