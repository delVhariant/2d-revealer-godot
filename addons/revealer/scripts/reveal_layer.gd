class_name RevealLayer extends Node2D

signal alpha_changed(value: float)
signal layer_changed(layer: int)
signal processing_changed(active: bool)

enum LayerStates { REVEALING, CONCEALING, WAITING }

@export var targets: Array[CanvasItem]
@export var start_processing: bool = false
@export_range(0.0, 1.0) var alpha: float = 1.0
@export_range(0, 10, 0.05) var transition_time: float = 0.4
@export var reveal_states: RevealResource = RevealResource.new()
@export var no_blur: bool = false
@export var inverse_blur_state: bool = false

var state: LayerStates = LayerStates.WAITING


func _ready() -> void:
	# Use lambda functions to map properties to signals
	for o in targets:
		alpha_changed.connect(func(value: float): o.modulate.a = value)
		layer_changed.connect(func(layer: int): o.z_index = layer)
		processing_changed.connect(
			func(active: bool): o.process_mode = (
				self.process_mode if active else Node.PROCESS_MODE_DISABLED
			)
		)

	# Emit all signals to initialise everything
	alpha_changed.emit(alpha)
	layer_changed.emit(reveal_states.default)
	processing_changed.emit(start_processing)


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

	if !no_blur:
		_handle_blur(reveal)


func _handle_blur(reveal: bool):
	# Groups are used to support
	if reveal:
		if not inverse_blur_state:
			get_tree().call_group("blur", "enter_layer", self)
		else:
			get_tree().call_group("blur", "leave_layer", self)
	else:
		if not inverse_blur_state:
			get_tree().call_group("blur", "leave_layer", self)
		else:
			get_tree().call_group("blur", "enter_layer", self)
