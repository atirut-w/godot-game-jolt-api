extends Node

var game_id := ""
var game_key := ""

const base_url := "api.gamejolt.com/api/game"
var api_version = api_versions.v1_2
const api_versions = {
	v1_2 = "v1_2"
}

func _send_api_request(endpoint: String, queries := {}) -> Dictionary:
	# Any double slashes after HTTP:// can ruin the signature.
	var url = "https://" + ("%s/%s/%s" % [base_url, api_version, endpoint]).replace("//", "/")
	
	# Add queries
	url += "?"
	for key in queries:
		url += "&%s=%s" % [key, queries[key]]
	url += "&signature=" + (url + game_key).md5_text() # Add signature.
	
	var body = yield(_async_http(url), "completed")
	var response = JSON.parse(body).result.response
	
	if response.success == "true":
		return response
	else:
		push_error(response.message)
		return null

func _async_http(url: String) -> String:
	var http_req = HTTPRequest.new()
	add_child(http_req)
	
	var error = http_req.request(url)
	if error != OK:
		push_error("An error occured whilst making a HTTP request. Error code: %s" % [error])
		remove_child(http_req)
		yield(get_tree(), "idle_frame")
		return null
	else:
		var response = yield(http_req, "request_completed")
		remove_child(http_req)
		return response[3].get_string_from_utf8()
