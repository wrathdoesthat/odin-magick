# Odin Magick
Odin bindings for the [ImageMagick C library](https://imagemagick.org/)

Currently only works on Windows/Linux(Maybe) 

# Example (MagickWand floodfilling black background)
```go
package main
import mgck "odin-magick"

main :: proc() {
    mgck.MagickWandGenesis() 
    defer mgck.MagickWandTerminus()

    wand := mgck.NewMagickWand()
    defer mgck.DestroyMagickWand(wand)

    fc_wand := mgck.NewPixelWand()
    defer mgck.DestroyPixelWand(fc_wand)

    bc_wand := mgck.NewPixelWand()
    defer mgck.DestroyPixelWand(bc_wand)

    mgck.MagickReadImage(wand, "./res/bill.png")

    mgck.PixelSetColor(fc_wand, "blue")
    mgck.PixelSetColor(bc_wand, "#00000000")

    channel := mgck.ParseChannelOption("rgba")
    mgck.MagickFloodfillPaintImage(wand, fc_wand, 20, bc_wand, 0, 0, .MagickFalse)

    mgck.MagickWriteImage(wand, "./out/floodfilled_bill.png")
}
```