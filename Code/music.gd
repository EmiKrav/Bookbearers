extends Node

var music1 = load("res://Bookbearers/Sounds/orchestra-fantasy-111168.mp3")
var music2 = load("res://Bookbearers/Sounds/atmosphere-mystic-fantasy-orchestral-music-335263.mp3")
var music3 = load("res://Bookbearers/Sounds/short-epic-opener-335424.mp3")
var music4 = load("res://Bookbearers/Sounds/cinematic-fairy-tale-story-main-8697.mp3")
var music5 = load("res://Bookbearers/Sounds/dramatic-soundtrack-epic-cinematic-trailer-background-intro-theme-263131.mp3")
var music6 = load("res://Bookbearers/Sounds/fantasy-music-overture-orchestral-amp-choir-113620.mp3")
var music7 = load("res://Bookbearers/Sounds/sad-documentary.mp3")


@onready var sound = [load("res://Bookbearers/Sounds/sword-cut-type-1-230552.mp3"), 
load("res://Bookbearers/Sounds/creepy-fall-329227.mp3"),
load("res://Bookbearers/Sounds/running-on-dry-leaves-295847.mp3")
]

@onready var audio = load("res://Bookbearers/Scenes/audio.tscn")

var sk = 0
var Mmuted = false
var Smuted = false
var MV = -20
var SV = -20

func  play1():
	if Mmuted == false:
		$Muzika.stream = music1
		$Muzika.volume_db = MV - 20;
		$Muzika.play()
	sk = 1
	
func  play2():
	if Mmuted == false:
		$Muzika.stream = music2
		$Muzika.volume_db = MV;
		$Muzika.play()
	sk = 2
func  play3():
	if Mmuted == false:
		$Muzika.stream = music3
		$Muzika.volume_db = MV - 40;
		$Muzika.play()
	sk = 3
func  play4():
	if Mmuted == false:
		$Muzika.stream = music4
		$Muzika.volume_db = MV - 40;
		$Muzika.play()
	sk = 4
func  play5():
	if Mmuted == false:
		$Muzika.stream = music5
		$Muzika.volume_db = MV - 30;
		$Muzika.play()
	sk = 5
func  play6():
	if Mmuted == false:
		$Muzika.stream = music6
		$Muzika.volume_db = MV - 30;
		$Muzika.play()
	sk = 6
func  play7():
	if Mmuted == false:
		$Muzika.stream = music7
		$Muzika.volume_db = MV - 30;
		$Muzika.play()
	sk = 7
	
func MusicStop():
	$Muzika.stream_paused = true
	
func MusicResume():
	$Muzika.stream_paused = false
	
func SoundStop():
	$Sound.stream_paused = true

func current():
	return sk

func MusicChangeVolume(volume):
	if volume > 0:
		$Muzika.volume_db += 2
	else:
		$Muzika.volume_db -= 2
	
func SoundChangeVolume(volume):
	if volume > 0:
		$Sound.volume_db += 2
	else:
		$Sound.volume_db -= 2

func Volume():
	return $Sound.volume_db
func MusicReset():
	$Muzika.volume_db = -20
func SoundReset():
	$Sound.volume_db = -20


func  playsoundwalking():
	if Smuted == false:
		sound[2].loop = true
		$Sound.stream = sound[2]
		$Sound.volume_db = SV - 20;
		$Sound.play()

func  playsoundattacking():
	if Smuted == false:
		sound[0].loop = false
		$Sound.stream = sound[0]
		$Sound.volume_db = SV - 20;
		$Sound.play()
	
