package;

import kha.Framebuffer;
import kha.Color;
import kha.Assets;

import powerbracelet.Input;
import powerbracelet.KeyboardInput;
import kha.input.KeyCode;

class Project {
	public function new() {
		
	}

	public function update():Void {
		if (Input.keyboard.isDown(KeyCode.B)){
			trace(' B B B IM PRESSING B');
		}

		if (Input.keyboard.isDown(KeyCode.A)){
			trace('A A A A A A A A A A AHHHHHH KNOW WHAT TO DO!!!!!');
		}
	}

	public function render(framebuffer:Framebuffer):Void {
		var graphics = framebuffer.g2;
		graphics.begin();
		
		graphics.end();
	}
}
