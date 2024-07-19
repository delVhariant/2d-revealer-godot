class_name RevealObject extends Object

var canvas_item: CanvasItem
var default_mode: Node.ProcessMode


func _init(canvas_item: CanvasItem, layer: RevealLayer):
	self.canvas_item = canvas_item
	self.default_mode = canvas_item.process_mode
	layer.alpha_changed.connect(self.set_alpha)
	layer.layer_changed.connect(self.set_layer)
	layer.processing_changed.connect(self.set_processing)
	self.canvas_item.show()



func set_alpha(value: float):
	self.canvas_item.modulate.a = value


func set_layer(layer: int):
	self.canvas_item.z_index = layer


func set_processing(process: bool):
	if !process:
		self.canvas_item.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		self.canvas_item.process_mode = self.default_mode
