extends BoxContainer

@onready var vboxlabels = %VboxLabel
# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if Input.is_action_just_pressed("enter"):
		print("Hello")
		create_query_label()


func create_query_label():
	
	var label = Label.new()
	label.text="Hello"
	add_child(label)
	vboxlabels.add_child(label)
	return label