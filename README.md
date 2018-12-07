ffi-xinput
===============

ffi-xinput is an FFI wrapper that can be used to interface with the XInput controller library for Windows. It can read the state of any controller hooked up to a system that supports XInput, or activate it's rumble feature.

Installation
------

```
gem install ffi-xinput
```

Usage
------

Enable XInput support in your project:
```
require "ffi-xinput"
```

Create a new XInput controller instance:
```
xinput = XInput.new(controller_id) #id can be 0-3
```

Check if a controller is connected:
```
xinput.connected?
XInput.connected?(controller_id)
```

Get the state of a controller (returns a hash containing the state of all controller buttons/axis):
```
xinput.state
XInput.state(controller_id)
```

Set the vibration level for the left/right motor:
```
xinput.vibrate(left_motor, right_motor) #values can range from 0.0 to 1.0
XInput.vibrate(controller_id, left_motor, right_motor)
```

License
------

This library is licensed under the [MIT license](http://www.opensource.org/licenses/mit-license.php).
