///|
pub struct EventBackend {}

///|
pub fn EventBackend::new() -> EventBackend {
  @lte_native.init_backend() |> ignore
  EventBackend::{  }
}

///|
pub fn EventBackend::shutdown(self : EventBackend) -> Unit {
  ignore(self)
  @lte_native.shutdown() |> ignore
}

///|
pub fn EventBackend::enter_raw_mode(
  self : EventBackend,
) -> Result[Unit, TerminalError] {
  ignore(self)
  match @lte_native.enter_raw_mode() {
    0 => Ok(())
    _ => Err(TerminalError::NativeError(@lte_native.last_error_code()))
  }
}

///|
pub fn EventBackend::restore_terminal(self : EventBackend) -> Unit {
  ignore(self)
  @lte_native.restore_terminal() |> ignore
}

///|
pub fn EventBackend::terminal_size(
  self : EventBackend,
) -> Result[Size, TerminalError] {
  ignore(self)
  let width = @lte_native.terminal_width()
  let height = @lte_native.terminal_height()
  if width > 0 && height > 0 {
    Ok(Size::{ width, height })
  } else {
    Err(TerminalError::NativeError(@lte_native.last_error_code()))
  }
}

///|
pub fn EventBackend::poll_event(self : EventBackend, timeout_ms : Int) -> Event? {
  ignore(self)
  match @lte_native.poll_event(timeout_ms) {
    @lte_native.EVENT_KIND_NONE => None
    @lte_native.EVENT_KIND_KEY => Some(Event::Key(build_key_event()))
    @lte_native.EVENT_KIND_RESIZE => Some(Event::Resize(build_resize_event()))
    @lte_native.EVENT_KIND_PASTE => Some(Event::Paste(read_text()))
    @lte_native.EVENT_KIND_MOUSE => Some(Event::Mouse(build_mouse_event()))
    @lte_native.EVENT_KIND_FOCUS => Some(Event::Focus(build_focus_event()))
    @lte_native.EVENT_KIND_UNKNOWN => Some(Event::Unknown(read_unknown()))
    @lte_native.EVENT_KIND_ERROR => None
    _ => None
  }
}

///|
fn build_key_event() -> KeyEvent {
  let text = read_text()
  KeyEvent::{
    code: read_key_code(),
    text: if text.length() > 0 {
      Some(text)
    } else {
      None
    },
    modifiers: read_modifiers(),
  }
}

///|
fn build_resize_event() -> ResizeEvent {
  ResizeEvent::{
    width: @lte_native.event_resize_width(),
    height: @lte_native.event_resize_height(),
  }
}

///|
fn build_mouse_event() -> MouseEvent {
  MouseEvent::{
    button: read_mouse_button(),
    action: read_mouse_action(),
    x: @lte_native.event_mouse_x(),
    y: @lte_native.event_mouse_y(),
    modifiers: read_modifiers(),
  }
}

///|
fn build_focus_event() -> FocusEvent {
  FocusEvent::{
    state: if @lte_native.event_focus_state() == @lte_native.FOCUS_STATE_GAINED {
      FocusState::Gained
    } else {
      FocusState::Lost
    },
  }
}

///|
fn read_key_code() -> KeyCode {
  match @lte_native.event_key_code() {
    @lte_native.KEY_CODE_CHARACTER => KeyCode::Character
    @lte_native.KEY_CODE_ENTER => KeyCode::Enter
    @lte_native.KEY_CODE_ESCAPE => KeyCode::Escape
    @lte_native.KEY_CODE_BACKSPACE => KeyCode::Backspace
    @lte_native.KEY_CODE_TAB => KeyCode::Tab
    @lte_native.KEY_CODE_LEFT => KeyCode::Left
    @lte_native.KEY_CODE_RIGHT => KeyCode::Right
    @lte_native.KEY_CODE_UP => KeyCode::Up
    @lte_native.KEY_CODE_DOWN => KeyCode::Down
    @lte_native.KEY_CODE_HOME => KeyCode::Home
    @lte_native.KEY_CODE_END => KeyCode::End
    @lte_native.KEY_CODE_PAGE_UP => KeyCode::PageUp
    @lte_native.KEY_CODE_PAGE_DOWN => KeyCode::PageDown
    @lte_native.KEY_CODE_INSERT => KeyCode::Insert
    @lte_native.KEY_CODE_DELETE => KeyCode::Delete
    @lte_native.KEY_CODE_FUNCTION => KeyCode::Function(@lte_native.event_key_number())
    _ => KeyCode::Unknown
  }
}

///|
fn read_modifiers() -> Modifiers {
  let mask = @lte_native.event_modifiers()
  Modifiers::{
    shift: (mask & @lte_native.MODIFIER_SHIFT) != 0,
    ctrl: (mask & @lte_native.MODIFIER_CTRL) != 0,
    alt: (mask & @lte_native.MODIFIER_ALT) != 0,
    meta: (mask & @lte_native.MODIFIER_META) != 0,
  }
}

///|
fn read_mouse_button() -> MouseButton {
  match @lte_native.event_mouse_button() {
    @lte_native.MOUSE_BUTTON_LEFT => MouseButton::Left
    @lte_native.MOUSE_BUTTON_RIGHT => MouseButton::Right
    @lte_native.MOUSE_BUTTON_MIDDLE => MouseButton::Middle
    @lte_native.MOUSE_BUTTON_BACK => MouseButton::Back
    @lte_native.MOUSE_BUTTON_FORWARD => MouseButton::Forward
    _ => MouseButton::Unknown
  }
}

///|
fn read_mouse_action() -> MouseAction {
  match @lte_native.event_mouse_action() {
    @lte_native.MOUSE_ACTION_MOVE => MouseAction::Move
    @lte_native.MOUSE_ACTION_DOWN => MouseAction::Down
    @lte_native.MOUSE_ACTION_UP => MouseAction::Up
    @lte_native.MOUSE_ACTION_DRAG => MouseAction::Drag
    @lte_native.MOUSE_ACTION_SCROLL => MouseAction::Scroll
    _ => MouseAction::Unknown
  }
}

///|
fn read_text() -> String {
  let mut text = ""
  for i in 0..<@lte_native.event_text_len() {
    let code = @lte_native.event_text_char_at(i)
    if code >= 0 {
      text = text + String::make(1, code.unsafe_to_char())
    }
  }
  text
}

///|
fn read_unknown() -> String {
  let mut text = ""
  for i in 0..<@lte_native.event_unknown_len() {
    let code = @lte_native.event_unknown_char_at(i)
    if code >= 0 {
      text = text + String::make(1, code.unsafe_to_char())
    }
  }
  text
}
