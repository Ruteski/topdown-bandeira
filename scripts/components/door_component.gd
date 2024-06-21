class_name DoorComponent extends Area2D

var _player_ref: Player

@export_category("Variables")
@export var _teleport_position: Vector2

@export_category("Objects")
@export var _animation: AnimationPlayer


func _on_body_entered(body: Node2D) -> void:
#	if body.name == 'Player':
#		pass
	if body is Player:
		_player_ref = body
		_animation.play("open")		
		

func _on_animation_finished(anim_name: StringName) -> void :
	if anim_name == "open":
		_player_ref.global_position = _teleport_position
		_animation.play("close")
