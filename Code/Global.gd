extends Node

var childName = "Name"

var cameramove = true

var grafspot = 0

var istrynt : Array
var istryntg : Array

var posiblequests = [[0,"Steal back wheat seeds \n",false,false],
[1,"Return wheat seeds to wolf \n",false,false],
[2,"Steal back flour \n",false,false],
[3,"Return flour to wolf \n",false,false],
[4,"Steal back bread \n",false,false],
[5,"Return bread to wolf \n",false,false]]
var quests
var questnr = []
var currentquest = 0
var questheight = 80

var health = 10;
var scrolls = []
var enemy = []

var day = 1

var camerapos = null

func AddName(Name):
	Global.childName = Name


