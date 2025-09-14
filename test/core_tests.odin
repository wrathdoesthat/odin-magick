package tests

import "core:testing"
import "core:log"
import "core:fmt"
import "core:c"
import "core:strings"
import os "core:os/os2"
import mgck "../"

// (Prints every available format)
// A slight recreation of https://github.com/ImageMagick/ImageMagick/blob/4f2fb31cd7e197fde90291bcc0c300f68c4b2d0f/MagickCore/magick.c#L1185
// @(test)
formats_test :: proc(t: ^testing.T) {
    path := strings.clone_to_cstring(os.args[0])
    defer delete(path)

    mgck.MagickCoreGenesis(path, .MagickFalse)
    defer mgck.MagickCoreTerminus()

    formats : c.size_t
    exception := mgck.AcquireExceptionInfo()
    info_list := mgck.GetMagickInfoList("*", &formats, exception)

    for i in 0 ..< formats {
        info := info_list[i]
        name := strings.concatenate({string(info.name), (mgck.GetMagickBlobSupport(info) == .MagickTrue) ? "*" : ""}, context.temp_allocator)
        caps := (info.encoder != nil) ? "r" : ""
        caps = strings.concatenate({caps, (info.decoder != nil) ? "w" : ""}, context.temp_allocator)
        caps = strings.concatenate({caps, (mgck.GetMagickAdjoin(info) != .MagickFalse) ? "+" : ""}, context.temp_allocator)
        fmt.println(name, info.magick_module, caps)
        free_all(context.temp_allocator)
    }

    fmt.println("* native blob support, r read support, w write support, + support for multiple images")
}