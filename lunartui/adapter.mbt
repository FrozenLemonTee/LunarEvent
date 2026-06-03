///|
pub fn to_lunartui_event(event : @LunarEvent.Event) -> @base.Event? {
  match event {
    @LunarEvent.Event::Key(key) => Some(@base.Event::key(convert_key(key)))
    @LunarEvent.Event::Resize(size) =>
      Some(
        @base.Event::resize(@base.ResizeEvent::{
          width: size.width,
          height: size.height,
        }),
      )
    @LunarEvent.Event::Paste(text) =>
      Some(@base.Event::text_input(@base.TextInputEvent::{ text, }))
    @LunarEvent.Event::Mouse(mouse) => convert_mouse(mouse)
    @LunarEvent.Event::Focus(focus) =>
      Some(
        @base.Event::focus(@base.FocusEvent::{
          state: match focus.state {
            @LunarEvent.FocusState::Gained => @base.FocusState::Gained
            @LunarEvent.FocusState::Lost => @base.FocusState::Lost
          },
        }),
      )
    @LunarEvent.Event::Unknown(_) => None
  }
}

///|
fn convert_key(key : @LunarEvent.KeyEvent) -> @base.KeyEvent {
  @base.KeyEvent::{
    state: @base.KeyState::Down,
    code: convert_key_code(key),
    text: key.text,
    modifiers: convert_modifiers(key.modifiers),
    repeat_count: 1,
  }
}

///|
fn convert_key_code(key : @LunarEvent.KeyEvent) -> @base.KeyCode {
  match key.code {
    @LunarEvent.KeyCode::Character =>
      match key.text {
        Some(" ") => @base.KeyCode::Space
        _ => @base.KeyCode::Character
      }
    @LunarEvent.KeyCode::Enter => @base.KeyCode::Enter
    @LunarEvent.KeyCode::Escape => @base.KeyCode::Esc
    @LunarEvent.KeyCode::Backspace => @base.KeyCode::Backspace
    @LunarEvent.KeyCode::Tab => @base.KeyCode::Tab
    @LunarEvent.KeyCode::Left => @base.KeyCode::Left
    @LunarEvent.KeyCode::Right => @base.KeyCode::Right
    @LunarEvent.KeyCode::Up => @base.KeyCode::Up
    @LunarEvent.KeyCode::Down => @base.KeyCode::Down
    @LunarEvent.KeyCode::Home => @base.KeyCode::Home
    @LunarEvent.KeyCode::End => @base.KeyCode::End
    @LunarEvent.KeyCode::PageUp => @base.KeyCode::PageUp
    @LunarEvent.KeyCode::PageDown => @base.KeyCode::PageDown
    @LunarEvent.KeyCode::Insert => @base.KeyCode::Insert
    @LunarEvent.KeyCode::Delete => @base.KeyCode::Delete
    @LunarEvent.KeyCode::Function(n) => convert_function_key(n)
    @LunarEvent.KeyCode::Unknown => @base.KeyCode::Character
  }
}

///|
fn convert_function_key(n : Int) -> @base.KeyCode {
  match n {
    1 => @base.KeyCode::F1
    2 => @base.KeyCode::F2
    3 => @base.KeyCode::F3
    4 => @base.KeyCode::F4
    5 => @base.KeyCode::F5
    6 => @base.KeyCode::F6
    7 => @base.KeyCode::F7
    8 => @base.KeyCode::F8
    9 => @base.KeyCode::F9
    10 => @base.KeyCode::F10
    11 => @base.KeyCode::F11
    12 => @base.KeyCode::F12
    _ => @base.KeyCode::Character
  }
}

///|
fn convert_modifiers(mods : @LunarEvent.Modifiers) -> @base.Modifiers {
  @base.Modifiers::{
    shift: mods.shift,
    ctrl: mods.ctrl,
    alt: mods.alt,
    meta: mods.meta,
  }
}

///|
fn convert_mouse(mouse : @LunarEvent.MouseEvent) -> @base.Event? {
  match
    (convert_mouse_action(mouse.action), convert_mouse_button(mouse.button)) {
    (Some(state), button) =>
      Some(
        @base.Event::mouse(@base.MouseEvent::{
          state,
          button,
          scroll: None,
          x: mouse.x,
          y: mouse.y,
          modifiers: convert_modifiers(mouse.modifiers),
        }),
      )
    _ => None
  }
}

///|
fn convert_mouse_button(button : @LunarEvent.MouseButton) -> @base.MouseButton? {
  match button {
    @LunarEvent.MouseButton::Left => Some(@base.MouseButton::Left)
    @LunarEvent.MouseButton::Right => Some(@base.MouseButton::Right)
    @LunarEvent.MouseButton::Middle => Some(@base.MouseButton::Middle)
    @LunarEvent.MouseButton::Back => Some(@base.MouseButton::Back)
    @LunarEvent.MouseButton::Forward => Some(@base.MouseButton::Forward)
    @LunarEvent.MouseButton::Unknown => None
  }
}

///|
fn convert_mouse_action(action : @LunarEvent.MouseAction) -> @base.MouseState? {
  match action {
    @LunarEvent.MouseAction::Move => Some(@base.MouseState::Move)
    @LunarEvent.MouseAction::Down => Some(@base.MouseState::Down)
    @LunarEvent.MouseAction::Up => Some(@base.MouseState::Up)
    @LunarEvent.MouseAction::Drag => Some(@base.MouseState::Drag)
    @LunarEvent.MouseAction::Scroll => Some(@base.MouseState::Scroll)
    @LunarEvent.MouseAction::Unknown => None
  }
}
