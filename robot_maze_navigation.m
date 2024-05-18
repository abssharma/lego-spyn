brick = Brick('ioType','wifi','wfAddr','127.0.0.1','wfPort',5555,'wfSN','0016533dbaf5')
brick.SetColorMode(3, 2);
%Setting static variables%
auto_Speed_Forward = -80;
auto_Clutch_Forward = -100;
auto_Speed_Backwards = 70;
auto_Clutch_Backwards = 100;
manual_Speed_Forward = 40; %These variables used for motor control
claw_Open = -40;
claw_Close = 40; %Variables used to control claw operating speed
global key
InitKeyboard(); %Initializes keyboard for user input
%----Setting more necessary variables-----%
%Setting boolean statements%
manualControl = false; %Manual boolean
blueFound = false; %Pickup Blue
yellowFound = false; %Dropoff Yellow
openClaw = false;
state = 0; %Default case state
while 1
bump = brick.TouchPressed(1);
pause(0.1);
%automatic control%
if(manualControl == false)
switch state
%Test case%
case -1
brick.SetColorMode(3,2);
color = brick.ColorCode(3);
%Auto forward movement until sensors get triggered
case 0
brick.MoveMotor('B', auto_Clutch_Forward);
pause(.75);
brick.MoveMotor('A', auto_Speed_Forward);
%Calculate distance to nearest object
distance = brick.UltrasonicDist(4);
if(distance > 55)
pause(2.5);
disp("No Right wall detected, turning right");
brick.StopAllMotors('Brake');
timerVal = tic; %Start timer
state = 4;
end
%Auto color sensor
color = brick.ColorCode(3);
if(color == 5) %Color Red is Detected
disp("Red Detected: Pausing");
timerVal = tic;
state = 3;
end
if(color == 2 && blueFound == false) %Color blue detected
blueFound = true;
brick.StopAllMotors();
disp("Blue detected: Switching to Manual Control");
manualControl = true;
end
if(color == 4 && blueFound == true) %Color yellow detected
brick.StopAllMotors();
disp("Yellow Detected: Switching to Manual Control");
manualControl = true;
end
%Auto touch sensor
if bump %Front touch sensor contact
brick.StopMotor('A');
disp('Front Touch Sensor Hit Moving to Case 1');
state = 1;
timerVal = tic; %Start Timer
end
%Auto claw handler
if(blueFound == true && openClaw == true)
brick.MoveMotor('C', claw_Close);
end
if(color == 6) %Auto color handler
color = brick.ColorCode(3);
if(color == 5)
disp("Red Detected: Pausing");
timerVal = tic;
state = 3;
end
end
%Auto Case 1 Bumped, Reverse
case 1
brick.MoveMotor('B', -100);
pause(.5);
brick.MoveMotor('A', auto_Speed_Backwards);
if(toc(timerVal) > 5) % State transition after 5 seconds
disp("Turning left");
if(blueFound == true)
state = 6;
else
state = 2;
end
timerVal = tic; % Resets timer
end
%Auto Case 2 Done Reversing, Turn left 90 deg
case 2
brick.MoveMotor('B', 100);
pause(.5);
brick.MoveMotor('A', -60);
if(toc(timerVal) > 3.67) %State transition after 3.67 seconds
brick.StopMotor('A');
timerVal = tic; %Reset timer
state = 0;
end
% Auto case 3 Light Sensor Red, stop for a time
case 3
brick.StopMotor('A');
pause(3);
brick.MoveMotor('A', auto_Speed_Forward);
pause(2);
state = 0;
%Auto case 4 turn right ultrasonic sensor
case 4
brick.MoveMotor('B', 100);
pause(.5);
brick.MoveMotor('A', 60);
if(toc(timerVal)> 3.70) %State transition after 3.7 second
timerVal = tic;
state = 5;
end
case 5 %Auto case continuation of right turn to provide buffer for ultrasonic
sensor
brick.StopMotor('B','Brake');
brick.StopMotor('A','Brake');
brick.MoveMotor('B', auto_Clutch_Forward);
pause(.75);
brick.MoveMotor('A', auto_Speed_Forward);
timerVal = tic;
while toc(timerVal) < 9
color = brick.ColorCode(3);
if(color == 5) %Color Red is Detected
disp("Red Detected: Pausing");
brick.StopAllMotors('Brake');
pause(3);
brick.MoveMotor('B', auto_Clutch_Forward);
pause(.75);
brick.MoveMotor('A', auto_Speed_Forward);
pause(1);
end
end
state = 0;
%Auto Case 6 Done Reversing, Turn left 90 deg with
%passenger
case 6
brick.MoveMotor('B', 100);
pause(.5);
brick.MoveMotor('A', -64);
if(toc(timerVal) > 3.69) %State transition after 3.69 seconds
brick.StopMotor('A');
timerVal = tic; %Reset timer
state = 0;
end
end