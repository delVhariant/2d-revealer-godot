# GdUnit generated TestSuite
class_name RevealableTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://addons/revealer/scripts/revealable.gd"


func get_dummy(
	target: Sprite2D = mock(Sprite2D), material: ShaderMaterial = mock(ShaderMaterial)
) -> Revealable:
	return Revealable.new(target, material)


func test_reveal() -> void:
	var mock_sprite = auto_free(Sprite2D.new())
	var mock_mat = auto_free(mock(ShaderMaterial))
	mock_sprite.set_material(mock_mat)
	var mock_revealable = auto_free(get_dummy(mock_sprite))
	assert_object(mock_revealable.target).is_not_null()
	assert_object(mock_revealable.target.material).is_not_null()
