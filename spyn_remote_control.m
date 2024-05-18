global key
InitKeyboard(); %Initializes keyboard for user input
%Enters into Manual Control
if(key == 'm')
manualControl = true;
brick.StopMotor(‘A');
%MANUAL CONTROL
if(manualControl == true)
switch key
case 'space'
brick.StopMotor('A', 'Brake');
brick.StopMotor('B', 'Brake');
case 'downarrow'
brick.MoveMotor('B',-100);
pause(.6)
brick.MoveMotor('A',60);
case 'uparrow'
brick.MoveMotor('B',-100);
pause(.6)
brick.MoveMotor('A',-60);
case 'leftarrow'
brick.MoveMotor('B',100);
pause(.6)
brick.MoveMotor('A',-50);
case 'rightarrow'
brick.MoveMotor('B',100);
pause(.6)
brick.MoveMotor('A',50);
case 'o' %Stops Claw Motor and resets
brick.StopMotor('C');
case 'i'
brick.MoveMotor('C', claw_Close);
case 'p'
brick.MoveMotor('C', claw_Open);
openClaw = true;
case 'a' %Switches back to automatic control
manualControl = false;
end
end
if(key == '1') %Quit the program
brick.StopAllMotors();
break;
end
end
CloseKeyboard();