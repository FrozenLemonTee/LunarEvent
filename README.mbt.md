# FrozenLemonTee/LunarEvent

MoonBit terminal event layer backed by TerminalEvent's C FFI surface.

Package boundaries:

- `FrozenLemonTee/TerminalEvent/moonbit/lte_native` owns the raw `lte_*` C ABI binding.
- `FrozenLemonTee/LunarEvent` maps that ABI into MoonBit `Event` / `EventBackend` types.
- `FrozenLemonTee/LunarEvent/lunartui` adapts `Event` into LunarTUI `@base.Event` and exposes `EventSource`.

LunarEvent does not include or reference TerminalEvent C++ headers or source files. It only imports the MoonBit FFI package.
