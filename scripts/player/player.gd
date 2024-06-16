extends CharacterBody2D
class_name Player

@export var _move_speed: float = 64.0 # +/- 4 celulas por segundo
@export var _acceleration: float = .4
@export var _friction: float = .8


func _physics_process(_delta: float) -> void:
	_move()
	move_and_slide()
	
func _move() -> void:
	var _direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
#	if input_direction:
#		velocity.x = input_direction * move_speed
#	else:
#		velocity.x = move_toward(velocity.x, 0, move_speed)

	if _direction != Vector2.ZERO:
		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _acceleration)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _acceleration)
		return
	
	velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction)
	velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction)
	velocity = _direction.normalized() * _move_speed
	
