pub async fn read_event() -> Option[Event] {
  let stdin = @stdio.stdin
  let reader = @io.BufferedReader::new(stdin)
  let buf : FixedArray[Byte] = []
  let len = reader.read(buf)
  if len == 0 { return None }

  // parser::parse_event(buf)
  Some(Key(KeyEvent::new(KeyCode::Char('A'), KeyModifiers::new(false, false, false)))) // placeholder
}