# GdUnit generated TestSuite
class_name RevealableTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/revealer/scripts/revealable.gd"

var _test_spy: Revealable


func before_test() -> void:
	# Setup a new Revealable
	var sprite = auto_free(Sprite2D.new())
	var material = mock(ShaderMaterial) as ShaderMaterial
	do_return(ShaderMaterial).on(material).duplicate()
	_test_spy = spy(Revealable.new(sprite, material, 1))


func after_test() -> void:
	# Free the revealable
	_test_spy.free()


# Should initialise
func test_init() -> void:
	assert_object(_test_spy.target).is_not_null()
	assert_object(_test_spy.target.material).is_not_null()
	verify(_test_spy.target.material).set_shader_parameter("reveal_depth", 1)


# Should set Shader parameter 'revealed_amount' when reveal is called
func test_reveal() -> void:
	_test_spy.reveal(0.5)
	verify(_test_spy.target.material).set_shader_parameter("revealed_amount", 0.5)


# Should set Shader parameter 'reveal_depth' when set_reveal_depth is called
func test_set_depth() -> void:
	# set_reveal_depth is called during init
	reset(_test_spy.target.material)
	_test_spy.set_reveal_depth(1)
	verify(_test_spy.target.material, 1).set_shader_parameter("reveal_depth", 1)


# Should set 'revealed_amount_target' when 'set_reveal_target' is called
func test_set_reveal_target() -> void:
	reset(_test_spy.target.material)
	_test_spy.set_reveal_target(0.0)
	verify(_test_spy.target.material, 1).set_shader_parameter("revealed_amount_target", 0.0)
