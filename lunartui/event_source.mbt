///|
pub struct EventSource {
  backend : @LunarEvent.EventBackend
}

///|
pub fn EventSource::new() -> EventSource {
  EventSource::{ backend: @LunarEvent.EventBackend::new() }
}

///|
pub fn EventSource::enter_raw_mode(
  self : EventSource,
) -> Result[Unit, @LunarEvent.TerminalError] {
  self.backend.enter_raw_mode()
}

///|
pub fn EventSource::restore_terminal(self : EventSource) -> Unit {
  self.backend.restore_terminal()
}

///|
pub fn EventSource::shutdown(self : EventSource) -> Unit {
  self.backend.shutdown()
}

///|
pub fn EventSource::terminal_size(
  self : EventSource,
) -> Result[@LunarEvent.Size, @LunarEvent.TerminalError] {
  self.backend.terminal_size()
}

///|
pub fn EventSource::poll_event(
  self : EventSource,
  timeout_ms : Int,
) -> @base.Event? {
  match self.backend.poll_event(timeout_ms) {
    Some(event) => to_lunartui_event(event)
    None => None
  }
}
