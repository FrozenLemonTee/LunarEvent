pub(all) enum KeyCode {
  Char(Char)
  Enter
  Esc
  Backspace
  Left
  Right
  Up
  Down
  F(Int)
}

pub struct KeyModifiers {
  ctrl: Bool
  alt: Bool
  shift: Bool
}

pub fn KeyModifiers::new(ctrl : Bool, alt : Bool, shift : Bool) -> KeyModifiers {
  KeyModifiers::{ ctrl, alt, shift }
}

pub struct KeyEvent {
  code: KeyCode
  modifiers: KeyModifiers
}

pub fn KeyEvent::new(code: KeyCode, modifiers: KeyModifiers) -> KeyEvent {
  KeyEvent::{ code, modifiers }
}