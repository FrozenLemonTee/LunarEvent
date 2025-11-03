pub struct EventStream {
  buf : Array[Event]
}

pub fn EventStream::new(stream : Array[Event]) -> EventStream {
  EventStream::{ buf : stream }
}

pub fn EventStream::add(self : EventStream, event : Event) -> EventStream {
  self.buf.push(event)
  self
}

pub fn EventStream::add_all(self : EventStream, stream : Array[Event]) -> EventStream {
  self.buf.append(stream)
  self
}

pub impl Add for EventStream with add(self : EventStream, other : EventStream) -> EventStream {
  self.add_all(other.buf)
}