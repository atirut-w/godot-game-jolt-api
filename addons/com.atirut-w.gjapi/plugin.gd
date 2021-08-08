tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("GameJolt", "res://addons/com.atirut-w.gjapi/api.gd")

func _exit_tree():
	remove_autoload_singleton("GameJolt")
