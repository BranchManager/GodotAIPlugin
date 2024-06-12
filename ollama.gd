extends Node

var url: String = "http://eddge-sp-ai1:11434/api/generate"
var headers = ["Content-Type: application/json"]
var model: String = "llama3"
var instruction: String = "You are a knowledgeable and concise Godot expert, providing focused guidance on using the game engine effectively."
var conversation = []
var Httprequest: HTTPRequest
var body = JSON.new().stringify({"prompt": "hello", "model": model, "stream":true})

## Called when the node enters the scene tree for the first time.
#func _ready():
	#Httprequest = HTTPRequest.new()
	#add_child(Httprequest)
	#var body = JSON.new().stringify({"prompt": "hello", "model": model, "stream":true})
	#Httprequest.request_completed.connect(_on_request_completed)
	#var error = Httprequest.request(url,headers,HTTPClient.METHOD_POST, body)
	#print(error)
	#
	#pass # Replace with function body.
#
#func _on_request_completed(result, response_code, headers, body):
	#print("hello")
	#var json = JSON.parse_string(body.get_string_from_utf8())
	#print(json)
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	
func _ready():
	var err = 0
	var http = HTTPClient.new() # Create the Client.
	var response :String
	var json := JSON.new()

	

	err = http.connect_to_host("eddge-sp-ai1", 11434) # Connect to host/port.
	assert(err == OK) # Make sure connection is OK.

	# Wait until resolved and connected.
	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		print("Connecting...")
		await get_tree().process_frame

	assert(http.get_status() == HTTPClient.STATUS_CONNECTED) # Check if the connection was made successfully.
	
	var headers = [
		"User-Agent: Pirulo/1.0 (Godot)",
		"Accept: */*"
	]

	#err = http.request(HTTPClient.METHOD_GET, "/api/generate", headers) # Request a page from the site (this one was chunked..)
	err = http.request(HTTPClient.METHOD_POST,url,headers, body)
	assert(err == OK) # Make sure all is OK.

	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		# Keep polling for as long as the request is being processed.
		http.poll()
		print("Requesting...")
		await get_tree().process_frame

	assert(http.get_status() == HTTPClient.STATUS_BODY or http.get_status() == HTTPClient.STATUS_CONNECTED) # Make sure request finished well.

	print("response? ", http.has_response())


	#THE NEXT PART 
	if http.has_response():
		# If there is a response...

		headers = http.get_response_headers_as_dictionary() # Get response headers.
		print("code: ", http.get_response_code()) # Show response code.
		print("**headers:\\n", headers) # Show headers.

		# Getting the HTTP Body

		if http.is_response_chunked():
			# Does it use chunks?
			print("Response is Chunked!")
		else:
			# Or just plain Content-Length
			var bl = http.get_response_body_length()
			print("Response Length: ", bl)

		# This method works for both anyway

		var rb = PackedByteArray() # Array that will hold the data.

		while http.get_status() == HTTPClient.STATUS_BODY:
			# While there is body left to be read
			http.poll()
			# Get a chunk.
			var chunk = http.read_response_body_chunk()
			if chunk.size() == 0:
				await get_tree().process_frame
			else:
				rb = rb + chunk # Append to read buffer.
				json.parse(chunk.get_string_from_ascii())
				var rresponse = json.get_data()
				print("RESPONSE: ", rresponse["response"])
				
				
				
		# Done!

		print("bytes got: ", rb.size())
		var text = rb.get_string_from_ascii()
		print("Text: ", text)

	#quit()
