# Odin Magick
Odin bindings for the [ImageMagick C library](https://imagemagick.org/)

Currently only works on Windows/Linux(Maybe) 

# Example (Creates the image below)
```go
package main
import mgck "odin-magick"

main :: proc() {
    mgck.MagickWandGenesis() 
    defer mgck.MagickWandTerminus()

    wand := mgck.NewMagickWand()
    defer mgck.DestroyMagickWand(wand)

    gradient_wand := mgck.NewMagickWand()
    defer mgck.DestroyMagickWand(gradient_wand)

    mgck.MagickReadImage(wand, "./res/bill.png")
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

    mgck.MagickWriteImage(output_wand, "./out/bill_reflect.png")
}
```
![Resulting image](img/bill_reflect.png)