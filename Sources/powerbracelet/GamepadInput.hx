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

	//-----------------------------------------------------------------------	
	public function checkProfiled(button:GPInput, state:ButtonState, controller:Int = 0) : Bool{
		return controllers.exists(controller) && controllers[controller].checkProfiled(button, state);
	}

	public function pressureProfiled(button:GPInput,controller:Int = 0) : Float{
		return controllers.exists(controller) ? controllers[controller].pressureProfiled(button) : 0.0; 
	}

	/**
	 * Returns the axis value (from 0 to 1)
	 * @param  a The axis index to retrieve starting at 0
	 */
	public inline function axisProfiled(a:GPInput,controller:Int = 0) : Float{
		return controllers.exists(controller) ? controllers[controller].axisValueProfiled(a) : 0.0; 
	}
	//-----------------------------------------------------------------------	


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

	public function getName(id:Int){
		if(!controllers.exists(id)) return;
		controllers[id].getName();
	}

	public function getFriendlyName(id:Int){
		if(!controllers.exists(id)) return;
		controllers[id].getFriendlyName();
		
	}

	@:allow(powerbracelet.Input)
	function update() {
		for(pads in controllers){
			pads.update();
		}
	}

}

class GamepadHandler{
	var type:String = "Generic Gamepad";
	var buttons:Map<Int, ButtonState>;
	var pressures:Map<Int, Float>;
	var axis:Map<Int, Float>;
	var id:Int = 0;
	var model:ControllerModel;

	public var deadzone:Float = 0;

	public function new(id:Int){
		
		buttons = new Map<Int, ButtonState>();
		axis = new Map<Int, Float>();
		pressures = new Map<Int, Float>();
		kha.input.Gamepad.get(id).notify(onGamepadAxis,onGamepadButton);
		this.id = id;
		getModel();
		
	}

	public function getName():String{
		return kha.input.Gamepad.get(id).id;
	}

	public function getFriendlyName():String{
		var s:String = kha.input.Gamepad.get(id).id.toLowerCase();

		if(s.indexOf("xbox 360") > -1) return "Xbox Controller";
		if(s.indexOf("vendor: 054c product: 09cc") > -1) return "DS4 Controller";
		return "Generic Controller";
	}

	public function getModel():ControllerModel{

		var s:String = kha.input.Gamepad.get(id).id.toLowerCase();		

		if(s.indexOf("xbox 360") > -1) model = ControllerModel.XBOX_360;
		if(s.indexOf("vendor: 054c product: 09cc") > -1) model = ControllerModel.DS4;

		return model;
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
	
	public function checkProfiled(button:GPInput, state:ButtonState) : Bool{
		var b:Int = GamePadProfiler.getButton(model, button);
		return buttons.exists(b) && buttons[b] == state;  
	}

	public function pressureProfiled(button:GPInput) : Float{
		var b:Int = GamePadProfiler.getButton(model, button);		
		return pressures.exists(b) ? pressures[b]:0;
	}

	/**
	 * Returns the axis value (from 0 to 1)
	 * @param  a The axis index to retrieve starting at 0
	 */
	public inline function axisValueProfiled(a:GPInput):Float
	{
		var ax:Int = GamePadProfiler.getAxis(model, a);				
		return axis.exists(ax) ? (Math.abs(axis[ax]) >= deadzone ? axis[ax]:0):0; // @TODO Normalize deadzone
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
	
		trace('Button : $button');
		if(value > 0.5)buttons.set(button,Pressed);
		else buttons.set(button,Released);

		pressures.set(button, value);
	}

}

class GamePadProfiler{
	function new(){}

	public static function getButton(model:ControllerModel, input:GPInput) : Int{
		switch(model){
			case  XBOX_ONE:
				return XBOX360_GAMEPAD.GetButton(input);
			case  XBOX_360:
				return XBOX360_GAMEPAD.GetButton(input);
			case  DS4:
				return PS4_GAMEPAD.GetButton(input);
		}
		return -1;
	}

	public static function getAxis(model:ControllerModel, input:GPInput) : Int{
		switch(model){
			case  XBOX_ONE:
				return XBOX360_GAMEPAD.GetAxis(input);
			case  XBOX_360:
				return XBOX360_GAMEPAD.GetAxis(input);
			case  DS4:
				return PS4_GAMEPAD.GetAxis(input);
		}
		return -1;
	}

}


enum GPInput{
	WEST_BUTTON;
	SOUTH_BUTTON;
	NORTH_BUTTON;
	EAST_BUTTON;

	LB_BUTTON;
	RB_BUTTON;

	LB_2_BUTTON;
	RB_2_BUTTON;

	SELECT_BUTTON;
	START_BUTTON;
	LEFT_ANALOGUE_BUTTON;
	RIGHT_ANALOGUE_BUTTON;

	HOME_BUTTON;

	DPAD_UP	;
	DPAD_DOWN;
	DPAD_LEFT;
	DPAD_RIGHT;

	LEFT_ANALOGUE_X	;
	LEFT_ANALOGUE_Y	;
	RIGHT_ANALOGUE_X;
	RIGHT_ANALOGUE_Y;
	LEFT_TRIGGER	;
	RIGHT_TRIGGER	;
}


enum ControllerModel{
	XBOX_360;
	XBOX_ONE;
	DS4;
}

class XBOX360_GAMEPAD{
	public static inline var A_BUTTON 					= 0;
	public static inline var B_BUTTON 					= 1;
	public static inline var X_BUTTON 					= 2;
	public static inline var Y_BUTTON 					= 3;
	public static inline var LB_BUTTON  				= 4;
	public static inline var RB_BUTTON  	 			= 5;
	public static inline var LB2_BUTTON  				= 6;
	public static inline var RB2_BUTTON 	 			= 7;
	public static inline var BACK_BUTTON	 			= 9;
	public static inline var START_BUTTON	 			= 8;
	public static inline var LEFT_ANALOGUE_BUTTON	 	= 10;
	public static inline var RIGHT_ANALOGUE_BUTTON		= 11;
	public static inline var XBOX_BUTTON	 			= 16;
	public static inline var DPAD_UP	 				= 12;
	public static inline var DPAD_DOWN					= 13;
	public static inline var DPAD_LEFT	 				= 14;
	public static inline var DPAD_RIGHT		 			= 15;
	public static inline var LEFT_ANALOGUE_X 			= 0;
	public static inline var LEFT_ANALOGUE_Y 			= 1;
	public static inline var RIGHT_ANALOGUE_X 			= 2;
	public static inline var RIGHT_ANALOGUE_Y 			= 3;
	public static inline var LEFT_TRIGGER	 			= 4;
	public static inline var RIGHT_TRIGGER	 			= 5;

	public static function GetButton(input:GPInput):Int{
		switch(input){
			case GPInput.WEST_BUTTON:
				return X_BUTTON;
			case GPInput.SOUTH_BUTTON:
				return A_BUTTON;			
			case GPInput.NORTH_BUTTON:
				return Y_BUTTON;						
			case GPInput.EAST_BUTTON:
				return B_BUTTON;
			case GPInput.LB_BUTTON:
				return LB_BUTTON;
			case GPInput.RB_BUTTON:
				return RB_BUTTON;
			case GPInput.LB_2_BUTTON:
				return LB2_BUTTON;
			case GPInput.RB_2_BUTTON:
				return RB2_BUTTON;
			case GPInput.SELECT_BUTTON:
				return BACK_BUTTON;
			case GPInput.START_BUTTON:
				return START_BUTTON;
			case GPInput.LEFT_ANALOGUE_BUTTON:
				return LEFT_ANALOGUE_BUTTON;
			case GPInput.RIGHT_ANALOGUE_BUTTON:
				return RIGHT_ANALOGUE_BUTTON;			
			case GPInput.HOME_BUTTON:
				return XBOX_BUTTON;
			case GPInput.DPAD_UP:
				return -1;			
			case GPInput.DPAD_DOWN:
				return -1;					
			case GPInput.DPAD_LEFT:
				return -1;						
			case GPInput.DPAD_RIGHT:
				return -1;						
			case GPInput.LEFT_ANALOGUE_X:
				return -1;						
			case GPInput.LEFT_ANALOGUE_Y:
				return -1;			
			case GPInput.RIGHT_ANALOGUE_X:
				return -1;			
			case GPInput.RIGHT_ANALOGUE_Y:
				return -1;			
			case GPInput.LEFT_TRIGGER:
				return -1;			
			case GPInput.RIGHT_TRIGGER:
				return -1;
		}

	}

	public static function GetAxis(input:GPInput):Int{
		switch(input){
			case GPInput.WEST_BUTTON:
				return -1;
			case GPInput.SOUTH_BUTTON:
				return -1;			
			case GPInput.NORTH_BUTTON:
				return -1;						
			case GPInput.EAST_BUTTON:
				return -1;
			case GPInput.LB_BUTTON:
				return -1;
			case GPInput.RB_BUTTON:
				return -1;
			case GPInput.LB_2_BUTTON:
				return -1;
			case GPInput.RB_2_BUTTON:
				return -1;
			case GPInput.SELECT_BUTTON:
				return -1;
			case GPInput.START_BUTTON:
				return -1;
			case GPInput.LEFT_ANALOGUE_BUTTON:
				return -1;
			case GPInput.RIGHT_ANALOGUE_BUTTON:
				return -1;		
			case GPInput.HOME_BUTTON:
				return -1;
			case GPInput.DPAD_UP:
				return DPAD_UP;			
			case GPInput.DPAD_DOWN:
				return DPAD_DOWN;					
			case GPInput.DPAD_LEFT:
				return DPAD_LEFT;						
			case GPInput.DPAD_RIGHT:
				return DPAD_RIGHT;						
			case GPInput.LEFT_ANALOGUE_X:
				return LEFT_ANALOGUE_X;						
			case GPInput.LEFT_ANALOGUE_Y:
				return LEFT_ANALOGUE_Y;			
			case GPInput.RIGHT_ANALOGUE_X:
				return RIGHT_ANALOGUE_X;			
			case GPInput.RIGHT_ANALOGUE_Y:
				return RIGHT_ANALOGUE_Y;			
			case GPInput.LEFT_TRIGGER:
				return LEFT_TRIGGER;			
			case GPInput.RIGHT_TRIGGER:
				return RIGHT_TRIGGER;
		}
	}
}

class PS4_GAMEPAD
{
	public static inline var SQUARE_BUTTON				=0;
	public static inline var X_BUTTON					=1;
	public static inline var CIRCLE_BUTTON				=2;
	public static inline var TRIANGLE_BUTTON			=3;
	public static inline var L1_BUTTON					=4;
	public static inline var R1_BUTTON					=5;
	public static inline var L2_BUTTON					=6;
	public static inline var R2_BUTTON					=7;
	public static inline var OPTION_BUTTON				=8;
	public static inline var TOUCH_BUTTON				=9;
	public static inline var LEFT_ANALOGUE_BUTTON		=10;
	public static inline var RIGHT_ANALOGUE_BUTTON		=11;
	public static inline var PS_BUTTON					=12;
	public static inline var DPAD_UP					=7;
	public static inline var DPAD_DOWN					=7;
	public static inline var DPAD_LEFT					=6;
	public static inline var DPAD_RIGHT					=6;
 
	public static inline var LEFT_ANALOGUE_X			=0;
	public static inline var LEFT_ANALOGUE_Y			=1;
	 
	public static inline var LEFT_TRIGGER	 			=3;
	public static inline var RIGHT_TRIGGER	 			=4;

	public static inline var RIGHT_ANALOGUE_X			=2;
	public static inline var RIGHT_ANALOGUE_Y			=5;
 
	

	public static function GetButton(input:GPInput):Int{
		switch(input){
			case GPInput.WEST_BUTTON:
				return SQUARE_BUTTON;
			case GPInput.SOUTH_BUTTON:
				return X_BUTTON;			
			case GPInput.NORTH_BUTTON:
				return TRIANGLE_BUTTON;						
			case GPInput.EAST_BUTTON:
				return CIRCLE_BUTTON;
			case GPInput.LB_BUTTON:
				return L1_BUTTON;
			case GPInput.RB_BUTTON:
				return R1_BUTTON;
			case GPInput.LB_2_BUTTON:
				return L2_BUTTON;
			case GPInput.RB_2_BUTTON:
				return R2_BUTTON;
			case GPInput.SELECT_BUTTON:
				return OPTION_BUTTON;
			case GPInput.START_BUTTON:
				return TOUCH_BUTTON;
			case GPInput.LEFT_ANALOGUE_BUTTON:
				return LEFT_ANALOGUE_BUTTON;
			case GPInput.RIGHT_ANALOGUE_BUTTON:
				return RIGHT_ANALOGUE_BUTTON;			
			case GPInput.HOME_BUTTON:
				return PS_BUTTON;
			case GPInput.DPAD_UP:
				return -1;			
			case GPInput.DPAD_DOWN:
				return -1;					
			case GPInput.DPAD_LEFT:
				return -1;						
			case GPInput.DPAD_RIGHT:
				return -1;						
			case GPInput.LEFT_ANALOGUE_X:
				return -1;						
			case GPInput.LEFT_ANALOGUE_Y:
				return -1;			
			case GPInput.RIGHT_ANALOGUE_X:
				return -1;			
			case GPInput.RIGHT_ANALOGUE_Y:
				return -1;			
			case GPInput.LEFT_TRIGGER:
				return -1;			
			case GPInput.RIGHT_TRIGGER:
				return -1;
		}

	}
	public static function GetAxis(input:GPInput):Int{
		switch(input){
			case GPInput.WEST_BUTTON:
				return -1;
			case GPInput.SOUTH_BUTTON:
				return -1;			
			case GPInput.NORTH_BUTTON:
				return -1;						
			case GPInput.EAST_BUTTON:
				return -1;
			case GPInput.LB_BUTTON:
				return -1;
			case GPInput.RB_BUTTON:
				return -1;
			case GPInput.LB_2_BUTTON:
				return -1;
			case GPInput.RB_2_BUTTON:
				return -1;
			case GPInput.SELECT_BUTTON:
				return -1;
			case GPInput.START_BUTTON:
				return -1;
			case GPInput.LEFT_ANALOGUE_BUTTON:
				return -1;
			case GPInput.RIGHT_ANALOGUE_BUTTON:
				return -1;		
			case GPInput.HOME_BUTTON:
				return -1;
			case GPInput.DPAD_UP:
				return DPAD_UP;			
			case GPInput.DPAD_DOWN:
				return DPAD_DOWN;					
			case GPInput.DPAD_LEFT:
				return DPAD_LEFT;						
			case GPInput.DPAD_RIGHT:
				return DPAD_RIGHT;						
			case GPInput.LEFT_ANALOGUE_X:
				return LEFT_ANALOGUE_X;						
			case GPInput.LEFT_ANALOGUE_Y:
				return LEFT_ANALOGUE_Y;			
			case GPInput.RIGHT_ANALOGUE_X:
				return RIGHT_ANALOGUE_X;			
			case GPInput.RIGHT_ANALOGUE_Y:
				return RIGHT_ANALOGUE_Y;			
			case GPInput.LEFT_TRIGGER:
				return LEFT_TRIGGER;			
			case GPInput.RIGHT_TRIGGER:
				return RIGHT_TRIGGER;
		}
	}
} 