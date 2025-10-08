package magick_helpers

import mgk "../"

import "core:mem"
import "core:fmt"
import "core:c"

ASSERT_ON_MAGICK_EXCEPTION :: #config(ASSERT_ON_MAGICK_EXCEPTION, false)

// Implemented as macros in the C examples 
when ASSERT_ON_MAGICK_EXCEPTION {
    handle_exception :: #force_inline proc(exc: ^mgk.ExceptionInfo, bail := true, loc := #caller_location) {
        if exc.severity > .UndefinedException {
            fmt.println("Magick exception caught description:", cstring(exc.description), "reason:", cstring(exc.reason), "loc:", loc)
            if bail == true {
                assert(false, "")
            }
        }
    }
} else {
    handle_exception :: #force_inline proc(exc: ^mgk.ExceptionInfo, bail := false, loc := #caller_location) {
        if exc.severity > .UndefinedException {
            fmt.println("Magick exception caught description:", cstring(exc.description), "reason:", cstring(exc.reason), "loc:", loc)
            if bail == true {
                assert(false, "")
            }
        }
    }
}

MagickPath :: [mgk.MagickPathExtent]c.char
cstring_to_magick_path :: proc(str: cstring) -> MagickPath {
    ret : MagickPath
    mem.copy(&ret, cast(rawptr)str, len(str))
    return ret
}

string_to_magick_path :: proc(str: string) -> MagickPath {
    ret : MagickPath
    mem.copy(&ret, raw_data(str), len(str))
    return ret
}

to_magick_path :: proc {
    cstring_to_magick_path,
    string_to_magick_path,
}