package powerbracelet;

import powerbracelet.ButtonState;

class GamepadInput {

   var controllers:Map<Int, GamepadHandler>;

	public function new(){
			controllers = new Map<Int, GamepadHandler>();
	}

	public function check(button:Int, state:ButtonState, controller:Int = 0) : Bool{
		return controllers.exists(controller) && controllers[controller].check(button, state);
	}

	public  function pressure(button:Int, controller:Int = 0) : Float{
		return controllers.exists(controller) ? controllers[controller].pressure(button) : 0.0; 
	}

	public function axis(a:Int,controller:Int = 0) : Float{
		return controllers.exists(controller) ? controllers[controller].axisValue(a) : 0.0; 
	}

	public function addController(id:Int){
		if(!controllers.exists(id))
		controllers[id] = new GamepadHandler(id);
	}

	public function setDeadzone(id:Int, value:Float){
		if(!controllers.exists(id)) return;

		value = value < 0 ? 0:value;
		value = value > 1 ? 1:value;
		controllers[id].deadzone = value;
	}

	@:allow(powerbracelet.Input)
	function update() {
		for(pads in controllers){
			pads.update();
		}
	}

}

class GamepadHandler{
	var buttons:Map<Int, ButtonState>;
	var pressures:Map<Int, Float>;
	var axis:Map<Int, Float>;

	public var deadzone:Float = 0;

	public function new(id:Int){
		
		buttons = new Map<Int, ButtonState>();
		axis = new Map<Int, Float>();
		pressures = new Map<Int, Float>();
		kha.input.Gamepad.get(id).notify(onGamepadAxis,onGamepadButton);
	}

	public function check(button:Int, state:ButtonState) : Bool{
		return buttons.exists(button) && buttons[button] == state;  
	}

	public function pressure(button:Int) : Float{
		
		return pressures.exists(button) ? pressures[button]:0;
	}

	/**
	 * Returns the axis value (from 0 to 1)
	 * @param  a The axis index to retrieve starting at 0
	 */
	public inline function axisValue(a:Int):Float
	{
		return axis.exists(a) ? (Math.abs(axis[a]) >= deadzone ? axis[a]:0):0; // @TODO Normalize deadzone
	}
	

	public function update() {
		//Reset any button that was on Release this frame

		for (button in buttons.keys()){

			switch (buttons[button]){
				case Off:
				case On:
				case Pressed:
					buttons.set(button,On);
				case Released:
					buttons.set(button,Off);
			}

			
			
		}
	}

	public function onGamepadAxis(ax:Int, value:Float) : Void {
		axis[ax] = value;
	}
	
	public function onGamepadButton(button:Int, value:Float) : Void {
	
		if(value > 0.5)buttons.set(button,Pressed);
		else buttons.set(button,Released);

		pressures.set(button, value);
	}

}

/**
 * Mapping to use an Ouya gamepad with `Joystick`.
 */
class OUYA_GAMEPAD
{
#if ouya	// ouya console mapping
	// buttons
	public static inline var O_BUTTON:Int = 0; // 96
	public static inline var U_BUTTON:Int = 3; // 99
	public static inline var Y_BUTTON:Int = 4; // 100
	public static inline var A_BUTTON:Int = 1; // 97
	public static inline var LB_BUTTON:Int = 6; // 102
	public static inline var RB_BUTTON:Int = 7; // 103
	public static inline var BACK_BUTTON:Int = 5;
	public static inline var START_BUTTON:Int = 4;
	public static inline var LEFT_ANALOGUE_BUTTON:Int = 10; // 106
	public static inline var RIGHT_ANALOGUE_BUTTON:Int = 11; // 107
	public static inline var LEFT_TRIGGER_BUTTON:Int = 8;
	public static inline var RIGHT_TRIGGER_BUTTON:Int = 9;
	public static inline var DPAD_UP:Int = 19;
	public static inline var DPAD_DOWN:Int = 20;
	public static inline var DPAD_LEFT:Int = 21;
	public static inline var DPAD_RIGHT:Int = 22;

	/**
	 * The Home button event is handled as a keyboard event!
	 * Also, the up and down events happen at once,
	 * therefore, use pressed() or released().
	 */
	public static inline var HOME_BUTTON:Int = 16777234; // 82


	// axis
	public static inline var LEFT_ANALOGUE_X:Int = 0;
	public static inline var LEFT_ANALOGUE_Y:Int = 1;
	public static inline var RIGHT_ANALOGUE_X:Int = 11;
	public static inline var RIGHT_ANALOGUE_Y:Int = 14;
	public static inline var LEFT_TRIGGER:Int = 17;
	public static inline var RIGHT_TRIGGER:Int = 18;
	
#else	// desktop mapping
	public static inline var O_BUTTON:Int = 0;
	public static inline var U_BUTTON:Int = 1;
	public static inline var Y_BUTTON:Int = 2;
	public static inline var A_BUTTON:Int = 3;
	public static inline var LB_BUTTON:Int = 4;
	public static inline var RB_BUTTON:Int = 5;
	public static inline var BACK_BUTTON:Int = 20; // no back button!
	public static inline var START_BUTTON:Int = 20; // no start button!
	public static inline var LEFT_ANALOGUE_BUTTON:Int = 6;
	public static inline var RIGHT_ANALOGUE_BUTTON:Int = 7;
	public static inline var LEFT_TRIGGER_BUTTON:Int = 12;
	public static inline var RIGHT_TRIGGER_BUTTON:Int = 13;
	public static inline var DPAD_UP:Int = 8;
	public static inline var DPAD_DOWN:Int = 9;
	public static inline var DPAD_LEFT:Int = 10;
	public static inline var DPAD_RIGHT:Int = 11;
	
	/**
	 * The Home button only works on the Ouya-console
	 */
	public static inline var HOME_BUTTON:Int = 16777234;

	public static inline var LEFT_ANALOGUE_X:Int = 0;
	public static inline var LEFT_ANALOGUE_Y:Int = 1;
	public static inline var RIGHT_ANALOGUE_X:Int = 5;
	public static inline var RIGHT_ANALOGUE_Y:Int = 4;
	public static inline var LEFT_TRIGGER:Int = 2;	// negative values before button trigger, positive values after
	public static inline var RIGHT_TRIGGER:Int = 3;	// negative values before button trigger, positive values after
#end
}

/**
 * Mapping to use a Xbox gamepad with `Joystick`.
 */
class XBOX_GAMEPAD
{
//#if mac
	// /**
	//  * Button IDs
	//  */
	// public static inline var A_BUTTON:Int = 0;
	// public static inline var B_BUTTON:Int = 1;
	// public static inline var X_BUTTON:Int = 2;
	// public static inline var Y_BUTTON:Int = 3;
	// public static inline var LB_BUTTON:Int = 4;
	// public static inline var RB_BUTTON:Int = 5;
	// public static inline var BACK_BUTTON:Int = 9;
	// public static inline var START_BUTTON:Int = 8;
	// public static inline var LEFT_ANALOGUE_BUTTON:Int = 6;
	// public static inline var RIGHT_ANALOGUE_BUTTON:Int = 7;
	
	// public static inline var XBOX_BUTTON:Int = 10;

	// public static inline var DPAD_UP:Int = 11;
	// public static inline var DPAD_DOWN:Int = 12;
	// public static inline var DPAD_LEFT:Int = 13;
	// public static inline var DPAD_RIGHT:Int = 14;
	
	// /**
	//  * Axis array indicies
	//  */
	// public static inline var LEFT_ANALOGUE_X:Int = 0;
	// public static inline var LEFT_ANALOGUE_Y:Int = 1;
	// public static inline var RIGHT_ANALOGUE_X:Int = 3;
	// public static inline var RIGHT_ANALOGUE_Y:Int = 4;
	// public static inline var LEFT_TRIGGER:Int = 2;
	// public static inline var RIGHT_TRIGGER:Int = 5;
//#elseif linux
	/**
	 * Button IDs
	 */
//	public static inline var A_BUTTON:Int = 0;
//	public static inline var B_BUTTON:Int = 1;
//	public static inline var X_BUTTON:Int = 2;
//	public static inline var Y_BUTTON:Int = 3;
//	public static inline var LB_BUTTON:Int = 4;
//	public static inline var RB_BUTTON:Int = 5;
//	public static inline var BACK_BUTTON:Int = 6;
//	public static inline var START_BUTTON:Int = 7;
//	public static inline var LEFT_ANALOGUE_BUTTON:Int = 9;
//	public static inline var RIGHT_ANALOGUE_BUTTON:Int = 10;
//	
//	public static inline var XBOX_BUTTON:Int = 8;
//	
//	public static inline var DPAD_UP:Int = 13;
//	public static inline var DPAD_DOWN:Int = 14;
//	public static inline var DPAD_LEFT:Int = 11;
//	public static inline var DPAD_RIGHT:Int = 12;
//	
//	/**
//	 * Axis array indicies
//	 */
//	public static inline var LEFT_ANALOGUE_X:Int = 0;
//	public static inline var LEFT_ANALOGUE_Y:Int = 1;
//	public static inline var RIGHT_ANALOGUE_X:Int = 3;
//	public static inline var RIGHT_ANALOGUE_Y:Int = 4;
//	public static inline var LEFT_TRIGGER:Int = 2;
//	public static inline var RIGHT_TRIGGER:Int = 5;
//#else // windows
	/**
	 * Button IDs
	 */
	public static inline var A_BUTTON:Int = 0;
	public static inline var B_BUTTON:Int = 1;
	public static inline var X_BUTTON:Int = 2;
	public static inline var Y_BUTTON:Int = 3;
	public static inline var LB_BUTTON:Int = 4;
	public static inline var RB_BUTTON:Int = 5;
	public static inline var BACK_BUTTON:Int = 8;
	public static inline var START_BUTTON:Int = 9;
	public static inline var LEFT_ANALOGUE_BUTTON:Int = 10;
	public static inline var RIGHT_ANALOGUE_BUTTON:Int = 11;
	
	public static inline var XBOX_BUTTON:Int = 14;
	
	public static inline var DPAD_UP:Int = 12;
	public static inline var DPAD_DOWN:Int = 13;
	public static inline var DPAD_LEFT:Int = 14;
	public static inline var DPAD_RIGHT:Int = 15;
	
	/**
	 * Axis array indicies
	 */
	public static inline var LEFT_ANALOGUE_X:Int = 0;
	public static inline var LEFT_ANALOGUE_Y:Int = 1;
	public static inline var RIGHT_ANALOGUE_X:Int = 2;
	public static inline var RIGHT_ANALOGUE_Y:Int = 3;
	public static inline var LEFT_TRIGGER:Int = 6;
	public static inline var RIGHT_TRIGGER:Int = 7;
//#end
}

/**
 * Mapping to use a PS3 gamepad with `Joystick`.
 */
class PS3_GAMEPAD
{
	public static inline var TRIANGLE_BUTTON:Int = 12;
	public static inline var CIRCLE_BUTTON:Int = 13;
	public static inline var X_BUTTON:Int = 14;
	public static inline var SQUARE_BUTTON:Int = 15;
	public static inline var L1_BUTTON:Int = 10;
	public static inline var R1_BUTTON:Int = 11;
	public static inline var L2_BUTTON:Int = 8;
	public static inline var R2_BUTTON:Int = 9;
	public static inline var SELECT_BUTTON:Int = 0;
	public static inline var START_BUTTON:Int = 3;
	public static inline var PS_BUTTON:Int = 16;
	public static inline var LEFT_ANALOGUE_BUTTON:Int = 1;
	public static inline var RIGHT_ANALOGUE_BUTTON:Int = 2;
	public static inline var DPAD_UP:Int = 4;
	public static inline var DPAD_DOWN:Int = 6;
	public static inline var DPAD_LEFT:Int = 7;
	public static inline var DPAD_RIGHT:Int = 5;

	public static inline var LEFT_ANALOGUE_X:Int = 0;
	public static inline var LEFT_ANALOGUE_Y:Int = 1;
	public static inline var TRIANGLE_BUTTON_PRESSURE:Int = 16;
	public static inline var CIRCLE_BUTTON_PRESSURE:Int = 17;
	public static inline var X_BUTTON_PRESSURE:Int = 18;
	public static inline var SQUARE_BUTTON_PRESSURE:Int = 19;
}