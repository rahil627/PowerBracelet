package powerbracelet;
import kha.input.Mouse;
import powerbracelet.ButtonState;

class MouseInput {
 /** The x position of the mouse on screen*/
 public var x(default, null) : Int  = 0;
 /** The y position of the mouse on screen*/
 public var y(default, null) : Int = 0;
 /** The x position of the mouse on screen*/
 public var rawX(default, null) : Int  = 0;
 /** The y position of the mouse on screen*/
 public var rawY(default, null) : Int = 0;
 /** The x delta of the mouse*/
 public var deltaX(default, null) : Int = 0;
 /** The y delta of the mouse*/
 public var deltaY(default, null) : Int = 0;
 /** The last x position when a button was clicked*/
 public var xPressed(default, null) : Int = 0;
  /** The last y position when a button was clicked*/
 public var yPressed(default, null) : Int = 0;
  /** The last x position when a button was clicked*/
 public var xReleased(default, null) : Int = 0;
  /** The last y position when a button was clicked*/
 public var yReleased(default, null) : Int = 0;
 /** The delta of the mouse scroll on this frame */
 public var wheelDelta(default, null) : Int = 0;
 /** Whether any button is down*/
 public var buttonDown(default, null) : Bool = false;
 /** Whether any button is down this frame*/
 public var buttonPressed(default, null) : Bool = false;
 
 public static var bufferWidth:Int = 0;
 public static var bufferHeight:Int = 0;

 var buttons:Map<Int, ButtonState>;

	public function new(){
		Mouse.get(0).notify(onMouseDown, onMouseUp, onMouseMove, onMouseWheel);
		buttons = new Map<Int, ButtonState>();
	}

	 function  onMouseDown(button:Int, x:Int, y:Int){
		 	buttons.set(button, Pressed);
			 xPressed = x;
			 yPressed = y;
			 buttonDown = true;
			 buttonPressed = true;
	 }
	 function  onMouseUp(button:Int, x:Int, y:Int){
		 	buttons.set(button, Released);
			 xReleased = x;
			 yReleased = y;
			buttonDown = false;
	 }
	 function  onMouseMove(x:Int, y:Int, dx:Int, dy:Int){
		 rawX = x;
		 rawY = y;
		 
		 updateScaled();

		 deltaX = dx;
		 deltaY = dy;
	 }
	 function  onMouseWheel(delta:Int){
		 wheelDelta = delta;
	 }

 	/**Checks if one of buttons state matches the given state*/
	 public function check(button:Int, state:ButtonState) : Bool{
			return buttons.exists(button) && buttons[button] == state;
	 }
	 @:allow(powerbracelet.Input)
	 function update(){
		 wheelDelta = 0;
		 buttonPressed = false;
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
		deltaX = 0;
		deltaY = 0;
	 }

	function updateScaled(){
		 x = kha.Scaler.transformXDirectly(rawX,rawY, bufferWidth,bufferHeight, kha.ScreenCanvas.the.width,kha.ScreenCanvas.the.height, kha.System.screenRotation);
		 y = kha.Scaler.transformYDirectly(rawX,rawY,bufferWidth,bufferHeight, kha.ScreenCanvas.the.width,kha.ScreenCanvas.the.height,kha.System.screenRotation);
	 }

	 @:allow(powerbracelet.TouchInput)
	 function setLMB(state:ButtonState){
			buttons.set(0,state);
	 }

	  @:allow(powerbracelet.TouchInput)
	 function setMouseCoord(x:Int,y:Int){
			rawX = x;
			rawY = y;
			updateScaled();
	 }

	   @:allow(powerbracelet.TouchInput)
	 function setMouseDelta(x:Int,y:Int){
			deltaX = x;
			deltaY = y;
	 }

}

@:enum
abstract MouseButton(Int) to Int {
	var Left = 0;
	var Right = 1;
	var Middle = 2;
}