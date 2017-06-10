#PowerBracelet -  Simplified Kha Input Lib

A Simple input library to get you quickly started.

#How To

PowerBracelet provides several classes to interface with:

- KeyboardInput
- MouseInput
- SensorInput
- TouchInput
- GamepadInput

Each can be accessed with the **powerbracelet.Input** class

Example:

    if (Input.keyboard.isDown(KeyCode.B)){
			trace('PRESSING THE 'B' KEY');
		}


Make sure the update function **powerbracelet.Input.update** is called in your update loop.
It takes a delta time to process touch input durations.

#

#Virtual Input

In addition to the usual input, this lib provides a simple way of
abstracting your input with virtual buttons and axis.
Each virtual button or axis is a container that holds an input state which can then be used instead of direct input calls.
This way you can allow multiple inputs do the same.

#How to

Initialize

    //Only call once in your code
    // In the init of your system most likely
    powerbracelet.VirtualInput.init();

A keyboard controller :

    //Usual imports
    import powerbracelet.VirtualInput;
    import powerbracelet.VirtualButton;
    import powerbracelet.VirtualAxis;
    import powerbracelet.Input;
    import powerbracelet.Key;

    //Create a new Virtual button
    var vButton:VirtualButton;

    public function new(){
       vButton = VirtualInput.getButton("jump");
       if(vButton == null){
           vButton = new VirtualButton("jump");           
           VirtualInput.addButton(vButton);
       }
    }
    //Probably called somewhere in your update loop
    public function void update(){
        vButton.update(Input.keyboard.isDown(Key.SPACE));
    }

A GamePad controller :

    //Usual imports
    import powerbracelet.VirtualInput;
    import powerbracelet.VirtualButton;
    import powerbracelet.VirtualAxis;
    import powerbracelet.ButtonState;
    import powerbracelet.Input;

    //Create a new Virtual button
    var vButton:VirtualButton;

    public function new(){

        //Add controller with id 0
        Input.gamepad.addController(0);

       vButton = VirtualInput.getButton("jump");
       if(vButton == null){
           vButton = new VirtualButton("jump");
           VirtualInput.addButton(vButton);
       }


    }

    //Probably called somewhere in your update loop
    public function void update(){
        //0 = first button
        //Button state is the requested state to check
        var isPressed:Bool  = Input.gamepad.check(0,ButtonState.Pressed)   ;
        vButton.update(isPressed);
    }

In your character controller


        var jumpButton:VirtualButton;

        public function new(){

        //Add controller with id 0
        Input.gamepad.addController(0);

        jumpButton = VirtualInput.getButton("jump");
            if(jumpButton == null){
               throw new Error("Button isn't defined");
            }
        }

        public function update(){
            if(jumpButton.pressed){
                //Do jump
            }

            //Or

            if(VirtualInput.buttonPressed("jump")){
                //Do Jump
            }
        }

Contribute if you can!