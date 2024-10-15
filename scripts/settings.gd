extends Node

var songs: Dictionary = {
	"light": "ABD",
	"fly": "BBAA",
	"damage": "CDBA",
	"home": "AACCA",
	"mushroom": "ACAB",
	"ladder": "DDB",
	"boss": "DCBBDCDAC",
	"birds": "ABCBCD"
}

var songs_durations: Dictionary = {
	"light": 20,
	"mushroom": 10
}

var musics = {
	"shroom": preload("res://sounds/Son-ouverture champignon.mp3"),
	"scolo": preload("res://sounds/Scolopandre_V2.mp3"),
	"teleport": preload("res://sounds/Musique-Teleportation.mp3")
}
