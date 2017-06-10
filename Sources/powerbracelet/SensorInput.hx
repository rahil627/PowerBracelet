package powerbracelet;

import kha.input.Sensor;
import kha.input.SensorType;

class SensorInput {

public var accX(default, null):Float;
public var accY(default, null):Float;
public var accZ(default, null):Float;

public var gyroX(default, null):Float;
public var gyroY(default, null):Float;
public var gyroZ(default, null):Float;

public var accelerometerIsSupported(get, null):Bool;
function get_accelerometerIsSupported():Bool {
	return Sensor.get(SensorType.Accelerometer) != null;
}

public var gyroscopeIsSupported(get, null):Bool;
function get_gyroscopeIsSupported():Bool {
	return Sensor.get(SensorType.Gyroscope) != null;
}

 public function new(){
	 if(accelerometerIsSupported)
	 	Sensor.get(SensorType.Accelerometer).notify(onAcc);
	if(gyroscopeIsSupported)
		Sensor.get(SensorType.Gyroscope).notify(onGyro);
 }

 function onAcc(x:Float, y:Float, z:Float){
	 accX = x;
	 accY = y;
	 accZ = z;
 }

 function onGyro(x:Float, y:Float, z:Float){
	 gyroX = x;
	 gyroY = y;
	 gyroZ = z;
 }
}