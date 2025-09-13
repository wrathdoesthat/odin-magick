package tests

import "core:testing"
import "core:log"
import "core:fmt"
import "core:c"
import mgck "../"
import "core:image/jpeg"

m_exception :: proc(t: ^testing.T, wand: ^mgck.MagickWand, loc := #caller_location) {
    exception : mgck.ExceptionType
    out := mgck.MagickGetException(wand, &exception)

    if exception != .UndefinedException {
        log.log(.Error, exception,  out)
        mgck.MagickRelinquishMemory(&out)
        testing.fail(t, loc)
    }
}

// https://imagemagick.org/MagickWand/logo_1.htm
@(test)
wand_logo_convert_test :: proc(t: ^testing.T) {
    mgck.MagickWandGenesis()
    defer mgck.MagickWandTerminus()

    wand := mgck.NewMagickWand()
    defer mgck.DestroyMagickWand(wand)

    testing.expect(t, wand != nil)

    mgck.MagickReadImage(wand, "./res/odin.png")
    m_exception(t, wand)

    mgck.MagickWriteImage(wand, "./out/logo_reencoded.jpg")
    m_exception(t, wand)
}

// https://imagemagick.org/MagickWand/extent.htm
@(test)
wand_extent_test :: proc(t: ^testing.T) {
    mgck.MagickWandGenesis()
    defer mgck.MagickWandTerminus()

    wand := mgck.NewMagickWand()
    defer mgck.DestroyMagickWand(wand)

    pixel_wand := mgck.NewPixelWand()
    defer mgck.DestroyPixelWand(pixel_wand)

    m_exception(t, wand)

    mgck.PixelSetColor(pixel_wand, "blue")
    m_exception(t, wand)

    mgck.MagickReadImage(wand, "./res/odin.png")
    m_exception(t, wand)

    w := mgck.MagickGetImageWidth(wand)
    h := mgck.MagickGetImageHeight(wand)

    mgck.MagickSetImageBackgroundColor(wand, pixel_wand)
    m_exception(t, wand)

    x := -(w/2)
    y := -(h/2)

    mgck.MagickExtentImage(wand, w * 2, h * 2, cast(c.ssize_t)x, cast(c.ssize_t)y)
    m_exception(t, wand)

	mgck.MagickWriteImage(wand, "./out/logo_extent.png")
    m_exception(t, wand)
}

// https://imagemagick.org/MagickWand/floodfill.htm
@(test)
wand_floodfill_test :: proc(t: ^testing.T) {
    mgck.MagickWandGenesis() 
    defer mgck.MagickWandTerminus()

    wand := mgck.NewMagickWand()
    defer mgck.DestroyMagickWand(wand)

    fc_wand := mgck.NewPixelWand()
    defer mgck.DestroyPixelWand(fc_wand)

    bc_wand := mgck.NewPixelWand()
    defer mgck.DestroyPixelWand(bc_wand)

    mgck.MagickReadImage(wand, "./res/bill.png")
    m_exception(t, wand)

    mgck.PixelSetColor(fc_wand, "blue")
    mgck.PixelSetColor(bc_wand, "#00000000")
    m_exception(t, wand)

    channel := mgck.ParseChannelOption("rgba")
    mgck.MagickFloodfillPaintImage(wand, fc_wand, 20, bc_wand, 0, 0, .MagickFalse)
    m_exception(t, wand)

    mgck.MagickWriteImage(wand, "./out/floodfilled_bill.png")
    m_exception(t, wand)
}