class_name RevealResource extends Resource

enum LayerIndexes { CONCEALED = 0, REVEALED = 10, PLAYER = 15, GUI = 100 }

@export var default = LayerIndexes.CONCEALED
@export var concealed = LayerIndexes.CONCEALED
@export var revealed = LayerIndexes.REVEALED


func _init(
	default: LayerIndexes = LayerIndexes.CONCEALED,
	concealed: LayerIndexes = LayerIndexes.CONCEALED,
	revealed: LayerIndexes = LayerIndexes.REVEALED
) -> void:
	self.default = default
	self.concealed = concealed
	self.revealed = revealed
