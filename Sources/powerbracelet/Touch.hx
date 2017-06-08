package powerbracelet;
import kha.math.Vector2i;

class Touch{

	public function new(){}

	public var id(default, null) : Int;

	@:allow(powerbracelet.TouchInput)	
	function setID(v:Int){
		id = v;
	}

	public var pressed(default,null):Bool = false;
	
	@:allow(powerbracelet.TouchInput)	
	function setPressedState(v:Bool){
		pressed = v;
	}
	public var time(default, null):Float;

	@:allow(powerbracelet.TouchInput)	
	function update(delta:Float){
		time += delta;
	}


	@:allow(powerbracelet.TouchInput)
	function updatePosition(x:Int, y:Int){
		prev.x = position.x;
		prev.y = position.y;

		position.x = x;
		position.y = y;
	}

	public var position(default, null):Vector2i = new Vector2i(0,0);
	public var delta(get, null):Vector2i = new Vector2i(0,0);
	
	function get_delta() : Vector2i{
		return position.sub(prev);
	}

	@:allow(powerbracelet.TouchInput)
	var prev:Vector2i = new Vector2i();
}