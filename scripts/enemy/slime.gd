class_name Slime extends CharacterBody2D

var _player_ref: Player = null
var _slime_speed: float = 40.0
var _is_dead: bool = false

@export_category("Objects")
@export var _texture: Sprite2D
@export var _animation: AnimationPlayer


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_ref = body
	

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_ref = null

		
func _physics_process(_delta: float) -> void:
	if _is_dead:
		return
	
	_animate()

	if _player_ref != null:
		if _player_ref._is_dead:
			_player_ref._state_machine.travel("death")
			velocity = Vector2.ZERO
			move_and_slide()
			return
					
		var _direction: Vector2 = global_position.direction_to(_player_ref.global_position)
		var _distance: float = global_position.distance_squared_to(_player_ref.global_position)
		
		if _distance <= 270:
			_player_ref.die()
	
		velocity = _direction * _slime_speed
		move_and_slide()
		
		
func _animate() -> void:
	if velocity.x > 0:
		_texture.flip_h = false
	elif velocity.x < 0:
		_texture.flip_h = true
	
	if velocity != Vector2.ZERO:
		_animation.play("walk")
		return

	_animation.play("idle")
	
	
func update_health() -> void:
	_is_dead = true
	_animation.play("death")
