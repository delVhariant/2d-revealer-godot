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
