package powerbracelet;
import kha.input.*;

class KeyboardInput {
    
   public var timeout:Float;
   var keyMap:Map<Int, Bool>;
   var pressedMap:Map<Int, Bool>;
   var lastKey:Int = -1;
   var keyCount:Int = 0;

   public function new(){
       Keyboard.get(0).notify(onKeyDown,onUpKey);

	   keyMap = new Map<Int, Bool>();
	   pressedMap = new Map<Int, Bool>();

   }

   function onKeyDown(key:kha.Key, char:String){
	   	//var code:Int = keyCode(e);
		var code:Int = getCode(key);
		
		if(code == -1)
		code = char.toUpperCase().charCodeAt(0);
		
		if (code == -1) // No key
			return;
		lastKey = code;

		
		if (!keyMap[code])
		{
			keyMap[code] = true;
			keyCount++;
			//_press[_pressNum++] = code;
   		}
   }

   function onUpKey(key:kha.Key, char:String){
       var code:Int = getCode(key);
		
		if(code == -1)
		code = char.toUpperCase().charCodeAt(0);
		
		if (code == -1) // No key
			return;

		if (keyMap[code])
		{
			keyMap[code] = false;
			keyCount--;
			//_release[_releaseNum++] = code;
		}
   }

   @:allow(powerbracelet.Input)
   function update(){

   }

   public function isDown(key:Int) : Bool{
	   return keyMap[key] != null && keyMap[key];
   }
   
   public function isUp(key:Int) : Bool{
	    return  keyMap[key] == null || !keyMap[key];
   }

   public function pressed(key:Int): Bool{
	   	return pressedMap[key];
   }



   private function getCode(k:kha.Key) : Int
	{
		switch(k) {
	
			case kha.Key.BACKSPACE:
				return Key.BACKSPACE;
			case kha.Key.DEL:
				return Key.DELETE;
			case kha.Key.DOWN:
				return Key.DOWN;
			case kha.Key.UP:
				return Key.UP;
			case kha.Key.LEFT:
				return Key.LEFT;
			case kha.Key.RIGHT:
				return Key.RIGHT;
			case kha.Key.SHIFT:
				return Key.SHIFT;
			case kha.Key.BACK:
			case kha.Key.ESC:
				return Key.ESCAPE;
			case kha.Key.ENTER:
				return Key.ENTER;
			case kha.Key.TAB:
				return Key.TAB;
			case kha.Key.CTRL:
				return Key.CONTROL;
			case kha.Key.ALT:
			case kha.Key.CHAR:
				return -1;
		}
		
		return -1;
	}

}


