# GdUnit generated TestSuite
class_name RevealableTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/revealer/scripts/revealable.gd'

func get_dummy(
	target: Sprite2D = mock(Sprite2D),
	material: ShaderMaterial = mock(ShaderMaterial),
	depth: int = 1,
	parent: Sprite2D = mock(Sprite2D),
	mask: Sprite2D = mock(Sprite2D)) -> Revealable:
		return Revealable.new(
			target,
			material,
			depth,
			parent,
			mask
		)

func test_reveal() -> void:
	var mock_sprite = auto_free(Sprite2D.new())
	var mock_mat = auto_free(mock(ShaderMaterial))
	mock_sprite.set_material(mock_mat)
	var mock_revealable = auto_free(get_dummy(mock_sprite))
	var spy = spy(mock_revealable)
	const VALUE=0.5
	mock_revealable.reveal(VALUE)
	verify(spy.target.material, 1).set_shader_parameter("revealed_amount", VALUE)
