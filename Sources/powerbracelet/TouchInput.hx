package powerbracelet;

import kha.input.Surface;
import powerbracelet.Touch;
import haxe.ds.Vector;

class TouchInput {

public var multiTouchSupported(get, null) : Bool;
var touches:Vector<Touch> = new Vector<Touch>(10);

function get_multiTouchSupported() : Bool{
	return Surface.get(0) != null;
}

 public function new(){
	 if(multiTouchSupported)
	 Surface.get(0).notify(onTouchStart,onTouchEnd,onMoveListener);
 }

 function onTouchStart(id:Int, x:Int, y:Int){
	 touches[id] = new Touch();
	 touches[id].position.x = x;
	 touches[id].position.y = y;
	 touches[id].prev.x = x;
	 touches[id].prev.y = y;	 
	 touches[id].setID(id); 
	 touches[id].setPressedState(true);
 }

 function onTouchEnd(id:Int, x:Int, y:Int){
	  touches[id].updatePosition(x,y);
	  touches[id].setPressedState(false);
	  touches[id] = null;
 }

 function onMoveListener(id:Int, x:Int, y:Int){
	 touches[id].updatePosition(x,y);
 }

@:allow(powerbracelet.Input)
 function update(dt:Float){
	 for (i in 0 ... touches.length){
		 if(touches[i] == null) continue;
		 touches[i].update(dt);
	 }
 }

 public function IterateTouchPoints(f:Touch->Void){
	 for (i in 0 ... touches.length){
		 if(touches[i] == null) continue;
		 f(touches[i]);
	 }
 }

 public function GetTouch(id:Int) : Touch{
	 return touches[id];
 }
}