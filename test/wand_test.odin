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
        log.log(.Error, exception, out, loc)
        mgck.MagickRelinquishMemory(&out)
        testing.fail(t, loc)
    }
}

// https://imagemagick.org/MagickWand/logo_1.htm
@(test)
logo_convert :: proc(t: ^testing.T) {
    mgck.MagickWandGenesis()
    defer mgck.MagickWandTerminus()

    wand := mgck.NewMagickWand()
    defer mgck.DestroyMagickWand(wand)

    testing.expect(t, wand != nil)

    mgck.MagickReadImage(wand, "logo:")
    m_exception(t, wand)

    mgck.MagickWriteImage(wand, "./out/logo_reencoded.jpg")
    m_exception(t, wand)
}

// https://imagemagick.org/MagickWand/extent.htm
@(test)
extent :: proc(t: ^testing.T) {
    mgck.MagickWandGenesis()
    defer mgck.MagickWandTerminus()

    wand := mgck.NewMagickWand()
    defer mgck.DestroyMagickWand(wand)

    pixel_wand := mgck.NewPixelWand()
    defer mgck.DestroyPixelWand(pixel_wand)

    m_exception(t, wand)

    mgck.PixelSetColor(pixel_wand, "blue")
    m_exception(t, wand)

    mgck.MagickReadImage(wand, "logo:")
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
wand_floodfill :: proc(t: ^testing.T) {
    mgck.MagickWandGenesis() 
    defer mgck.MagickWandTerminus()

    wand := mgck.NewMagickWand()
    defer mgck.DestroyMagickWand(wand)

    fc_wand := mgck.NewPixelWand()
    defer mgck.DestroyPixelWand(fc_wand)

    bc_wand := mgck.NewPixelWand()
    defer mgck.DestroyPixelWand(bc_wand)

    mgck.MagickReadImage(wand, "logo:")
    m_exception(t, wand)

    mgck.PixelSetColor(fc_wand, "none")
    mgck.PixelSetColor(bc_wand, "white")
    m_exception(t, wand)

    channel := mgck.ParseChannelOption("rgba")
    mgck.MagickFloodfillPaintImage(wand, fc_wand, 20, bc_wand, 0, 0, .MagickFalse)
    m_exception(t, wand)

    mgck.MagickWriteImage(wand, "./out/logo_paintflood.png")
    m_exception(t, wand)
}

// https://imagemagick.org/MagickWand/reflect.htm
@(test)
reflect :: proc(t: ^testing.T) {
    mgck.MagickWandGenesis() 
    defer mgck.MagickWandTerminus()

    wand := mgck.NewMagickWand()
    defer mgck.DestroyMagickWand(wand)

    gradient_wand := mgck.NewMagickWand()
    defer mgck.DestroyMagickWand(gradient_wand)

    mgck.MagickReadImage(wand, "logo:")
    w := mgck.MagickGetImageWidth(wand)
    h := mgck.MagickGetImageHeight(wand)

    mgck.MagickSetImageAlphaChannel(wand, .DeactivateAlphaChannel)

    reflection_wand := mgck.CloneMagickWand(wand)
    defer mgck.DestroyMagickWand(reflection_wand)

    mgck.MagickResizeImage(reflection_wand, w, h / 2, .LanczosFilter)
    mgck.MagickFlipImage(reflection_wand)

    mgck.MagickSetSize(gradient_wand, w, h / 2)
    mgck.MagickReadImage(gradient_wand, "gradient:white-black")

    mgck.MagickCompositeImage(reflection_wand, gradient_wand, .CopyAlphaCompositeOp, .MagickFalse, 0, 0)
    mgck.MagickAddImage(wand, reflection_wand)

    mgck.MagickSetFirstIterator(wand)
    output_wand := mgck.MagickAppendImages(wand, .MagickTrue)
    defer mgck.DestroyMagickWand(output_wand)

    mgck.MagickWriteImage(output_wand, "./out/logo_reflect.png")
}