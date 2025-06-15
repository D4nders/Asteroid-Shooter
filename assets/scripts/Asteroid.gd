extends RigidBody2D

@export var sprite_sheet: Texture2D
@export var region_vectors: Array[Vector4]
@export var tint_color: Color = Color.RED

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var _processed_regions: Array[Rect2] = []
var shader_material: ShaderMaterial

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	screen_notifier.screen_exited.connect(_on_screen_exited)
	
	if sprite.material is ShaderMaterial:
		shader_material = sprite.material.duplicate()
		sprite.material = shader_material
		shader_material.set_shader_parameter("tint_color", tint_color)

	process_region_vectors()
	
	if sprite_sheet and not _processed_regions.is_empty():
		sprite.texture = sprite_sheet
		
		var chosen_region: Rect2 = _processed_regions.pick_random()
		sprite.region_enabled = true
		sprite.region_rect = chosen_region
		
		if collision_shape.shape is CircleShape2D:
			var circle_shape: CircleShape2D = collision_shape.shape
			circle_shape.radius = max(chosen_region.size.x, chosen_region.size.y) / 2.0

func process_region_vectors() -> void:
	if region_vectors:
		for vec in region_vectors:
			_processed_regions.append(Rect2(vec.x, vec.y, vec.z, vec.w))

func take_damage() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	pass

func _on_screen_exited() -> void:
	queue_free()
