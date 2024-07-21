@tool
extends EditorPlugin

# Autload the PostProcessLayer
const PP_AUTOLOAD = "PostProcessLayer"


func _enter_tree():
	# The autoload can be a scene or script file.
	add_autoload_singleton(PP_AUTOLOAD, "res://addons/revealer/scenes/post_process_layer.tscn")


func _exit_tree():
	remove_autoload_singleton(PP_AUTOLOAD)
