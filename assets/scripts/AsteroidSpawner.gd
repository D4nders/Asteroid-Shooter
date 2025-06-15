extends Node2D

@export var asteroid_scene: PackedScene

@onready var timer: Timer = $Timer

var _view_rect: Rect2
var _buffer: float = 20.0

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _physics_process(delta: float) -> void:
	var camera = get_viewport().get_camera_2d()
	if camera:
		var camera_rect = camera.get_viewport_rect()
		_view_rect.size = camera_rect.size
		_view_rect.position = camera.get_screen_center_position() - camera_rect.size / 2.0
	else:
		_view_rect = get_viewport().get_visible_rect()

func _on_timer_timeout() -> void:
	if not asteroid_scene or _view_rect.size == Vector2.ZERO:
		return

	var asteroid = asteroid_scene.instantiate()
	var spawn_position: Vector2
	
	var side = randi_range(0, 3)
	
	match side:
		0: # Top
			spawn_position.x = randf_range(_view_rect.position.x, _view_rect.end.x)
			spawn_position.y = _view_rect.position.y - _buffer
		1: # Right
			spawn_position.x = _view_rect.end.x + _buffer
			spawn_position.y = randf_range(_view_rect.position.y, _view_rect.end.y)
		2: # Bottom
			spawn_position.x = randf_range(_view_rect.position.x, _view_rect.end.x)
			spawn_position.y = _view_rect.end.y + _buffer
		3: # Left
			spawn_position.x = _view_rect.position.x - _buffer
			spawn_position.y = randf_range(_view_rect.position.y, _view_rect.end.y)
	
	asteroid.global_position = spawn_position
	get_parent().add_child(asteroid)
	
	var target_point = Vector2(
		randf_range(_view_rect.position.x, _view_rect.end.x),
		randf_range(_view_rect.position.y, _view_rect.end.y)
	)
	
	var direction = (target_point - asteroid.global_position).normalized()
	var speed = randf_range(100.0, 300.0)
	asteroid.linear_velocity = direction * speed
	asteroid.angular_velocity = randf_range(-2.0, 2.0)
