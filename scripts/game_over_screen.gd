extends Control


func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Restart"):
		_on_reset_button_pressed()
