package powerbracelet;

class VirtualInput {

    static var buttons:Map<String, VirtualButton>;
    static var axes:Map<String, VirtualAxis>;

    public static function init(){
        buttons = new Map<String, VirtualButton>();
        axes = new Map<String, VirtualAxis>();
    }
    public static function clear(){
        buttons = new Map<String, VirtualButton>();
        axes = new Map<String, VirtualAxis>();
    }
    public static function destroy(){
        buttons = null;
        axes = null;
    }

    public static function addButton(button:VirtualButton){
        if(buttons.exists(button.name)) throw "The button" + button.name + "already exists. Only a unique button is allowd.";
        buttons.set(button.name, button);
    }

    public static function removeButton(name:String){
        if(buttons.exists(name)){
            buttons.remove(name);
        }
    }

    public static function addAxis(axis:VirtualAxis){
        if(axes.exists(axis.name)) throw "The axis" + axis.name + "already exists. Only a unique axis is allowd.";
        axes.set(axis.name, axis);
    }
    public static function removeAxis(name:String){
        if(axes.exists(name)){
            axes.remove(name);
        }
    }

    public static function axisExists(name:String) : Bool{
        return axes.exists(name);
    }

    public static function buttonExists(name:String) : Bool{
        return buttons.exists(name);
    }

    public static function buttonPressed(name:String) : Bool{
        return buttons.get(name).pressed;
    }

    public static function axisValue(name:String) : Float{
        return axes.get(name).value;
    }

    public static function getButton(name:String) : VirtualButton{
        return buttons.get(name);
    }

    public static function getAxis(name:String) : VirtualAxis{
        return axes.get(name);
    }

    
}