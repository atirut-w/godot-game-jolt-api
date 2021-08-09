extends Node

var game_id := ""
var game_key := ""

var _username := ""
var _token := ""
var is_authenticated := false

const base_url := "api.gamejolt.com/api/game"
var api_version = api_versions.v1_2
const api_versions = {
	v1_2 = "v1_2"
}

## Bool return indicate whether the auth is successful or not.
func authenticate(username: String, token: String) -> bool:
	require_game_id()
	var response = yield(_send_api_request("users/auth/", {game_id = game_id, username = username, user_token = token}), "completed")
	if response:
		_username = username
		_token = token
		is_authenticated = true
		return true
	else:
		_username = ""
		_token = ""
		is_authenticated = false
		return false

func require_game_id() -> void:
	assert(game_id != "", "game ID is not set")

func _send_api_request(endpoint: String, queries := {}) -> Dictionary:
	assert(game_key != "", "game key is not set") # This is not in it's own function because every API call have to be signed.
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
