extends LineEdit
 
# Provides additional functionality when run in a browser
export (String) var title = "Enter value"
 
onready var is_html = OS.get_name()=="HTML5"
 
func _input(event):
    if is_html:
        if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
            if get_global_rect().has_point(event.position):
                self.get_tree().set_input_as_handled()
                var new_text = JavaScript.eval('prompt("%s", "%s");' % [title, text])
                if new_text:
                    text = new_text.substr(0,max_length)
                    emit_signal("text_changed", new_text)
                    emit_signal("text_entered", new_text)