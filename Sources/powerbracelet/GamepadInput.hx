package powerbracelet;

import powerbracelet.ButtonState;
import haxe.Json;

class GamepadInput {
	var controllers:Map<Int, GamepadHandler>;
  var profiles:Array<Profile> = new Array<Profile>();
	
	public function new(){
		controllers = new Map<Int, GamepadHandler>();
		addProfile("generic");
	}

	public function getButtonName(b:ButtonInput, controller:Int = 0){
		return controllers.exists(controller) ? controllers[controller].getButtonName(b) : "Controller not set!";
	}

	public function getAxisName(a:AxisInput, controller:Int = 0){
		return controllers.exists(controller) ? controllers[controller].getAxisName(a) : "Controller not set!";
	}

	public function checkRaw(button:Int, state:ButtonState, controller:Int = 0) : Bool{
		return controllers.exists(controller) && controllers[controller].checkRaw(button, state);
	}

	public  function pressureRaw(button:Int, controller:Int = 0) : Float{
		return controllers.exists(controller) ? controllers[controller].pressureRaw(button) : 0.0; 
	}

	public function axisRaw(a:Int,controller:Int = 0) : Float{
		return controllers.exists(controller) ? controllers[controller].axisValueRaw(a) : 0.0; 
	}

	//-----------------------------------------------------------------------	
	public function check(button:ButtonInput, state:ButtonState, controller:Int = 0) : Bool{
		return controllers.exists(controller) && controllers[controller].check(button, state);
	}

	public function pressure(button:ButtonInput,controller:Int = 0) : Float{
		return controllers.exists(controller) ? controllers[controller].pressure(button) : 0.0; 
	}

	/**
	 * Returns the axis value (from 0 to 1)
	 * @param  a The axis index to retrieve starting at 0
	 */
	public inline function axis(a:AxisInput, controller:Int = 0) : Float{
		return controllers.exists(controller) ? controllers[controller].axisValue(a) : 0.0; 
	}
	//-----------------------------------------------------------------------	

	public function addController(id:Int){
		if(!controllers.exists(id))
			controllers[id] = new GamepadHandler(id);
		controllers[id].profile = getProfile(controllers[id].getHardwareID());
	}

	public function setDeadzone(id:Int, value:Float){
		if(!controllers.exists(id)) return;

		value = value < 0 ? 0:value;
		value = value > 1 ? 1:value;
		controllers[id].deadzone = value;
	}

	public function getHardwareID(id:Int){
		if(!controllers.exists(id)) return;
		controllers[id].getHardwareID();
	}

	public function getFriendlyName(id:Int){
		if(!controllers.exists(id)) return;
		controllers[id].getFriendlyName();
	}

	// public function addAllProfiles(){
	// 		if(!profilesloaded){
	// 				getProfileData(addAllProfiles);
	// 				return;
	// 		}


	// }

	// function getProfileData(cb:void->void): Bool{
	// 	if(!Reflect.hasField(kha.Assets.blobs, "gamepadprofiles_json")){
	// 			trace("gamepadprofiles.json missing from assets.\n make sure the asset folder is known in khafile.js");
	// 			profilesloaded = false;
	// 	}
	// 	else{
	// 		var b:kha.Blob =  cast Reflect.field(kha.Assets.blobs, "gamepadprofiles_json");

	// 		profilesloaded = false;

	// 		if(b == null){
				
	// 			kha.Assets.loadBlob("gamepadprofiles_json", function(b:kha.Blob){
	// 				profilesloaded = true;
	// 				cb();
	// 			});

	// 		}
	// 		else {
	// 			profilesloaded = true;

	// 		}
	// }


	function getProfile(id:String) : Profile{

		var p:Profile = null; // fallback

		for(profile in profiles)
			for(guid in profile.guids){

				if(guid == "generic") p = profile;

				if(guid.indexOf(id) > -1 || id.toLowerCase().indexOf(guid) > -1 ) {
					return profile;
				}
			}

		return 	p;
	}

	var  profilesloaded = false;

	@:access(powerbracelet.Button)
	@:access(powerbracelet.Axis)
	@:access(powerbracelet.Profile)
	public function addProfile(name:String){
		if(!Reflect.hasField(kha.Assets.blobs, "gamepadprofiles_json")){
				trace("gamepadprofiles.json missing from assets.\n make sure the asset folder is known in khafile.js");
		}
		else{
			var b:kha.Blob =  cast Reflect.field(kha.Assets.blobs, "gamepadprofiles_json");
			if(b == null){
				
				kha.Assets.loadBlob("gamepadprofiles_json", function(b:kha.Blob){
					profilesloaded = true;
					addProfile(name);
				});

			}
			else {
				profilesloaded = true;
			}

			if(!profilesloaded) return;

			var j = Json.parse(b.toString());
			var profile = Reflect.field(j,name);

			if(profile == null)  return;

			var gpProfile:Profile = new Profile();
			gpProfile.name = name;
			profiles.push(gpProfile);


			var guids:Array<String> = profile.guid;
			//var transform = profile.transform;
			var buttons = profile.mapping.buttons;
			var axis = profile.mapping.axis;

			gpProfile.guids = guids;

			//Process buttons
			for(map in Reflect.fields(buttons)){
								
				var b:Button = new Button();
				var e:ButtonInput = Reflect.field(ButtonInput, map);
				gpProfile.buttonMapping.set(e, b);

				var bs = Reflect.field(buttons,map);
				b.name = Reflect.fields(bs)[0];
				b.id = Reflect.field(bs,b.name);

				/*if(transform != null && Reflect.hasField(transform, map)){
					var t = Reflect.field(transform, map);
					var tn = Reflect.fields(t)[0];
					switch(tn){
						case "isAxis": 
						b.isAxis = true;
						b.sign = Reflect.field(t,tn) == "-" ? -1:1;
					}
				}*/
	
			}

			//Process buttons
			for(axmap in Reflect.fields(axis)){
				
				var a:Axis = new Axis();
				var e:AxisInput = Reflect.field(AxisInput, axmap);
				gpProfile.axisMapping.set(e, a);

				var bs = Reflect.field(axis,axmap);
				a.name = Reflect.fields(bs)[0];
				a.id = Reflect.field(bs,a.name);

				/*if(transform != null && Reflect.hasField(transform, axmap)){
					var t = Reflect.field(transform, axmap);
					var tn = Reflect.fields(t)[0];

					switch(tn){
						case "range": 
						var s:String = Reflect.field(t,tn);
						var split = s.split("->");
						var splitLeft = split[0].split(",");
						var splitRight = split[1].split(",");

						a.min = Std.parseInt(splitLeft[0]);
						a.max = Std.parseInt(splitLeft[1]);
						a.minTo = Std.parseInt(splitRight[0]);
						a.maxTo = Std.parseInt(splitRight[1]);
						a.normalize = true;
					}
				}*/	
			}
		}

		validateControllers();	
   }

   function validateControllers(){
	   for(cont in controllers){
		   cont.profile = getProfile(cont.getHardwareID());
	   }
   }


	@:allow(powerbracelet.Input)
	function update() {
		for(pads in controllers){
			pads.update();
		}
	}

}

class Profile{
	public var name:String = "Generic";
	public var guids:Array<String>;
	public var buttonMapping:Map<ButtonInput, Button>;
	public var axisMapping:Map<AxisInput, Axis>;

	public function new(){
		buttonMapping = new Map<ButtonInput, Button>();
		axisMapping = new Map<AxisInput, Axis>();
	}
}

class GamepadHandler{
	//var modelId:String = "Generic Gamepad";
	var buttons:Map<Int, ButtonState>;
	var pressures:Map<Int, Float>;
	var axis:Map<Int, Float>;
	var id:Int = 0;
	var model:ControllerModel;

	@:allow(powerbracelet.GamepadInput)
	var profile:Profile;

	public var deadzone:Float = 0;

	public function new(id:Int){
		
		buttons = new Map<Int, ButtonState>();
		axis = new Map<Int, Float>();
		pressures = new Map<Int, Float>();
		kha.input.Gamepad.get(id).notify(onGamepadAxis,onGamepadButton);
		this.id = id;
		getModel();

	}

	public function getButtonName(b:ButtonInput): String{
		
		if(profile == null) 
			return "Profile isn't set, unknown";

		if(profile.buttonMapping.exists(b)){
			return '${Std.string(b)} -> ${profile.buttonMapping[b].name}';
		}
		else{
			return 'Profile ${profile.name} doesn\'t contain button defintion ${Std.string(b)}';
		}

		return "";
	}

	public function getAxisName(a:AxisInput): String{
		
		if(profile == null) 
			return "Profile isn't set, unknown";

		if(profile.axisMapping.exists(a)){
			return '${Std.string(a)} -> ${profile.axisMapping[a].name}';
		}
		else{
			return 'Profile ${profile.name} doesn\'t contain axis defintion ${Std.string(a)}';
		}

		return "";
	}

	public function getHardwareID():String{
		return kha.input.Gamepad.get(id).id;
	}

	public function getFriendlyName():String{
		var s:String = kha.input.Gamepad.get(id).id.toLowerCase();

		if(s.indexOf("xbox 360") > -1) return "Xbox Controller";
		if(s.indexOf("vendor: 054c product: 09cc") > -1) return "DS4 Controller";
		return "Generic Controller";
	}

	public function getModel():ControllerModel{

		var s:String = kha.input.Gamepad.get(id).id.toLowerCase();		
		if(s.indexOf("xbox 360") > -1) model = ControllerModel.XBOX_360;
		else if(s.indexOf("vendor: 054c product: 09cc") > -1) model = ControllerModel.DS4;
		else model = ControllerModel.GENERIC;
		return model;
	}

	public function checkRaw(button:Int, state:ButtonState) : Bool{
		return buttons.exists(button) && buttons[button] == state;  
	}

	public function pressureRaw(button:Int) : Float{
		
		return pressures.exists(button) ? pressures[button]:0;
	}

	/**
	 * Returns the axis value (from 0 to 1)
	 * @param  a The axis index to retrieve starting at 0
	 */
	public inline function axisValueRaw(a:Int):Float
	{
		return axis.exists(a) ? (Math.abs(axis[a]) >= deadzone ? axis[a]:0):0; // @TODO Normalize deadzone
	}
	

	var butt:Button;

	public function check(button:ButtonInput, state:ButtonState) : Bool{
		if(profile != null && profile.buttonMapping.exists(button)){
			 butt = profile.buttonMapping[button];
			 /*if(butt.isAxis){
				 buttAxis = axisValueRaw(buttID);
				 if(butt.sign < 0 && buttAxis < 0) return true;
				 else if(butt.sign > 0 && buttAxis > 0) return true;
				 else return false;
			 }*/
			 return buttons.exists(butt.id) && buttons[butt.id] == state;
		}
		return false;
	}

	public function pressure(button:ButtonInput) : Float{

		if(profile != null && profile.buttonMapping.exists(button)){
			 
			 butt = profile.buttonMapping[button];
			 return pressures.exists(butt.id) ? pressures[butt.id]:0;
		}
		return 0;
	}

	/**
	 * Returns the axis value (from 0 to 1)
	 * @param  a The axis index to retrieve starting at 0
	 */
	var axID:Int = 0;
	var ax:Axis;
	var axValue:Float = 0;
	var norm:Float = 0;
	public inline function axisValue(a:AxisInput):Float
	{
		if(profile != null && profile.axisMapping.exists(a)){
			axID = profile.axisMapping[a].id;
			ax = profile.axisMapping[a];

			axValue = axis.exists(axID) ? (Math.abs(axis[axID]) >= deadzone ? axis[axID]:0):0;
			/*if(ax.normalize){
				norm =  normalize(axValue, ax.min, ax.max);			// Oh there goes gravity
				axValue =  (1-norm) * ax.minTo  + norm * ax.maxTo; //lerp back to reality
			}*/
			return axValue; // @TODO Normalize deadzone
		}

		return 0;
		
	}

	function normalize(v:Float, min:Float, max:Float){
		return (v-min)/(max-min);
	}


	public function update() {
		//Reset any button that was on Release this frame

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
	}

	public function onGamepadAxis(ax:Int, value:Float) : Void {
		//if(Math.abs(value) > 0.9)
		//
		//if(ax != 3 && ax != 4 && ax != 9 && ax != 5 && ax != 1 && ax != 2)trace('axis : $ax, Value :$value');
		axis[ax] = value;
	}
	
	public function onGamepadButton(button:Int, value:Float) : Void {
	
		//trace('Button : $button, Value :$value');
		if(value > 0.5)buttons.set(button,Pressed);
		else buttons.set(button,Released);

		pressures.set(button, value);
	}

}

enum ButtonInput{
	WEST_BUTTON;
	SOUTH_BUTTON;
	NORTH_BUTTON;
	EAST_BUTTON;

	LB_BUTTON;
	RB_BUTTON;

	LB_2_BUTTON;
	RB_2_BUTTON;

	SELECT_BUTTON;
	START_BUTTON;
	SHARE_BUTTON;
	LEFT_ANALOGUE_BUTTON;
	RIGHT_ANALOGUE_BUTTON;

	HOME_BUTTON;

	DPAD_UP	;
	DPAD_DOWN;
	DPAD_LEFT;
	DPAD_RIGHT;
}

enum AxisInput{
	LEFT_ANALOGUE_X	;
	LEFT_ANALOGUE_Y	;
	RIGHT_ANALOGUE_X;
	RIGHT_ANALOGUE_Y;
	LEFT_TRIGGER	;
	RIGHT_TRIGGER	;
}


enum ControllerModel{
	GENERIC;
	XBOX_360;
	XBOX_ONE;
	DS4;
}

class Button{
	/*
	/ If this button is transformed as axis
	*/
	//public var isAxis:Bool;
	public var name:String;
	public var id:Int;
	//public var sign:Int = 0;

	function new(){}
}

class Axis{
	public var id:Int = 0;
	//public var min:Float = -1.0;
	//public var max:Float = 1.0;
	//public var minTo:Float = 0;
	//public var maxTo:Float = 0;
	//public var normalize:Bool = false;
	public var name:String;	

	function new(){}
}
