package powerbracelet;


class Input {
	
	//_____________________________________________________
	// Keyboard
	public static var keyboard(get,null) : KeyboardInput;

	static function get_keyboard() : KeyboardInput{
		if(keyboard == null){
			keyboard = new KeyboardInput();
		}

		return keyboard;
	}

	//_____________________________________________________
	// Mouse
	public static var mouse(get,null) : MouseInput;

	static function get_mouse() : MouseInput{
		if(mouse == null){
			mouse = new MouseInput();
		}

		return mouse;
	}

	//_____________________________________________________
	// Touch
	public static var touch(get,null) : TouchInput;

	static function get_touch() : TouchInput{
		if(touch == null){
			touch = new TouchInput();
		}

		return touch;
	}

	//_____________________________________________________
	// Sensor
	public static var sensor(get,null) : SensorInput;

	static function get_sensor() : SensorInput{
		if(sensor == null){
			sensor = new SensorInput();
		}

		return sensor;
	}


	//_____________________________________________________

	//_____________________________________________________
	// Gamepad
	public static var gamepad(get,null) : GamepadInput;

	static function get_gamepad() : GamepadInput{
		if(gamepad == null){
			gamepad = new GamepadInput();
		}

		return gamepad;
	}

	//_____________________________________________________


	//@:allow(windfish.Engine)
	public static function update(dt:Float){
		if(keyboard != null) keyboard.update();
		if(mouse != null) mouse.update();
		if(gamepad != null) gamepad.update();
		if(touch != null) touch.update(dt);
	} 
}