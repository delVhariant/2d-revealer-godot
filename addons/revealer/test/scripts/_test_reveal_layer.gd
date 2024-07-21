class_name RevealLayerTest
extends GdUnitTestSuite

const __source = "res://addons/revealer/scripts/reveal_layer.gd"

var test_layer: RevealLayer


func before_test() -> void:
	# Setup a new Revealable
	test_layer = monitor_signals(RevealLayer.new())
	add_child(test_layer)


func test_init() -> void:
	(
		assert_signal(test_layer)
		. is_signal_exists("alpha_changed")
		. is_signal_exists("layer_changed")
		. is_signal_exists("processing_changed")
	)
	await assert_signal(test_layer).is_emitted("alpha_changed")


func test_transition() -> void:
	assert_int(test_layer.state).is_equal(RevealLayer.LayerStates.WAITING)
	test_layer.start_transition(true)
	assert_int(test_layer.state).is_equal(RevealLayer.LayerStates.REVEALING)
	await assert_signal(test_layer).is_emitted("processing_changed", [true])
