package powerbracelet;
import kha.input.Keyboard;

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

   function onKeyDown(keyCode:Int){
	   	//var code:Int = keyCode(e);
		var code:Int = keyCode;
		if(code == -1)
			code = keyCode;
		
		if (code == -1) // No key
			return;
		lastKey = code;

		if (!keyMap[code]){
			keyMap[code] = true;
			keyCount++;
			//_press[_pressNum++] = code;
   		}
   }

   function onUpKey(keyCode:Int){
    var code:Int = keyCode;
		if(code == -1)
			code = keyCode;
		
		if (code == -1) // No key
			return;

		if (keyMap[code]){
			keyMap[code] = false;
			keyCount--;
			//_release[_releaseNum++] = code;
		}
   }

   @:allow(powerbracelet.Input)
   function update(){

   }

   public function isDown(key:Int):Bool {
	   return keyMap[key] != null && keyMap[key];
   }
   
   public function isUp(key:Int):Bool {
	    return keyMap[key] == null || !keyMap[key];
   }

   public function pressed(key:Int):Bool {
	   	return pressedMap[key];
   }
}