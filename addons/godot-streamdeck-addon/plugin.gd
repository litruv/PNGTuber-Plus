@tool
extends EditorPlugin

## StreamDeck Editor Plugin
## 
## This plugin integrates Elgato StreamDeck hardware with the PNGTuber application.
## It registers the ElgatoStreamDeck singleton for WebSocket communication with StreamDeck software.

const AUTOLOAD_NAME = "ElgatoStreamDeck"

## Called when the plugin enters the editor tree
## Registers the StreamDeck singleton autoload
func _enter_tree():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/godot-streamdeck-addon/singleton.gd")

## Called when the plugin exits the editor tree  
## Removes the StreamDeck singleton autoload
func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_NAME)
