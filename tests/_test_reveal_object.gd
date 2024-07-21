class_name RevealObjectTest
extends GdUnitTestSuite

const __source = "res://addons/revealer/scripts/reveal_object.gd"

var _test_object: RevealObject
var _test_layer: RevealLayer


func before_test() -> void:
	# Setup a new Revealable
	var canvas_item = auto_free(Node2D.new())
	_test_layer = spy(auto_free(RevealLayer.new()))
	_test_object = spy(auto_free(RevealObject.new(canvas_item, _test_layer)))


func test_init() -> void:
	assert_object(_test_object.canvas_item).is_not_null()
	assert_int(_test_object.default_mode).is_equal(_test_object.canvas_item.process_mode)
	assert_bool(_test_layer.alpha_changed.is_connected(_test_object.set_alpha))
	assert_bool(_test_layer.layer_changed.is_connected(_test_object.set_layer))
	assert_bool(_test_layer.processing_changed.is_connected(_test_object.set_processing))


# it should change the modulate alpha when set_alpha is called
func test_set_alpha() -> void:
	_test_object.set_alpha(0.1)
	assert_float(_test_object.canvas_item.modulate.a).is_equal_approx(0.1, 0.01)


# it should change the z_index when set_layer is called
func test_set_layer() -> void:
	_test_object.set_layer(5)
	assert_int(_test_object.canvas_item.z_index).is_equal(5)


# it should change the process_mode when set_processing is called
func test_set_processing() -> void:
	_test_object.set_processing(false)
	assert_int(_test_object.canvas_item.process_mode).is_equal(Node.PROCESS_MODE_DISABLED)
	_test_object.set_processing(true)
	assert_int(_test_object.canvas_item.process_mode).is_equal(_test_object.default_mode)
