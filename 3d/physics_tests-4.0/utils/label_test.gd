extends Label

var _test_name
var test_name:
	set(value):
		_test_name = value
		set_text("Test: %s" % _test_name)


func _ready():
	set_text("Select a test from the menu to start it")
