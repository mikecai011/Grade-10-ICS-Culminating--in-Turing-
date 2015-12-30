import GUI in "%oot/lib/GUI"
var hourcheck : array 0 .. 23 of string
var minutecheck : array 0 .. 59 of string
var secondcheck : array 0 .. 59 of string
for z : 0 .. 9
    hourcheck (z) := "0" + intstr (z)
    minutecheck (z) := "0" + intstr (z)
    secondcheck (z) := "0" + intstr (z)
end for
for y : 10 .. 23
    hourcheck (y) := intstr (y)
end for
for x : 10 .. 59
    minutecheck (x) := intstr (x)
    secondcheck (x) := intstr (x)
end for
%-------------------------------------------------------------------------------------- The Clock --------------------------------------------------------------------------------------
%---------------------------------------------------------- Pre-declare variables
var clockexit : string
var settingexit : string
var alarmtime : string
var default : boolean
var alarmstate : boolean
var alarmhour, alarmminute, alarmsecond : int
var alarmmusic, chosenalarmmusic : string
var currentalarmtime, currentmusic : string
var soundstate : boolean
var stopalarmstate : boolean := true
var on : int := Pic.FileNew ("on.jpg")
var off : int := Pic.FileNew ("off.jpg")
var hourstate, minutestate, secondstate : boolean
%-------------------------------------------------------------------- All procedures for the clock ------------------------------------------------------------
proc stopmusic
    stopalarmstate := true
    Music.PlayFileStop
end stopmusic
proc Quit
    stopalarmstate := true
    Music.PlayFileStop
    delay (1000)
    clockexit := "yes"
end Quit
proc nothing
end nothing
proc nothing2 (text : string)
end nothing2
%------setting procedures
proc turnon
    GUI.Enable (alarmhour)
    GUI.Enable (alarmminute)
    GUI.Enable (alarmsecond)
    alarmstate := true
end turnon
proc turnoff
    GUI.Disable (alarmhour)
    GUI.Disable (alarmminute)
    GUI.Disable (alarmsecond)
    alarmstate := false
end turnoff
proc soundon
    soundstate := true
end soundon
proc soundoff
    soundstate := false
end soundoff
proc Quitsetting
    settingexit := "yes"
end Quitsetting
process timeup
    View.Set ("offscreenonly")
    var hugefont : int := Font.New ("Arial:65:bold")
    loop
	exit when stopalarmstate = true
	Draw.FillBox (25, 158, 375, 224, white)     % instead of cls
	View.Update
	delay (525)
	exit when stopalarmstate = true
	Font.Draw ("TIME UP", 25, 160, hugefont, red)
	View.Update
	exit when stopalarmstate = true
	delay (1000)
    end loop
    View.Set ("nooffscreenonly")
    Draw.FillBox (25, 158, 375, 224, white)     % instead of cls
end timeup
proc setting
    var settingwindow := Window.Open ("graphics:400,680;nobuttonbar;title:Setting;offscreenonly;position:top,left")
    colourback (grey)
    cls
    var file : string
    var font2 : int := Font.New ("Arial:20:bold")
    var font3 : int := Font.New ("Arial:12")
    var font4 : int := Font.New ("Arial:9")
    var fontdotes : int := Font.New ("Arial:12:bold")
    %-------- Alarm time setting
    if alarmstate = true then
	currentalarmtime := "Current Alarm Time:  " + alarmtime
    else
	currentalarmtime := "Current Alarm Time:  " + "N/A"
    end if
    Font.Draw ("Alarm Time:", 1, maxy - 190, font2, black)
    Font.Draw ("Change Alarm Time:", 1, maxy - 226, font3, black)
    Font.Draw (":", 176, maxy - 226, fontdotes, black)
    Font.Draw (":", 212, maxy - 226, fontdotes, black)
    Font.Draw (currentalarmtime, 1, maxy - 270, font3, green)     %shows current alarm time
    alarmhour := GUI.CreateTextFieldFull (150, maxy - 230, 20, "", nothing2, GUI.INDENT, font3, 0)
    alarmminute := GUI.CreateTextFieldFull (186, maxy - 230, 20, "", nothing2, GUI.INDENT, font3, 0)
    alarmsecond := GUI.CreateTextFieldFull (222, maxy - 230, 20, "", nothing2, GUI.INDENT, font3, 0)
    if alarmstate = false then
	GUI.Disable (alarmhour)
	GUI.Disable (alarmminute)
	GUI.Disable (alarmsecond)
    end if
    var alarmhourtime, alarmminutetime, alarmsecondtime : string
    %-------- Alarm On/Off Check box
    Font.Draw ("Alarm:", 1, maxy - 40, font2, black)
    if alarmstate = true then
	var alarmon := GUI.CreatePictureRadioButton (10, maxy - 160, on, 0, turnon)
	var alarmoff := GUI.CreatePictureRadioButton (200, maxy - 160, off, alarmon, turnoff)
    else
	var alarmoff := GUI.CreatePictureRadioButton (200, maxy - 160, off, 0, turnoff)
	var alarmon := GUI.CreatePictureRadioButton (10, maxy - 160, on, alarmoff, turnon)
    end if
    %-------- Alarm music selecting
    currentmusic := "Current Music:  " + alarmmusic
    Font.Draw ("Alarm Music", 1, maxy - 330, font2, black)
    Font.Draw ("File Name:", 1, maxy - 367, font3, black)
    Font.Draw ("* Filename extension is needed and only supports .wav .mp3 .midi", 1, maxy - 400, font4, yellow)
    Font.Draw (currentmusic, 1, maxy - 420, font3, green)     %shows current music using
    var alarmmusicbox : int := GUI.CreateTextFieldFull (80, maxy - 370, 300, "", nothing2, GUI.INDENT, 0, GUI.ANY)
    %-------- Setting quick button
    var quitbutton : int := GUI.CreateButton (maxx - 60, 1, 0, "Quit", Quitsetting)
    %-------- Sound ON/OFF
    Font.Draw ("Sound:", 1, maxy - 480, font2, black)
    if soundstate = true then
	var soundonbtn := GUI.CreatePictureRadioButton (10, maxy - 600, on, 0, soundon)
	var soundoffbtn := GUI.CreatePictureRadioButton (200, maxy - 600, off, soundonbtn, soundoff)
    else
	var soundoffbtn := GUI.CreatePictureRadioButton (200, maxy - 600, off, 0, turnoff)
	var soundonbtn := GUI.CreatePictureRadioButton (10, maxy - 600, on, soundoffbtn, soundon)
    end if
    %--------------- Running
    loop
	exit when settingexit not= ""
	%---- Showing alarm state
	if alarmstate = true then
	    Draw.FillBox (150, maxy - 37, 170, maxy - 25, grey) % instead of cls
	    Font.Draw ("On", 150, maxy - 37, font3, green)
	else
	    Draw.FillBox (150, maxy - 37, 170, maxy - 25, grey) % instead of cls
	    Font.Draw ("Off", 150, maxy - 37, font3, red)
	end if

	%---- Showing sound state
	if soundstate = true then
	    Draw.FillBox (149, maxy - 477, 170, maxy - 465, grey) % instead of cls
	    Font.Draw ("On", 149, maxy - 477, font3, green)
	else
	    Draw.FillBox (149, maxy - 477, 170, maxy - 465, grey) % instead of cls
	    Font.Draw ("Off", 149, maxy - 477, font3, red)
	end if

	%---- Getting alarm time
	alarmhourtime := GUI.GetText (alarmhour)
	alarmminutetime := GUI.GetText (alarmminute)
	alarmsecondtime := GUI.GetText (alarmsecond)

	%---- Correct the alarm time to two digits only
	if length (alarmhourtime) > 2 then
	    alarmhourtime := alarmhourtime (* -1 .. *)
	    GUI.SetText (alarmhour, alarmhourtime)
	end if
	if length (alarmminutetime) > 2 then
	    alarmminutetime := alarmminutetime (* -1 .. *)
	    GUI.SetText (alarmminute, alarmminutetime)
	end if
	if length (alarmsecondtime) > 2 then
	    alarmsecondtime := alarmsecondtime (* -1 .. *)
	    GUI.SetText (alarmsecond, alarmsecondtime)
	end if

	%---- Checking alarm time format
	for w : 0 .. 23
	    if alarmhourtime = hourcheck (w) then
		hourstate := true
	    else
		hourstate := false
	    end if
	    exit when hourstate = true
	end for
	for v : 0 .. 59
	    if alarmminutetime = minutecheck (v) then
		minutestate := true
	    else
		minutestate := false
	    end if
	    exit when minutestate = true
	end for
	for u : 0 .. 59
	    if alarmsecondtime = secondcheck (u) then
		secondstate := true
	    else
		secondstate := false
	    end if
	    exit when secondstate = true
	end for
	if alarmhourtime = "" and alarmminutetime = "" and alarmsecondtime = "" then
	    Draw.FillBox (150, maxy - 245, 251, maxy - 237, grey)      % instead of cls
	else
	    if hourstate not= true or minutestate not= true or secondstate not= true then
		Draw.FillBox (150, maxy - 245, 251, maxy - 237, grey)      % instead of cls
		Font.Draw ("Invalid Alarm Time", 150, maxy - 245, font4, red)
	    else
		Draw.FillBox (150, maxy - 245, 251, maxy - 237, grey)     % instead of cls
		Font.Draw ("Valid Alarm Time", 150, maxy - 245, font4, green)
	    end if
	end if

	%---- Getting alarm music
	chosenalarmmusic := GUI.GetText (alarmmusicbox)
	Draw.FillBox (80, maxy - 386, 200, maxy - 376, grey)             % instead of cls
	if chosenalarmmusic not= "" then
	    if File.Exists (chosenalarmmusic) then
		Font.Draw ("File exits", 80, maxy - 385, font4, green)
	    else
		Font.Draw ("File is not found", 80, maxy - 385, font4, red)
	    end if
	end if
	View.Update
	exit when GUI.ProcessEvent or settingexit not= ""
    end loop
    if chosenalarmmusic not= "" and File.Exists (chosenalarmmusic) then
	alarmmusic := chosenalarmmusic
    end if
    if alarmstate = true and hourstate = true and minutestate = true and secondstate = true then
	alarmtime := alarmhourtime + ":" + alarmminutetime + ":" + alarmsecondtime
    end if
    cls
    View.Set ("nooffscreenonly")
    default := false
    Window.Hide (settingwindow)
end setting
%-------------------------------------------------------------------- All procedures for the clock------------------------------------------------------------
proc theclock
    var clockwindow : int := Window.Open ("graphics:400;680,nobuttonbar,position:top;right,title: The Clock")
    %----------------------------------------------------------Clock variables
    var year, month, day, dayofweek, hour, minute, seconds : int
    var monthstr, daystr, hourstr, minutestr, secondsstr : string
    var clockface : int := Pic.FileNew ("clockface.jpg")
    var clockx, clocky : int
    clockx := ceil (maxx / 2)
    clocky := ceil (maxy / 2) + 110
    var font1 : int := Font.New ("Lucida Handwriting:20:bold")
    var ct, dt : string     %ct stands for current time; dt stands for date
    %----------------------------------------------------------Clock Menu variables
    var firstmenu : int
    var item : array 1 .. 3 of int
    var name : array 1 .. 3 of string := init ("Quit", "---", "Setting")
    %----------------------------------------------------------Exit variables
    clockexit := ""
    %-------- Check if it is at default setting
    if default then
	alarmstate := false
	alarmtime := "00:00:00"
	alarmmusic := "alarm.mp3"
	soundstate := true
    end if
    %-----------------------------------------------------------------------------Create Menue
    loop
	exit when clockexit not= ""
	firstmenu := GUI.CreateMenu ("Menu")
	item (1) := GUI.CreateMenuItem (name (1), Quit)
	item (2) := GUI.CreateMenuItem (name (2), nothing)
	item (3) := GUI.CreateMenuItem (name (3), setting)
	loop
	    Window.Select (clockwindow)
	    View.Set ("offscreenonly")
	    %------------------------ Settingwindow exit variable
	    settingexit := ""
	    %---------------------------------------Get the time from computer
	    Time.SecParts (Time.Sec, year, month, day, dayofweek, hour, minute, seconds)
	    var days : array 1 .. 7 of string (10) := init ("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
	    %----------------------------------Adjust the digital clock format
	    if month < 10 then
		monthstr := "0" + intstr (month)
	    else
		monthstr := intstr (month)
	    end if
	    if day < 10 then
		daystr := "0" + intstr (day)
	    else
		daystr := intstr (day)
	    end if
	    if hour < 10 then
		hourstr := "0" + intstr (hour)
	    else
		hourstr := intstr (hour)
	    end if
	    if minute < 10 then
		minutestr := "0" + intstr (minute)
	    else
		minutestr := intstr (minute)
	    end if
	    if seconds < 10 then
		secondsstr := "0" + intstr (seconds)
	    else
		secondsstr := intstr (seconds)
	    end if
	    ct := hourstr + ":" + minutestr + ":" + secondsstr
	    dt := daystr + "/" + monthstr + "/" + intstr (year)
	    %----------------------------------------------------------------------------------------------------------------------Draw clock
	    Pic.Draw (clockface, ceil ((maxx - 400) / 2), ceil ((maxy - 400) / 2) + 110, 0)
	    % second hand:
	    drawline (clockx, clocky, round (clockx + (160 * cosd ((360 - (seconds * 6)) + 90))), round (clocky + (160 * sind (360 - (seconds * 6) + 90))), black)
	    drawline (clockx, clocky, round (clockx + (30 * cosd ((360 - (seconds * 6)) + 90 + 180))), round (clocky + (30 * sind (360 - (seconds * 6) + 90 + 180))), black)
	    % minute hand:
	    Draw.ThickLine (clockx, clocky, round (clockx + (150 * cosd ((360 - (minute * 6 + seconds / 10)) + 90))), round (clocky + (150 * sind (360 - (minute * 6 + seconds / 10) + 90))), 3,
		black)
	    Draw.ThickLine (clockx, clocky, round (clockx + (13 * cosd ((360 - (minute * 6 + seconds / 10)) + 90 + 180))), round (clocky + (13 * sind (360 - (minute * 6 + seconds / 10) + 90 +
		180))),
		3,
		black)
	    % hour hand:
	    Draw.ThickLine (clockx, clocky, round (clockx + (100 * cosd ((360 - ((hour * 30 + minute / 2))) + 90))), round (clocky + (100 * sind (360 - (hour * 30 + minute / 2) + 90))), 3, black)
	    Draw.ThickLine (clockx, clocky, round (clockx + (13 * cosd ((360 - ((hour * 30 + minute / 2))) + 90 + 180))), round (clocky + (13 * sind (360 - (hour * 30 + minute / 2) + 90 + 180))),
		3,
		black)
	    %----------------------------------------------------------------------------------------------------------------------Draw digital clock
	    Draw.FillBox (1, 1, 180, 124, white)     % instead of cls
	    Font.Draw (ct, 1, 75, font1, green)
	    Font.Draw (days (dayofweek), 1, 45, font1, green)
	    Font.Draw (dt, 1, 15, font1, green)
	    %-----------------------------------------------------------------------------Create stop alarm button
	    var Stopbutton : int := GUI.CreateButtonFull (maxx - 120, 1, 0, "STOP ALARM", stopmusic, 120, "^F", true)
	    %-----------------------------------------------------------------------------Check alarm time
	    if ct = alarmtime and alarmstate = true and stopalarmstate = true then %stopalarmstate here is used to prevent multiple timeup
		stopalarmstate := false
		fork timeup
		if soundstate = true then
		    Music.PlayFileLoop (alarmmusic)
		end if
	    end if
	    %-------------------------------
	    View.Update
	    View.Set ("nooffscreenonly")
	    exit when GUI.ProcessEvent or clockexit not= ""
	end loop
    end loop
    %----------------------------------------Quit program
    Window.Close (clockwindow)
end theclock
%--------------------------------------------------------------------------------- The Clock ---------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------Setting everything to default
default := true
theclock
