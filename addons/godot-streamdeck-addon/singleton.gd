extends Node

## StreamDeck Integration Singleton
##
## This singleton manages WebSocket communication with Elgato StreamDeck software.
## It handles button press events and translates them into application actions like
## costume changes, signal emissions, and scene management.

## Button actions supported by the StreamDeck plugin
const ButtonAction = {
	EMIT_SIGNAL = "games.boyne.godot.emitsignal",
	SWITCH_SCENE = "games.boyne.godot.switchscene",
	RELOAD_SCENE = "games.boyne.godot.reloadscene",
}

## Button events from StreamDeck hardware
const ButtonEvent = {
	KEY_UP = "keyUp",
	KEY_DOWN = "keyDown"
}

## Emitted when a StreamDeck button is released
signal on_key_up
## Emitted when a StreamDeck button is pressed
signal on_key_down

const PLUGIN_NAME = "games.boyne.godot.sdPlugin"
const WEBSOCKET_URL = "127.0.0.1:%s/ws"

var _socket := WebSocketPeer.new()
var _config := ConfigFile.new()
var _is_connected := false

## Initialize StreamDeck connection if enabled in settings
func _ready() -> void:
	_check_and_connect()

## Check settings and connect/disconnect as needed
func _check_and_connect() -> void:
	var should_connect = Saving.settings.get("useStreamDeck", false)
	
	if should_connect and not _is_connected:
		_load_config(_get_config_path())
		_socket.connect_to_url(_get_websocket_url())
		_is_connected = true
		set_process(true)
	elif not should_connect and _is_connected:
		_socket.close()
		_is_connected = false
		set_process(false)
	
## Process WebSocket communication each frame
## Handles incoming button events and routes them to appropriate actions
func _process(delta) -> void:
	if not _is_connected:
		return
		
	# Check if setting was changed and we need to disconnect
	if not Saving.settings.get("useStreamDeck", false):
		_check_and_connect()
		return
	_socket.poll()
	
	var state = _socket.get_ready_state()
	
	match state:
		WebSocketPeer.STATE_OPEN:
			while _socket.get_available_packet_count():
				var data = JSON.parse_string(_socket.get_packet().get_string_from_utf8())
				
				if !(data.event == ButtonEvent.KEY_DOWN || data.event == ButtonEvent.KEY_UP):
					return
				
				if data != null && data.has("action") && data.has("payload"):
					match data.action:
						ButtonAction.EMIT_SIGNAL:
							var signalInput = ""
							
							if data.payload.settings.has("signalInput"):
								signalInput = data.payload.settings.signalInput
							
							match data.event:
								ButtonEvent.KEY_UP:
									on_key_up.emit(signalInput)
								ButtonEvent.KEY_DOWN:
									on_key_down.emit(signalInput)
						ButtonAction.SWITCH_SCENE:
							if data.payload.settings.has("scenePath"):
								var scenePath = data.payload.settings.scenePath
								get_tree().change_scene_to_file(scenePath)
						ButtonAction.RELOAD_SCENE:
							get_tree().reload_current_scene()
		WebSocketPeer.STATE_CLOSING:
			pass
		WebSocketPeer.STATE_CLOSED:
			set_process(false)

## Get the WebSocket URL with port from config
## Returns: String URL for WebSocket connection
func _get_websocket_url() -> String:
	return WEBSOCKET_URL % _config.get_value("bridge", "port", "8080")
	
## Get the platform-specific path to StreamDeck plugin config
## Returns: String path to plugin.ini file
func _get_config_path() -> String:
	match OS.get_name():
		"Windows":
			return "%s/Elgato/StreamDeck/Plugins/%s/plugin.ini" % [OS.get_config_dir(), PLUGIN_NAME]
		"macOS":
			return "%s/com.elgato.StreamDeck/Plugins/%s/plugin.ini" % [OS.get_config_dir(), PLUGIN_NAME]
	return ""

## Load configuration from StreamDeck plugin directory
## @param path: String path to the config file
func _load_config(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		_config.parse(file.get_as_text())
		file.close()

## Force reconnection check - called when settings change
func refresh_connection() -> void:
	_check_and_connect()
