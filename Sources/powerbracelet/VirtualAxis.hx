package powerbracelet;

class VirtualAxis{
    public var value(default, null):Float;
    public var name(default, null):String;
    public function new(name:String){this.name = name;}

     public function update(v:Float){
        value = v;
        value = value < -1 ? -1:value;
        value = value >  1 ? 1:value;
     }

}