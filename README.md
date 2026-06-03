# LunarEvent

LunarEvent is a MoonBit-friendly terminal event layer backed by the stable C FFI surface published by [TerminalEvent](https://github.com/FrozenLemonTee/TerminalEvent).

It keeps the C and C++ implementation boundary outside downstream MoonBit projects. Applications import MoonBit packages only; they do not include or reference TerminalEvent's C++ headers or source files.

## Package Boundary

- `FrozenLemonTee/TerminalEvent/moonbit/lte_native` owns the raw `lte_*` C ABI binding.
- `FrozenLemonTee/LunarEvent` maps the raw ABI into MoonBit `Event` and `EventBackend` types.
- `FrozenLemonTee/LunarEvent/lunartui` adapts LunarEvent events into LunarTUI `@base.Event` values.
- `FrozenLemonTee/LunarTUI` remains independent from LunarEvent and TerminalEvent.

The dependency direction is intentionally one-way at each layer:

```text
TerminalEvent C++ core -> TerminalEvent C ABI -> TerminalEvent MoonBit FFI -> LunarEvent -> LunarTUI adapter -> application
```

## Installation

```bash
moon add FrozenLemonTee/LunarEvent
```

Or add it manually to `moon.mod`:

```moonbit
import {
  "FrozenLemonTee/LunarEvent@0.1.0",
}
```

LunarEvent currently targets MoonBit native builds.

## Core Event API

The root package exposes a terminal event model that is independent from LunarTUI widgets:

- `Event::Key(KeyEvent)` for keyboard input.
- `Event::Resize(ResizeEvent)` for terminal size changes.
- `Event::Paste(String)` for pasted text.
- `Event::Mouse(MouseEvent)` for mouse activity.
- `Event::Focus(FocusEvent)` for focus gained/lost notifications.
- `Event::Unknown(String)` for raw input that the backend could not classify.

`EventBackend` owns the runtime bridge to TerminalEvent's C FFI:

```moonbit
let backend = @LunarEvent.EventBackend::new()
match backend.enter_raw_mode() {
  Ok(_) => {
    match backend.poll_event(32) {
      Some(event) => {
        // Route the event into your application.
        ignore(event)
      }
      None => ()
    }
    backend.restore_terminal()
  }
  Err(_) => ()
}
backend.shutdown()
```

The timeout passed to `poll_event` is in milliseconds. `None` means no event was available or the backend reported no event.

## LunarTUI Adapter

The `lunartui` subpackage is the default bridge for LunarTUI applications:

```moonbit
let source = @lunartui.EventSource::new()
match source.enter_raw_mode() {
  Ok(_) => {
    match source.poll_event(32) {
      Some(event) => {
        // event is a LunarTUI @base.Event
        ignore(event)
      }
      None => ()
    }
    source.restore_terminal()
  }
  Err(_) => ()
}
source.shutdown()
```

The adapter maps LunarEvent values into LunarTUI's terminal-agnostic event protocol:

| LunarEvent | LunarTUI |
| --- | --- |
| `Event::Key` | `@base.Event::key` |
| `Event::Resize` | `@base.Event::resize` |
| `Event::Paste` | `@base.Event::text_input` |
| `Event::Mouse` | `@base.Event::mouse` |
| `Event::Focus` | `@base.Event::focus` |
| `Event::Unknown` | dropped by the adapter |

## Backend Notes

The current TerminalEvent backend is POSIX-oriented. On Windows, raw mode may report unavailable unless the program is executed in a compatible POSIX terminal environment.

## Related Projects

- [TerminalEvent](https://github.com/FrozenLemonTee/TerminalEvent): C++ terminal event backend and C ABI.
- [LunarTUI](https://github.com/FrozenLemonTee/LunarTUI): MoonBit TUI widgets, layouts, rendering, and event protocol.
- [TextEditor](https://github.com/FrozenLemonTee/TextEditor): interactive demo using TerminalEvent, LunarEvent, and LunarTUI together.
