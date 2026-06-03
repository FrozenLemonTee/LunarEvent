///|
pub(all) enum Event {
  Key(KeyEvent)
  Resize(ResizeEvent)
  Paste(String)
  Mouse(MouseEvent)
  Focus(FocusEvent)
  Unknown(String)
} derive(Eq)

///|
pub(all) enum KeyCode {
  Character
  Enter
  Escape
  Backspace
  Tab
  Left
  Right
  Up
  Down
  Home
  End
  PageUp
  PageDown
  Insert
  Delete
  Function(Int)
  Unknown
} derive(Eq)

///|
pub(all) struct Modifiers {
  shift : Bool
  ctrl : Bool
  alt : Bool
  meta : Bool
} derive(Eq)

///|
pub fn Modifiers::new(
  shift? : Bool = false,
  ctrl? : Bool = false,
  alt? : Bool = false,
  meta? : Bool = false,
) -> Modifiers {
  Modifiers::{ shift, ctrl, alt, meta }
}

///|
pub(all) struct KeyEvent {
  code : KeyCode
  text : String?
  modifiers : Modifiers
} derive(Eq)

///|
pub(all) struct ResizeEvent {
  width : Int
  height : Int
} derive(Eq)

///|
pub(all) enum MouseButton {
  Left
  Right
  Middle
  Back
  Forward
  Unknown
} derive(Eq)

///|
pub(all) enum MouseAction {
  Move
  Down
  Up
  Drag
  Scroll
  Unknown
} derive(Eq)

///|
pub(all) struct MouseEvent {
  button : MouseButton
  action : MouseAction
  x : Int
  y : Int
  modifiers : Modifiers
} derive(Eq)

///|
pub(all) enum FocusState {
  Gained
  Lost
} derive(Eq)

///|
pub(all) struct FocusEvent {
  state : FocusState
} derive(Eq)

///|
pub(all) struct Size {
  width : Int
  height : Int
} derive(Eq)

///|
pub(all) enum TerminalError {
  NativeError(Int)
} derive(Eq)
