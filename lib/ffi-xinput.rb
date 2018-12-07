require "ffi"

module FFI::XInput

  extend FFI::Library

  ffi_lib "xinput1_3"
  ffi_convention :stdcall
  
  attach_function :XInputEnable, [:bool], :void
  attach_function :XInputGetState, [:ulong, :pointer], :ulong
  attach_function :XInputSetState, [:ulong, :pointer], :ulong
  
  class XINPUT_GAMEPAD < FFI::Struct
    
    layout :wButtons, :ushort,
      :bLeftTrigger, :uchar,
      :bRightTrigger, :uchar,
      :sThumbLX, :short,
      :sThumbLY, :short,
      :sThumbRX, :short,
      :sThumbRY, :short
    
  end
  
  class XINPUT_STATE < FFI::Struct
    
    layout :dwPacketNumber, :ulong,
      :Gamepad, XINPUT_GAMEPAD
    
  end
  
  class XINPUT_VIBRATION < FFI::Struct
    
    layout :wLeftMotorSpeed, :ushort,
      :wRightMotorSpeed, :ushort
    
  end

  ERROR_SUCCESS = 0x0000
  ERROR_DEVICE_NOT_CONNECTED = 0x048F
  
  XINPUT_GAMEPAD_DPAD_UP	= 0x0001
  XINPUT_GAMEPAD_DPAD_DOWN	= 0x0002
  XINPUT_GAMEPAD_DPAD_LEFT	= 0x0004
  XINPUT_GAMEPAD_DPAD_RIGHT	= 0x0008
  XINPUT_GAMEPAD_START	= 0x0010
  XINPUT_GAMEPAD_BACK	= 0x0020
  XINPUT_GAMEPAD_LEFT_THUMB	= 0x0040
  XINPUT_GAMEPAD_RIGHT_THUMB	= 0x0080
  XINPUT_GAMEPAD_LEFT_SHOULDER	= 0x0100
  XINPUT_GAMEPAD_RIGHT_SHOULDER	= 0x0200
  XINPUT_GAMEPAD_A	= 0x1000
  XINPUT_GAMEPAD_B	= 0x2000
  XINPUT_GAMEPAD_X	= 0x4000
  XINPUT_GAMEPAD_Y	= 0x8000
  
end

class XInput
  
  include FFI::XInput
  extend FFI::XInput
  
  attr_reader :id
  
  def initialize(id)
    @id = id
  end
  
  def state
    XInput.state(@id)
  end

  def vibrate(left = 0, right = 0)
    XInput.vibrate(@id, left, right)
  end

  def connected?
    XInput.state(@id)[:connected]
  def
  
  def self.state(id)
    state = XINPUT_STATE.new
    result = XInputGetState(id, state)
    gamepad = state[:Gamepad]
    
    state = {}
    
    state[:connected] = result == ERROR_SUCCESS
    state[:up] = gamepad[:wButtons] & XINPUT_GAMEPAD_DPAD_UP > 0
    state[:down] = gamepad[:wButtons] & XINPUT_GAMEPAD_DPAD_DOWN > 0
    state[:left] = gamepad[:wButtons] & XINPUT_GAMEPAD_DPAD_LEFT > 0
    state[:right] = gamepad[:wButtons] & XINPUT_GAMEPAD_DPAD_RIGHT > 0
    state[:start] = gamepad[:wButtons] & XINPUT_GAMEPAD_START > 0
    state[:back] = gamepad[:wButtons] & XINPUT_GAMEPAD_BACK > 0
    state[:left_thumb] = gamepad[:wButtons] & XINPUT_GAMEPAD_LEFT_THUMB > 0
    state[:right_thumb] = gamepad[:wButtons] & XINPUT_GAMEPAD_RIGHT_THUMB > 0
    state[:left_shoulder] = gamepad[:wButtons] & XINPUT_GAMEPAD_LEFT_SHOULDER > 0
    state[:right_shoulder] = gamepad[:wButtons] & XINPUT_GAMEPAD_RIGHT_SHOULDER > 0
    state[:a] = gamepad[:wButtons] & XINPUT_GAMEPAD_A > 0
    state[:b] = gamepad[:wButtons] & XINPUT_GAMEPAD_B > 0
    state[:x] = gamepad[:wButtons] & XINPUT_GAMEPAD_X > 0
    state[:y] = gamepad[:wButtons] & XINPUT_GAMEPAD_Y > 0
    state[:left_trigger] = gamepad[:bLeftTrigger].to_f / 0xFF.to_f
    state[:right_trigger] = gamepad[:bRightTrigger].to_f / 0xFF.to_f
    state[:left_thumb_x] = gamepad[:sThumbLX].to_f / 0x8000.to_f
    state[:left_thumb_y] = gamepad[:sThumbLY].to_f / 0x8000.to_f
    state[:right_thumb_x] = gamepad[:sThumbRX].to_f / 0x8000.to_f
    state[:right_thumb_y] = gamepad[:sThumbRY].to_f / 0x8000.to_f
    
    state
  end

  def self.vibrate(id, left = 0, right = 0)
    vibration = XINPUT_VIBRATION.new
    vibration[:wLeftMotorSpeed] = left * 0xFFFF
    vibration[:wRightMotorSpeed] = right * 0xFFFF

    XInputSetState(id, vibration)
  end

  def self.connected?
    self.state(@id)[:connected]
  def

end
