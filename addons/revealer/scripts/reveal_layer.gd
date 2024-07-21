class_name RevealLayer extends Node2D

signal alpha_changed(value: float)
signal layer_changed(active: bool, layer)
signal processing_changed(active: bool)

enum LayerStates { REVEALING, CONCEALING, WAITING }

@export var targets: Array[CanvasItem]
@export var processing: bool = false
@export_range(0.0, 1.0) var alpha: float = 1.0
@export_range(0, 10, 0.05) var transition_time: float = 0.4
@export var state: LayerStates = LayerStates.WAITING
@export var reveal_states: RevealResource = RevealResource.new()

@export var inverse_mask_state: bool = false
@export var mask_level: int = 0
@export var mask_sprite: Sprite2D

var reveal_objects: Array[RevealObject] = []



func _ready() -> void:
	for o in targets:
		RevealObject.new(o, self)
	alpha_changed.emit(alpha)
	layer_changed.emit(reveal_states.default)
	processing_changed.emit(processing)



func _process(delta: float) -> void:
	if self.state == LayerStates.WAITING:
		return

	if self.state == LayerStates.REVEALING:
		self.alpha += delta * (1 / transition_time)
		if self.alpha >= 1.0:
			self.alpha = 1.0
			self.state = LayerStates.WAITING
		alpha_changed.emit(alpha)
	elif self.state == LayerStates.CONCEALING:
		self.alpha -= delta * (1 / transition_time)
		if self.alpha <= 0.0:
			self.alpha = 0.0
			layer_changed.emit(reveal_states.concealed)
			self.state = LayerStates.WAITING
		alpha_changed.emit(self.alpha)


func start_transition(reveal: bool):
	if reveal:
		self.state = LayerStates.REVEALING
		processing_changed.emit(true)
		layer_changed.emit(reveal_states.revealed)
	else:
		self.state = LayerStates.CONCEALING
		processing_changed.emit(false)

	_register_postprocess(reveal)


func _register_postprocess(reveal: bool):
	if not mask_sprite:
		return

	if reveal:
		if not inverse_mask_state:
			PostProcessLayer.get_node("BlurPostProcess").set_mask(mask_level, mask_sprite)
		else:
			PostProcessLayer.get_node("BlurPostProcess").set_mask(mask_level, null)
	else:
		if not inverse_mask_state:
			PostProcessLayer.get_node("BlurPostProcess").set_mask(mask_level, null)
		else:
			PostProcessLayer.get_node("BlurPostProcess").set_mask(mask_level, mask_sprite)