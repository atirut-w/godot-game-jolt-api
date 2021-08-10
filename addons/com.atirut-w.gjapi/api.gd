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

func authenticate(username: String, token: String) -> bool:
	if not _check_id():
		yield(get_tree(), "idle_frame")
		return false
	var response = yield(_send_api_request("users/auth/", {username = username, user_token = token}), "completed")
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

func grant_trophy(id: int) -> bool:
	if not _check_id():
		yield(get_tree(), "idle_frame")
		return false
	if not _check_authenticated():
		yield(get_tree(), "idle_frame")
		return false
	var response = yield(_send_api_request("trophies/add-achieved/", {username = _username, user_token = _token, trophy_id = id}), "completed")
	if response:
		return true
	else:
		return false

func revoke_trophy(id: int) -> bool:
	if not _check_id():
		yield(get_tree(), "idle_frame")
		return false
	if not _check_authenticated():
		yield(get_tree(), "idle_frame")
		return false
	var response = yield(_send_api_request("trophies/remove-achieved/", {username = _username, user_token = _token, trophy_id = id}), "completed")
	if response:
		return true
	else:
		return false

func _check_id() -> bool:
	if game_id != "":
		return true
	else:
		push_error("Game ID is not set. Please set it before using this function.")
		return false

func _check_key() -> bool:
	if game_key != "":
		return true
	else:
		push_error("Game ID is not set. Please set it before using this function.")
		return false

func _check_authenticated() -> bool:
	if is_authenticated:
		return true
	else:
		push_error("Not authenticated. Please authenticate before using this function.")
		return false

func _send_api_request(endpoint: String, queries := {}) -> Dictionary:
	if not _check_key():
		yield(get_tree(), "idle_frame")
		return false
	# Any double slashes after HTTP:// can ruin the signature.
	var url = "https://" + ("%s/%s/%s" % [base_url, api_version, endpoint]).replace("//", "/")
	
	# Add queries
	url += "?"
	queries["game_id"] = game_id
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
