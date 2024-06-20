class_name Player extends CharacterBody2D

var _state_machine
var _is_attacking: bool = false

@export_category("Variables")
@export var _move_speed: float = 64.0 # +/- 4 celulas por segundo
@export var _acceleration: float = .4
@export var _friction: float = .8

@export_category("Objets")
@export var _animation_tree: AnimationTree


func _ready() -> void:
	_animation_tree.active = true
	_state_machine = _animation_tree["parameters/playback"]

	
func _physics_process(_delta: float) -> void:
	_move()
	_attack()
	_animate()
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
		_animation_tree["parameters/idle/blend_position"] = _direction
		_animation_tree["parameters/walk/blend_position"] = _direction
		_animation_tree["parameters/attack/blend_position"] = _direction
	
		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _acceleration)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _acceleration)
		return
	
	velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction)
	velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction)
	velocity = _direction.normalized() * _move_speed
	
	
func _animate() -> void:
	if _is_attacking:
		_state_machine.travel("attack")
		return

	if velocity.length() > 2:
		_state_machine.travel("walk")
		return
	_state_machine.travel("idle")


func _attack() -> void:
	if Input.is_action_just_pressed("attack") && !_is_attacking:
		set_physics_process(false)
		_is_attacking = true


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack_up" || anim_name == "attack_down" || anim_name == "attack_left" || anim_name == "attack_right":
		_is_attacking = false
		set_physics_process(true)
		

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.update_health(randi_range(1, 5))