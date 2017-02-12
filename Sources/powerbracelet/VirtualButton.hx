package powerbracelet;

class VirtualButton{
    
    public var pressed(default, null):Bool;
    public var name(default, null):String;
    public function new(name:String){this.name = name;}

    public function update(isPressed:Bool){
        pressed = isPressed;
    }

    function setPress(){
        pressed = true;
    }

    function released(){
        pressed = false;
    }

}