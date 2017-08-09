package powerbracelet;
import kha.input.Keyboard;

class KeyboardInput {
   public var timeout:Float;

   //@TODO -> Perhaps use vectors instead
   var keyMap:Map<Int, Bool>;
   var pressedMap:Map<Int, Bool>;
   var releasedMap:Map<Int, Bool>;
   var lastKey:Int = -1;
   var keyCount:Int = 0;

   public function new(){
		 Keyboard.get(0).notify(onKeyDown,onUpKey);

	   keyMap = new Map<Int, Bool>();
	   pressedMap = new Map<Int, Bool>();
	   releasedMap = new Map<Int, Bool>();
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
		pressedMap[keyCode] = true;
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
		}

		releasedMap[keyCode] = true;
		
   }

   @:allow(powerbracelet.Input)
   function update(){
	   for(value in pressedMap){
		   value = false;
	   }
	   for(value in releasedMap){
		   value = false;
	   }
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

    public function released(key:Int):Bool {
	   	return releasedMap[key];
   }
}