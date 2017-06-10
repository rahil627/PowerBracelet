package powerbracelet;

@:enum
abstract ButtonState(Int) {
	var On = 0;
	var Off = 1;
	var Pressed = 2;
	var Released = 3;
}