package powerbracelet;
import kha.input.Keyboard;
import haxe.ds.Vector;

class KeyboardInput {
   public var timeout:Float;

   var keyMap:Map<Int, Bool>;
   var pressedMap:Vector<Bool>;
   var releasedMap:Vector<Bool>;
   var lastKey:Int = -1;
   var keyCount:Int = 0;

   public function new(){
		Keyboard.get(0).notify(onKeyDown,onUpKey);

	   keyMap = new Map<Int, Bool>();
	   pressedMap = new Vector<Bool>(255);
	   releasedMap = new Vector<Bool>(255);
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
	   for(i in 0...pressedMap.length){
		   pressedMap[i] = false;
	   }
	   for(i in 0...releasedMap.length){
		   releasedMap[i] = false;
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