class_name RevealPostProcess extends ColorRect

@export var reveal_states: RevealResource = RevealResource.new()

var layers: Array[RevealLayer] = []
var blurred: bool = false


func _ready() -> void:
	update_states()
	self.add_to_group("blur")


func update_states():
	self.z_as_relative = false
	self.z_index = reveal_states.concealed


func enter_layer(layer: RevealLayer):
	if layer not in self.layers:
		self.layers.append(layer)
	if !self.blurred and self.layers.size() > 0:
		print("entering: " + layer.name)
		self.blurred = true
		material.set_shader_parameter("blurred", true)


func leave_layer(layer: RevealLayer):
	var idx = self.layers.find(layer)
	if idx != -1:
		self.layers.remove_at(idx)
	if self.blurred and self.layers.size() == 0:
		print("leaving: " + layer.name)
		self.blurred = false
		material.set_shader_parameter("blurred", false)
