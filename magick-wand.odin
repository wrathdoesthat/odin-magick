package odin_magick

import "core:c"

when !DISABLE_MAGICK_WAND { 
    // MagickWand/pixel-wand.c
    PixelWand :: struct {
        id: c.size_t,
        name: [MagickPathExtent]c.char,
        exception: ^ExceptionInfo,
        pixel: PixelInfo,
        count: c.size_t,
        debug: MagickBooleanType,
        signature: c.size_t
    }

    // test123

    // MagickWand/drawing-wand.c
    PathOperation :: enum c.int {
        PathDefaultOperation,
        PathCloseOperation,                        /* Z|z (none) */
        PathCurveToOperation,                      /* C|c (x1 y1 x2 y2 x y)+ */
        PathCurveToQuadraticBezierOperation,       /* Q|q (x1 y1 x y)+ */
        PathCurveToQuadraticBezierSmoothOperation, /* T|t (x y)+ */
        PathCurveToSmoothOperation,                /* S|s (x2 y2 x y)+ */
        PathEllipticArcOperation,                  /* A|a (rx ry x-axis-rotation large-arc-flag sweep-flag x y)+ */
        PathLineToHorizontalOperation,             /* H|h x+ */
        PathLineToOperation,                       /* L|l (x y)+ */
        PathLineToVerticalOperation,               /* V|v y+ */
        PathMoveToOperation                        /* M|m (x y)+ */
    }

    PathMode :: enum c.int {
        DefaultPathMode,
        AbsolutePathMode,
        RelativePathMode
    }

    DrawingWand :: struct {
        id: c.size_t,
        name: [MagickPathExtent]c.char,
        image: ^Image,
        exception: ^ExceptionInfo,
        mvg: cstring,
        mvg_alloc, mvg_length, mvg_width: c.size_t,
        pattern_id: cstring,
        pattern_bounds: RectangleInfo,
        pattern_offset: c.size_t,
        index: c.size_t,
        graphic_context: ^^DrawInfo,
        filter_off: MagickBooleanType,
        indent_depth: c.size_t,
        path_operation: PathOperation,
        path_mode: PathMode,
        destroy, debug: MagickBooleanType,
        signature: c.size_t
    }

    // MagickWand/magick-wand-private.h
    MagickWand :: struct {
        id: c.size_t,
        name: [MagickPathExtent]c.char, /* Wand name to use for MagickWand Logs */
        images: ^Image, /* The images in this wand - also the current image */
        image_info: ^ImageInfo, /* Global settings used for images in Wand */
        exception: ^ExceptionInfo,
        insert_before: MagickBooleanType, /* wand set to first image, prepend new images */
        image_pending: MagickBooleanType, /* this image is pending Next/Previous Iteration */
        debug: MagickBooleanType, /* Log calls to MagickWand library */
        signature: c.size_t
    }

    @(default_calling_convention="c")
    foreign magick_wand { 
        // MagickWand/MagickWand.h
        MagickGetException :: proc(wand: ^MagickWand, severity: ^ExceptionType) -> cstring ---
        
        MagickGetExceptionType :: proc(wand: ^MagickWand) -> ExceptionType ---
        
        IsMagickWand :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        IsMagickWandInstantianed :: proc() -> MagickBooleanType ---
        MagickClearException :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickSetIteratorIndex :: proc(wand: ^MagickWand, index: c.ssize_t) -> MagickBooleanType ---
        
        CloneMagickWand :: proc(wand: ^MagickWand) -> ^MagickWand ---
        DestroyMagickWand :: proc(wand: ^MagickWand) -> ^MagickWand ---
        NewMagickWand :: proc() -> ^MagickWand ---
        NewMagickWandFromImage :: proc(image: ^Image) -> ^MagickWand ---

        ClearMagickWand :: proc(wand: ^MagickWand) ---
        MagickWandGenesis :: proc() ---
        MagickWandTerminus :: proc() --- 
        MagickRelinquishMemory :: proc(memory: rawptr) ---
        MagickResetIterator :: proc(wand: ^MagickWand) ---
        MagickSetFirstIterator :: proc(wand: ^MagickWand) ---
        MagickSetLastIterator :: proc(wand: ^MagickWand) ---

        // MagickWand/pixel-wand.h
        PixelGetColorAsNormalizedString :: proc(wand: ^PixelWand) -> cstring ---
        PixelGetColorAsString :: proc(wand: ^PixelWand) -> cstring ---
        PixelGetException :: proc(wand: ^PixelWand, severity: ^ExceptionType) ---

        PixelGetAlpha :: proc(wand: ^PixelWand) -> c.double ---
        PixelGetBlack :: proc(wand: ^PixelWand) -> c.double ---
        PixelGetBlue :: proc(wand: ^PixelWand) -> c.double ---
        PixelGetCyan :: proc(wand: ^PixelWand) -> c.double ---
        PixelGetFuzz :: proc(wand: ^PixelWand) -> c.double ---
        PixelGetGreen :: proc(wand: ^PixelWand) -> c.double ---
        PixelGetMagenta :: proc(wand: ^PixelWand) -> c.double ---
        PixelGetRed :: proc(wand: ^PixelWand) -> c.double ---
        PixelGetYellow :: proc(wand: ^PixelWand) -> c.double ---
        
        PixelGetExceptionType :: proc(wand: ^PixelWand) -> ExceptionType ---

        IsPixelWand :: proc(wand: ^PixelWand) -> MagickBooleanType ---
        IsPixelWandSimilar :: proc(p: ^PixelWand, q: ^PixelWand, fuzz: c.double) ->MagickBooleanType ---
        PixelClearException :: proc(wand: ^PixelWand) -> MagickBooleanType ---
        PixelSetColor :: proc(wand: ^PixelWand, color: cstring) -> MagickBooleanType ---

        PixelGetPixel :: proc(wand: ^PixelWand) -> PixelInfo ---

        ClonePixelWand :: proc(wand: ^PixelWand) -> ^PixelWand ---
        ClonePixelWands :: proc(wands: [^]^PixelWand, number_wands: c.size_t) -> [^]^PixelWand ---
        DestroyPixelWand :: proc(wand: ^PixelWand) -> ^PixelWand ---
        DestroyPixelWands :: proc(wands: [^]^PixelWand, number_wands: c.size_t) -> [^]^PixelWand ---
        NewPixelWand :: proc() -> ^PixelWand ---
        NewPixelWands :: proc(number_wands: c.size_t) -> [^]^PixelWand ---

        PixelGetAlphaQuantum :: proc(wand: ^PixelWand) -> Quantum ---
        PixelGetBlackQuantum :: proc(wand: ^PixelWand) -> Quantum ---
        PixelGetBlueQuantum :: proc(wand: ^PixelWand) -> Quantum ---
        PixelGetCyanQuantum :: proc(wand: ^PixelWand) -> Quantum ---
        PixelGetGreenQuantum :: proc(wand: ^PixelWand) -> Quantum ---
        PixelGetIndex :: proc(wand: ^PixelWand) -> Quantum ---
        PixelGetMagentaQuantum :: proc(wand: ^PixelWand) -> Quantum ---
        PixelGetRedQuantum :: proc(wand: ^PixelWand) -> Quantum ---
        PixelGetYellowQuantum :: proc(wand: ^PixelWand) -> Quantum ---

        PixelGetColorCount :: proc(wand: ^PixelWand) -> c.size_t ---

        ClearPixelWand :: proc(wand: ^PixelWand) ---
        PixelGetHSL :: proc(wand: ^PixelWand, hue: c.double, saturation: c.double, lightness: c.double) ---
        PixelGetMagickColor :: proc(wand: ^PixelWand, color: ^PixelInfo) ---
        PixelGetQuantumPacket :: proc(wand: ^PixelWand, packet: ^PixelInfo) ---
        PixelGetQuantumPixel :: proc(image: ^Image, wand: ^PixelWand, pixel: ^Quantum) ---
        PixelSetAlpha :: proc(wand: ^PixelWand, alpha: c.double) ---
        PixelSetAlphaQuantum :: proc(wand: ^PixelWand, alpha: Quantum) ---
        PixelSetBlack :: proc(wand: ^PixelWand, black: c.double) ---
        PixelSetBlackQuantum :: proc(wand: ^PixelWand, black: Quantum) ---
        PixelSetBlue :: proc(wand: ^PixelWand, blue: c.double) ---
        PixelSetBlueQuantum :: proc(wand: ^PixelWand, blue: Quantum) ---
        PixelSetColorFromWand :: proc(wand: ^PixelWand, color: ^PixelWand) ---
        PixelSetColorCount :: proc(wand: ^PixelWand, count: c.size_t) ---
        PixelSetCyan :: proc(wand: ^PixelWand, cyan: c.double) ---
        PixelSetCyanQuantum :: proc(wand: ^PixelWand, cyan: Quantum) ---
        PixelSetFuzz :: proc(wand: ^PixelWand, fuzz: c.double) ---
        PixelSetGreen :: proc(wand: ^PixelWand, green: c.double) ---
        PixelSetGreenQuantum :: proc(wand: ^PixelWand, green: Quantum) ---
        PixelSetHSL :: proc(wand: ^PixelWand, hue: c.double, saturation: c.double, lightness: c.double) ---
        PixelSetIndex :: proc(wand: ^PixelWand, index: Quantum) ---
        PixelSetMagenta :: proc(wand: ^PixelWand, magenta: c.double) ---
        PixelSetMagentaQuantum :: proc(wand: ^PixelWand, magenta: Quantum) ---
        PixelSetPixelColor :: proc(wand: ^PixelWand, color: ^PixelInfo) ---
        PixelSetQuantumPixel :: proc(image: ^Image, pixel: ^Quantum, wand: ^PixelWand) ---
        PixelSetRed :: proc(wand: ^PixelWand, red: c.double) ---
        PixelSetRedQuantum :: proc(wand: ^PixelWand, red: Quantum) ---
        PixelSetYellow :: proc(wand: ^PixelWand, yellow: c.double) ---
        PixelSetYellowQuantum :: proc(wand: ^PixelWand, yellow: Quantum) --- 

        // MagickWand/magick-image.h
        MagickGetImageFeatures :: proc(wand: ^MagickWand, distance: c.size_t) -> ^ChannelFeatures ---

        MagickSetImageChannelMask :: proc(wand: ^MagickWand, channel_mask: ChannelType) -> ChannelType ---

        MagickGetImageStatistics :: proc(wand: ^MagickWand) -> ^ChannelStatistics ---

        MagickGetImageFilename :: proc(wand: ^MagickWand) -> cstring ---
        MagickGetImageFormat :: proc(wand: ^MagickWand) -> cstring ---
        MagickGetImageSignature :: proc(wand: ^MagickWand) -> cstring ---
        MagickIdentifyImage :: proc(wand: ^MagickWand) -> cstring ---

        MagickGetImageColorspace :: proc(wand: ^MagickWand) -> ColorspaceType ---

        MagickGetImageCompose :: proc(wand: ^MagickWand) -> CompositeOperator ---

        MagickGetImageCompression :: proc(wand: ^MagickWand) -> CompressionType ---

        MagickGetImageDispose :: proc(wand: ^MagickWand) -> DisposeType ---

        MagickGetImageDistortions :: proc(wand: ^MagickWand, reference: ^MagickWand, metric: MetricType) -> ^c.double ---
        MagickGetImageFuzz :: proc(wand: ^MagickWand) -> c.double ---
        MagickGetImageGamma :: proc(wand: ^MagickWand) -> c.double ---
        MagickGetImageTotalInkDensity :: proc(wand: ^MagickWand) -> c.double ---

        MagickGetImageEndian :: proc(wand: ^MagickWand) -> EndianType ---

        MagickGetImageFilter :: proc(wand: ^MagickWand) -> FilterType ---
        
        MagickGetImageGravity :: proc(wand: ^MagickWand) -> GravityType ---

        MagickDestroyImage :: proc(image: ^Image) -> Image ---
        GetImageFromMagickWand :: proc(wand: ^MagickWand) -> Image ---

        MagickGetImageType :: proc(wand: ^MagickWand) -> ImageType ---
        MagickIdentifyImageType :: proc(wand: ^MagickWand) -> ImageType ---

        MagickGetImageInterlaceScheme :: proc(wand: ^MagickWand) -> InterlaceType ---

        MagickGetImageInterpolateMethod :: proc(wand: ^MagickWand) -> PixelInterpolateMethod ---

        MagickAdaptiveBlurImage :: proc(wand: ^MagickWand, radius: c.double, sigma: c.double) -> MagickBooleanType ---
        MagickAdaptiveResizeImage :: proc(wand: ^MagickWand, columns: c.size_t, rows: c.size_t) -> MagickBooleanType ---
        MagickAdaptiveSharpenImage :: proc(wand: ^MagickWand, radius: c.double, sigma: c.double) -> MagickBooleanType ---
        MagickAdaptiveThresholdImage :: proc(wand: ^MagickWand, width: c.size_t, height: c.size_t, bias: c.double) -> MagickBooleanType ---
        MagickAddImage :: proc(wand: ^MagickWand, add_wand: ^MagickWand) -> MagickBooleanType ---
        MagickAddNoiseImage :: proc(wand: ^MagickWand, noise_type: NoiseType, attenuate: c.double) -> MagickBooleanType ---
        MagickAffineTransformImage :: proc(wand: ^MagickWand, drawing_wand: ^DrawingWand) -> MagickBooleanType ---
        MagickAnnotateImage :: proc(wand: ^MagickWand, drawing_wand: ^DrawingWand, x: c.double, y: c.double, angle: c.double, text: cstring) -> MagickBooleanType ---
        MagickAnimateImages :: proc(wand: ^MagickWand, server_name: cstring) -> MagickBooleanType ---
        MagickAutoGammaImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickAutoLevelImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickAutoOrientImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickAutoThresholdImage :: proc(wand: ^MagickWand, method: AutoThresholdMethod) -> MagickBooleanType ---
        MagickBilateralBlurImage :: proc(wand: ^MagickWand, radius: c.double, sigma: c.double, intensity_sigma: c.double, spatial_sigma: c.double) -> MagickBooleanType ---
        MagickBlackThresholdImage :: proc(wand: ^MagickWand, threshold: ^PixelWand) -> MagickBooleanType ---
        MagickBlueShiftImage :: proc(wand: ^MagickWand, factor: c.double) -> MagickBooleanType ---
        MagickBlurImage :: proc(wand: ^MagickWand, radius: c.double, sigma: c.double) -> MagickBooleanType ---
        MagickBorderImage :: proc(wand: ^MagickWand, bordercolor: ^PixelWand, width: c.size_t, height: c.size_t, compose: CompositeOperator) -> MagickBooleanType ---
        MagickBrightnessContrastImage :: proc(wand: ^MagickWand, brightness: c.double, contrast: c.double) -> MagickBooleanType ---
        MagickCannyEdgeImage :: proc(wand: ^MagickWand, radius: c.double, sigma: c.double, lower_percent: c.double, upper_percent: c.double) -> MagickBooleanType ---
        MagickCharcoalImage :: proc(wand: ^MagickWand, radius: c.double, sigma: c.double) -> MagickBooleanType ---
        MagickChopImage :: proc(wand: ^MagickWand, width: c.size_t, height: c.size_t, x: c.ssize_t, y: c.ssize_t) -> MagickBooleanType ---
        MagickCLAHEImage :: proc(wand: ^MagickWand, width: c.size_t, height: c.size_t, number_bins: c.double, clip_limit: c.double) -> MagickBooleanType ---
        MagickClampImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickClipImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickClipImagePath :: proc(wand: ^MagickWand, pathname: cstring, inside: MagickBooleanType) -> MagickBooleanType ---
        MagickClutImage :: proc(wand: ^MagickWand, clut_wand: ^MagickWand, method: PixelInterpolateMethod) -> MagickBooleanType ---
        MagickColorDecisionListImage :: proc(wand: ^MagickWand, color_correction_collection: cstring) -> MagickBooleanType ---
        MagickColorizeImage :: proc(wand: ^MagickWand, colorize: ^PixelWand, blend: ^PixelWand) -> MagickBooleanType ---
        MagickColorMatrixImage :: proc(wand: ^MagickWand, color_matrix: ^KernelInfo) -> MagickBooleanType ---
        MagickColorThresholdImage :: proc(wand: ^MagickWand, start_color: ^PixelWand, stop_color: ^PixelWand) -> MagickBooleanType ---
        MagickCommentImage :: proc(wand: ^MagickWand, comment: cstring) -> MagickBooleanType ---
        MagickCompositeImage :: proc(wand: ^MagickWand, source_wand: ^MagickWand, compose: CompositeOperator, clip_to_self: MagickBooleanType, x: c.ssize_t, y: c.ssize_t) -> MagickBooleanType ---
        MagickCompositeImageGravity :: proc(wand: ^MagickWand, source_wand: ^MagickWand, compose: CompositeOperator, gravity: GravityType) -> MagickBooleanType ---
        MagickCompositeLayers :: proc(wand: ^MagickWand, source_wand: ^MagickWand, compose: CompositeOperator, x: c.ssize_t, y: c.ssize_t) -> MagickBooleanType ---
        MagickConnectedComponentsImage :: proc(wand: ^MagickWand, connectivity: c.size_t, objects: [^]^CCObjectInfo) -> MagickBooleanType --- 
        // map_ is normally named map but thats a reserved keyword
        MagickConstituteImage :: proc(wand: ^MagickWand, columns: c.size_t, rows: c.size_t, map_: cstring, storage: StorageType, pixels: rawptr) -> MagickBooleanType ---
        MagickContrastImage :: proc(wand: ^MagickWand, sharpen: MagickBooleanType) -> MagickBooleanType ---
        MagickContrastStretchImage :: proc(wand: ^MagickWand, black_point: c.double, white_point: c.double) -> MagickBooleanType ---
        MagickConvolveImage :: proc(wand: ^MagickWand, kernel: ^KernelInfo) -> MagickBooleanType ---
        MagickCropImage :: proc(wand: ^MagickWand, width: c.size_t, height: c.size_t, x: c.ssize_t, y: c.ssize_t) -> MagickBooleanType ---
        MagickCycleColormapImage :: proc(wand: ^MagickWand, displace: c.ssize_t) -> MagickBooleanType ---
        MagickDecipherImage :: proc(wand: ^MagickWand, passphrase: cstring) -> MagickBooleanType ---
        MagickDeskewImage :: proc(wand: ^MagickWand, threshold: c.double) -> MagickBooleanType ---
        MagickDespeckleImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickDisplayImage :: proc(wand: ^MagickWand, server_name: cstring) -> MagickBooleanType ---
        MagickDisplayImages :: proc(wand: ^MagickWand, server_name: cstring) -> MagickBooleanType ---
        MagickDistortImage :: proc(wand: ^MagickWand, method: DistortMethod, number_arguments: c.size_t, arguments: ^c.double, bestfit: MagickBooleanType) -> MagickBooleanType ---
        MagickDrawImage :: proc(wand: ^MagickWand, drawing_wand: ^DrawingWand) -> MagickBooleanType ---
        MagickEdgeImage :: proc(wand: ^MagickWand, radius: c.double) -> MagickBooleanType ---
        MagickEmbossImage :: proc(wand: ^MagickWand, radius: c.double, sigma: c.double) -> MagickBooleanType ---
        MagickEncipherImage :: proc(wand: ^MagickWand, passphrase: cstring) -> MagickBooleanType ---
        MagickEnhanceImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickEqualizeImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickEvaluateImage :: proc(wand: ^MagickWand, op: MagickEvaluateOperator, value: c.double) -> MagickBooleanType ---
        // map_ is normally named map but thats a reserved keyword
        MagickExportImagePixels :: proc(wand: ^MagickWand, x: c.ssize_t, y: c.ssize_t, columns: c.size_t, rows: c.size_t, map_: cstring, storage: StorageType, pixels: rawptr) -> MagickBooleanType ---
        MagickExtentImage :: proc(wand: ^MagickWand, width: c.size_t, height: c.size_t, x: c.ssize_t, y: c.ssize_t) -> MagickBooleanType ---
        MagickFlipImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickFloodfillPaintImage :: proc(wand: ^MagickWand, fill: ^PixelWand, fuzz: c.double, bordercolor: ^PixelWand, x: c.ssize_t, y: c.ssize_t, invert: MagickBooleanType) -> MagickBooleanType ---
        MagickFlopImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickForwardFourierTransformImage :: proc(wand: ^MagickWand, magnitude: MagickBooleanType) -> MagickBooleanType ---
        MagickFrameImage :: proc(wand: ^MagickWand, matte_color: ^PixelWand, width: c.size_t, height: c.size_t, inner_bevel: c.ssize_t, outer_bevel: c.ssize_t, compose: CompositeOperator) -> MagickBooleanType ---
        MagickFunctionImage :: proc(wand: ^MagickWand, function: MagickFunction, number_arguments: c.size_t, double: ^c.double) -> MagickBooleanType ---
        MagickGammaImage :: proc(wand: ^MagickWand, gamma: c.double) -> MagickBooleanType ---
        MagickGaussianBlurImage :: proc(wand: ^MagickWand, radius: c.double, sigma: c.double) -> MagickBooleanType ---
        MagickGetImageAlphaChannel :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickGetImageBackgroundColor :: proc(wand: ^MagickWand, background_color: ^PixelWand) -> MagickBooleanType ---
        MagickGetImageBluePrimary :: proc(wand: ^MagickWand, x: ^c.double, y: ^c.double, z: ^c.double) -> MagickBooleanType ---
        MagickGetImageBorderColor :: proc(wand: ^MagickWand, border_color: ^PixelWand) -> MagickBooleanType ---
        MagickGetImageKurtosis :: proc(wand: ^MagickWand, kurtosis: ^c.double, skewness: ^c.double) -> MagickBooleanType ---
        MagickGetImageMean :: proc(wand: ^MagickWand, mean: ^c.double, standard_deviation: ^c.double) -> MagickBooleanType ---
        MagickGetImageRange :: proc(wand: ^MagickWand, minima: ^c.double, maxima: ^c.double) -> MagickBooleanType ---
        MagickGetImageColormapColor :: proc(wand: ^MagickWand, index: c.size_t, color: ^PixelWand) -> MagickBooleanType ---
        MagickGetImageDistortion :: proc(wand: ^MagickWand, reference: ^MagickWand, metric: MetricType, distortion: c.double) -> MagickBooleanType ---
        MagickGetImageGreenPrimary :: proc(wand: ^MagickWand, x: ^c.double, y: ^c.double, z: ^c.double) -> MagickBooleanType ---
        MagickGetImageLength :: proc(wand: ^MagickWand, length: ^MagickSizeType) -> MagickBooleanType ---
        MagickGetImageMatteColor :: proc(wand: ^MagickWand, matte_color: ^PixelWand) -> MagickBooleanType ---
        MagickGetImagePage :: proc(wand: ^MagickWand, width: ^c.size_t, height: ^c.size_t, x: ^c.ssize_t, y: ^c.ssize_t) -> MagickBooleanType ---
        MagickGetImagePixelColor :: proc(wand: ^MagickWand, x: ^c.double, y: ^c.double, z: ^c.double) -> MagickBooleanType ---
        MagickGetImageRedPrimary :: proc(wand: ^MagickWand, x: ^c.double, y: ^c.double, z: ^c.double) -> MagickBooleanType ---
        MagickGetImageResolution :: proc(wand: ^MagickWand, x: ^c.double, y: ^c.double) -> MagickBooleanType ---
        MagickGetImageWhitePoint :: proc(wand: ^MagickWand, x: ^c.double, y: ^c.double, z: ^c.double) -> MagickBooleanType ---
        MagickHaldClutImage :: proc(wand: ^MagickWand, hald_wand: ^MagickWand) -> MagickBooleanType ---
        MagickHasNextImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickHasPreviousImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickHoughLineImage :: proc(wand: ^MagickWand, width: c.size_t, height: c.size_t, threshold: c.size_t) -> MagickBooleanType ---
        MagickImplodeImage :: proc(wand: ^MagickWand, amount: c.double, method: PixelInterpolateMethod) -> MagickBooleanType ---
        // map_ is normally named map but thats a reserved keyword
        MagickImportImagePixels :: proc(wand: ^MagickWand, x: c.ssize_t, y: c.ssize_t, columns: c.size_t, rows: c.size_t, map_: cstring, storage: StorageType, pixels: rawptr) -> MagickBooleanType ---
        MagickInterpolativeResizeImage :: proc(wand: ^MagickWand, columns: c.size_t, rows: c.size_t, method: PixelInterpolateMethod) -> MagickBooleanType ---
        MagickInverseFourierTransformImage :: proc(magnitude_wand: ^MagickWand, phase_wand: ^MagickWand, magnitude: MagickBooleanType) -> MagickBooleanType ---
        MagickKmeansImage :: proc(wand: ^MagickWand, number_colors: c.size_t, max_iterations: c.size_t, tolerance: c.double) -> MagickBooleanType ---
        MagickKuwaharaImage :: proc(wand: ^MagickWand, radius: c.double, sigma: c.double) -> MagickBooleanType ---
        MagickLabelImage :: proc(wand: ^MagickWand, label: cstring) -> MagickBooleanType ---
        MagickLevelImage :: proc(wand: ^MagickWand, black_point: c.double, gamma: c.double, white_point: c.double) -> MagickBooleanType ---
        MagickLevelImageColors :: proc(wand: ^MagickWand, black_color: ^PixelWand, white_color: ^PixelWand, invert: MagickBooleanType) -> MagickBooleanType ---
        MagickLevelizeImage :: proc(wand: ^MagickWand, black_point: c.double, gamma: c.double, white_point: c.double) -> MagickBooleanType ---
        MagickLinearStretchImage :: proc(wand: ^MagickWand, black_point: c.double, white_point: c.double) -> MagickBooleanType ---
        MagickLiquidRescaleImage :: proc(wand: ^MagickWand, columns: c.size_t, rows: c.size_t, delta_x: c.double, rigidity: c.double) -> MagickBooleanType ---
        MagickLocalContrastImage :: proc(wand: ^MagickWand, radius: c.double, strength: c.double) -> MagickBooleanType ---
        MagickMagnifyImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickMeanShiftImage :: proc(wand: ^MagickWand, width: c.size_t, height: c.size_t, color_distance: c.double) -> MagickBooleanType ---
        MagickMinifyImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        // I cannot find the body for this function on github so theres no names
        MagickModeImage :: proc(^MagickWand, c.double) -> MagickBooleanType ---
        MagickModulateImage :: proc(wand: ^MagickWand, brightness: c.double, saturation: c.double, hue: c.double) -> MagickBooleanType ---
        MagickMorphologyImage :: proc(wand: ^MagickWand, method: MorphologyMethod, iterations: c.ssize_t, KernelInfo: ^KernelInfo) -> MagickBooleanType ---
        MagickMotionBlurImage :: proc(wand: ^MagickWand, radius: c.double, sigma: c.double, angle: c.double) -> MagickBooleanType ---
        MagickNegateImage :: proc(wand: ^MagickWand, gray: MagickBooleanType) -> MagickBooleanType ---
        MagickNewImage :: proc(wand: ^MagickWand, width: c.size_t, height: c.size_t, background: ^PixelWand) -> MagickBooleanType ---
        MagickNextImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickNormalizeImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickOilPaintImage :: proc(wand: ^MagickWand, radius: c.double, sigma: c.double) -> MagickBooleanType ---
        MagickOpaquePaintImage :: proc(wand: ^MagickWand, target: ^PixelWand, fill: ^PixelWand, fuzz: c.double, invert: MagickBooleanType) -> MagickBooleanType ---
        MagickOptimizeImageTransparency :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickOrderedDitherImage :: proc(wand: ^MagickWand, threshold_map: cstring) -> MagickBooleanType ---
        MagickPolynomialImage :: proc(wand: ^MagickWand, number_terms: c.size_t, terms: ^c.double) -> MagickBooleanType ---
        MagickTransparentPaintImage :: proc(wand: ^MagickWand, target: ^PixelWand, alpha: c.double, fuzz: c.double, invert: MagickBooleanType) -> MagickBooleanType ---
        MagickPingImage :: proc(wand: ^MagickWand, filename: cstring) -> MagickBooleanType ---
        MagickPingImageBlob :: proc(wand: ^MagickWand, blob: rawptr, length: c.size_t) -> MagickBooleanType ---
        MagickPingImageFile :: proc(wand: ^MagickWand, file: ^c.FILE) -> MagickBooleanType ---
        MagickPolaroidImage :: proc(wand: ^MagickWand, drawing_wand: ^DrawingWand, caption: cstring, angle: c.double, method: PixelInterpolateMethod) -> MagickBooleanType ---
        MagickPosterizeImage :: proc(wand: ^MagickWand, levels: c.size_t, dither: DitherMethod) -> MagickBooleanType ---
        MagickPreviousImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickQuantizeImage :: proc(wand: ^MagickWand, number_colors: c.size_t, colorspace: ColorspaceType, treedepth: c.size_t, dither_method: DitherMethod, measure_error: MagickBooleanType) -> MagickBooleanType ---
        MagickQuantizeImages :: proc(wand: ^MagickWand, number_colors: c.size_t, colorspace: ColorspaceType, treedepth: c.size_t, dither_method: DitherMethod, measure_Error: MagickBooleanType) -> MagickBooleanType ---
        MagickRangeThresholdImage :: proc(wand: ^MagickWand, low_black: c.double, low_white: c.double, high_white: c.double, high_black: c.double) -> MagickBooleanType ---
        MagickRotationalBlurImage :: proc(wand: ^MagickWand, angle: c.double) -> MagickBooleanType ---
        MagickRaiseImage :: proc(wand: ^MagickWand, width: c.size_t, height: c.size_t, x: c.ssize_t, y: c.ssize_t, raise: MagickBooleanType) -> MagickBooleanType ---
        MagickRandomThresholdImage :: proc(wand: ^MagickWand, low: c.double, high: c.double) -> MagickBooleanType ---
        MagickReadImage :: proc(wand: ^MagickWand, filename: cstring) -> MagickBooleanType ---
        MagickReadImageBlob :: proc(wand: ^MagickWand, blob: rawptr, length: c.size_t) -> MagickBooleanType ---
        MagickReadImageFile :: proc(wand: ^MagickWand, file: ^c.FILE) -> MagickBooleanType ---
        // Couldnt find body for this either
        MagickReduceNoiseImage :: proc(^MagickWand, c.double) -> MagickBooleanType ---
        MagickRemapImage :: proc(wand: ^MagickWand, remap_wand: ^MagickWand, dither_method: DitherMethod) -> MagickBooleanType ---
        MagickRemoveImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickResampleImage :: proc(wand: ^MagickWand, x_resolution: c.double, y_resolution: c.double, filter: FilterType) -> MagickBooleanType ---
        MagickResetImagePage :: proc(wand: ^MagickWand, page: cstring) -> MagickBooleanType ---
        MagickResizeImage :: proc(wand: ^MagickWand, columns: c.size_t, rows: c.size_t, filter: FilterType) -> MagickBooleanType ---
        MagickRollImage :: proc(wand: ^MagickWand, x: c.ssize_t, y: c.ssize_t) -> MagickBooleanType ---
        MagickRotateImage :: proc(wand: ^MagickWand, background: ^PixelWand, degrees: c.double) -> MagickBooleanType ---
        MagickSampleImage :: proc(wand: ^MagickWand, columns: c.size_t, rows: c.size_t) -> MagickBooleanType ---
        MagickScaleImage :: proc(wand: ^MagickWand, columns: c.size_t, rows: c.size_t) -> MagickBooleanType ---
        MagickSegmentImage :: proc(wand: ^MagickWand, colorspace: ColorspaceType, verbose: MagickBooleanType, cluster_threshold: c.double, smooth_threshold: c.double) -> MagickBooleanType ---
        MagickSelectiveBlurImage :: proc(wand: ^MagickWand, radius: c.double, double: c.double, sigma: c.double) -> MagickBooleanType ---
        MagickSeparateImage :: proc(wand: ^MagickWand, channel: ChannelType) -> MagickBooleanType ---
        MagickSepiaToneImage :: proc(wand: ^MagickWand, threshold: c.double) -> MagickBooleanType ---
        MagickSetImage :: proc(wand: ^MagickWand, set_wand: ^MagickWand) -> MagickBooleanType ---
        MagickSetImageAlpha :: proc(wand: ^MagickWand, alpha: c.double) -> MagickBooleanType ---
        MagickSetImageAlphaChannel :: proc(wand: ^MagickWand, alpha_type: AlphaChannelOption) -> MagickBooleanType ---
        MagickSetImageBackgroundColor :: proc(wand: ^MagickWand, background: ^PixelWand) -> MagickBooleanType ---
        MagickSetImageBluePrimary :: proc(wand: ^MagickWand, x: c.double, y: c.double, z: c.double) -> MagickBooleanType ---
        MagickSetImageBorderColor :: proc(wand: ^MagickWand, border: ^PixelWand) -> MagickBooleanType ---
        MagickSetImageColor :: proc(wand: ^MagickWand, color: ^PixelWand) -> MagickBooleanType ---
        MagickSetImageColormapColor :: proc(wand: ^MagickWand, index: c.size_t, color: ^PixelWand) -> MagickBooleanType ---
        MagickSetImageColorspace :: proc(wand: ^MagickWand, colorspace: ColorspaceType) -> MagickBooleanType ---
        MagickSetImageCompose :: proc(wand: ^MagickWand, compose: CompositeOperator) -> MagickBooleanType ---
        MagickSetImageCompression :: proc(wand: ^MagickWand, compression: CompressionType) -> MagickBooleanType ---
        MagickSetImageDelay :: proc(wand: ^MagickWand, delay: c.size_t) -> MagickBooleanType ---
        MagickSetImageDepth :: proc(wand: ^MagickWand, depth: c.size_t) -> MagickBooleanType ---
        MagickSetImageDispose :: proc(wand: ^MagickWand, dispose: DisposeType) -> MagickBooleanType ---
        MagickSetImageCompressionQuality :: proc(wand: ^MagickWand, quality: c.size_t) -> MagickBooleanType ---
        MagickSetImageEndian :: proc(wand: ^MagickWand, endian: EndianType) -> MagickBooleanType ---
        MagickSetImageExtent :: proc(wand: ^MagickWand, columns: c.size_t, rows: c.size_t) -> MagickBooleanType ---
        MagickSetImageFilename :: proc(wand: ^MagickWand, filename: cstring) -> MagickBooleanType ---
        MagickSetImageFilter :: proc(wand: ^MagickWand, filter: FilterType) -> MagickBooleanType ---
        MagickSetImageFormat :: proc(wand: ^MagickWand, format: cstring) -> MagickBooleanType ---
        MagickSetImageFuzz :: proc(wand: ^MagickWand, fuzz: c.double) -> MagickBooleanType ---
        MagickSetImageGamma :: proc(wand: ^MagickWand, gamma: c.double) -> MagickBooleanType ---
        MagickSetImageGravity :: proc(wand: ^MagickWand, gravity: GravityType) -> MagickBooleanType ---
        MagickSetImageGreenPrimary :: proc(wand: ^MagickWand, x: c.double, y: c.double, z: c.double) -> MagickBooleanType ---
        MagickSetImageInterlaceScheme :: proc(wand: ^MagickWand, interlace: InterlaceType) -> MagickBooleanType ---
        MagickSetImageInterpolateMethod :: proc(wand: ^MagickWand, method: PixelInterpolateMethod) -> MagickBooleanType ---
        MagickSetImageIterations :: proc(wand: ^MagickWand, iterations: c.size_t) -> MagickBooleanType ---
        MagickSetImageMask :: proc(wand: ^MagickWand, type: PixelMask, clip_mask: ^MagickWand) -> MagickBooleanType ---
        MagickSetImageMatte :: proc(wand: ^MagickWand, matte: MagickBooleanType) -> MagickBooleanType ---
        MagickSetImageMatteColor :: proc(wand: ^MagickWand, alpha: ^PixelWand) -> MagickBooleanType ---
        MagickSetImageOrientation :: proc(wand: ^MagickWand, orientation: OrientationType) -> MagickBooleanType ---
        MagickSetImagePage :: proc(wand: ^MagickWand, width: c.size_t, height: c.size_t, x: c.ssize_t, y: c.ssize_t) -> MagickBooleanType ---
        MagickSetImagePixelColor :: proc(wand: ^MagickWand, x: c.ssize_t, y: c.ssize_t, color: ^PixelWand) -> MagickBooleanType ---
        MagickSetImageRedPrimary :: proc(wand: ^MagickWand, x: c.double, y: c.double, z: c.double) -> MagickBooleanType ---
        MagickSetImageRenderingIntent :: proc(wand: ^MagickWand, rendering_intent: RenderingIntent) -> MagickBooleanType ---
        MagickSetImageResolution :: proc(wand: ^MagickWand, x_resolution: c.double, y_resolution: c.double) -> MagickBooleanType ---
        MagickSetImageScene :: proc(wand: ^MagickWand, scene: c.size_t) -> MagickBooleanType ---
        MagickSetImageTicksPerSecond :: proc(wand: ^MagickWand, ticks_per_second: c.ssize_t) -> MagickBooleanType ---
        MagickSetImageType :: proc(wand: ^MagickWand, image_type: ImageType) -> MagickBooleanType ---
        MagickSetImageUnits :: proc(wand: ^MagickWand, units: ResolutionType) -> MagickBooleanType ---
        MagickSetImageWhitePoint :: proc(wand: ^MagickWand, x: c.double, y: c.double, z: c.double) -> MagickBooleanType ---
        MagickShadeImage :: proc(wand: ^MagickWand, gray: MagickBooleanType, azimuth: c.double, elevation: c.double) -> MagickBooleanType ---
        MagickShadowImage :: proc(wand: ^MagickWand, alpha: c.double, sigma: c.double, x: c.ssize_t, y: c.ssize_t) -> MagickBooleanType ---
        MagickSharpenImage :: proc(wand: ^MagickWand, radius: c.double, sigma: c.double) -> MagickBooleanType ---
        MagickShaveImage :: proc(wand: ^MagickWand, columns: c.size_t, rows: c.size_t) -> MagickBooleanType ---
        MagickShearImage :: proc(wand: ^MagickWand, background: ^PixelWand, x_shear: c.double, y_shear: c.double) -> MagickBooleanType ---
        MagickSigmoidalContrastImage :: proc(wand: ^MagickWand, sharpen: MagickBooleanType, alpha: c.double, beta: c.double) -> MagickBooleanType ---
        MagickSketchImage :: proc(wand: ^MagickWand, radius: c.double, sigma: c.double, angle: c.double) -> MagickBooleanType ---
        MagickSolarizeImage :: proc(wand: ^MagickWand, threshold: c.double) -> MagickBooleanType ---
        MagickSparseColorImage :: proc(wand: ^MagickWand, method: SparseColorMethod, number_arguments: c.size_t, arguments: ^c.double) -> MagickBooleanType ---
        MagickSpliceImage :: proc(wand: ^MagickWand, width: c.size_t, height: c.size_t, x: c.ssize_t, y: c.ssize_t) -> MagickBooleanType ---
        MagickSpreadImage :: proc(wand: ^MagickWand, method: PixelInterpolateMethod, radius: c.double) -> MagickBooleanType ---
        MagickStatisticImage :: proc(wand: ^MagickWand, type: StatisticType, width: c.size_t, height: c.size_t) -> MagickBooleanType ---
        MagickStripImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickSwirlImage :: proc(wand: ^MagickWand, degrees: c.double, method: PixelInterpolateMethod) -> MagickBooleanType ---
        MagickTintImage :: proc(wand: ^MagickWand, tint: ^PixelWand, blend: ^PixelWand) -> MagickBooleanType ---
        MagickTransformImageColorspace :: proc(wand: ^MagickWand, colorspace: ColorspaceType) -> MagickBooleanType ---
        MagickTransposeImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickTransverseImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickThresholdImage :: proc(wand: ^MagickWand, threshold: c.double) -> MagickBooleanType ---
        MagickThresholdImageChannel :: proc(wand: ^MagickWand, channel: ChannelType, threshold: c.double) -> MagickBooleanType ---
        MagickThumbnailImage :: proc(wand: ^MagickWand, columns: c.size_t, rows: c.size_t) -> MagickBooleanType ---
        MagickTrimImage :: proc(wand: ^MagickWand, fuzz: c.double) -> MagickBooleanType ---
        MagickUniqueImageColors :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickUnsharpMaskImage :: proc(wand: ^MagickWand, radius: c.double, sigma: c.double, gain: c.double, threshold: c.double) -> MagickBooleanType ---
        MagickVignetteImage :: proc(wand: ^MagickWand, radius: c.double, sigma: c.double, x: c.ssize_t, y: c.ssize_t) -> MagickBooleanType ---
        MagickWaveImage :: proc(wand: ^MagickWand, amplitude: c.double, wave_length: c.double, method: PixelInterpolateMethod) -> MagickBooleanType ---
        MagickWaveletDenoiseImage :: proc(wand: ^MagickWand, threshold: c.double, softness: c.double) -> MagickBooleanType ---
        MagickWhiteBalanceImage :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickWhiteThresholdImage :: proc(wand: ^MagickWand, threshold: ^PixelWand) -> MagickBooleanType ---
        MagickWriteImage :: proc(wand: ^MagickWand, filename: cstring) -> MagickBooleanType ---
        MagickWriteImageFile :: proc(wand: ^MagickWand, file: ^c.FILE) -> MagickBooleanType ---
        MagickWriteImages :: proc(wand: ^MagickWand, filename: cstring, adjoin: MagickBooleanType) -> MagickBooleanType ---
        MagickWriteImagesFile :: proc(wand: ^MagickWand, file: ^c.FILE) -> MagickBooleanType ---

        MagickSetImageProgressMonitor :: proc(wand: ^MagickWand, progress_monitor: MagickProgressMonitor, client_data: rawptr) -> MagickProgressMonitor ---

        MagickAppendImages :: proc(wand: ^MagickWand, stack: MagickBooleanType) -> ^MagickWand ---
        MagickChannelFxImage :: proc(wand: ^MagickWand, expression: cstring) -> ^MagickWand ---
        MagickCoalesceImages :: proc(wand: ^MagickWand) -> ^MagickWand ---
        MagickCombineImages :: proc(wand: ^MagickWand, colorspace: ColorspaceType) -> ^MagickWand ---
        MagickCompareImages :: proc(wand: ^MagickWand, method: MetricType, distortion: ^c.double) -> ^MagickWand --- 
        MagickCompareImagesLayers :: proc(wand: ^MagickWand, method: LayerMethod) -> ^MagickWand ---
        MagickComplexImages :: proc(wand: ^MagickWand, op: ComplexOperator) -> ^MagickWand ---
        MagickDeconstructImages :: proc(wand: ^MagickWand) -> ^MagickWand ---
        MagickEvaluateImages :: proc(wand: ^MagickWand, op: MagickEvaluateOperator) -> ^MagickWand ---
        MagickFxImage :: proc(wand: ^MagickWand, expression: cstring) -> ^MagickWand ---
        MagickGetImage :: proc(wand: ^MagickWand) -> ^MagickWand ---
        MagickGetImageMask :: proc(wand: ^MagickWand, type: PixelMask) -> ^MagickWand ---
        MagickGetImageRegion :: proc(wand: ^MagickWand, width: c.size_t, height: c.size_t, x: c.ssize_t, y: c.ssize_t) -> ^MagickWand ---
        MagickGetImageLayers :: proc(wand: ^MagickWand, method: LayerMethod) -> ^MagickWand ---
        MagickMorphImages :: proc(wand: ^MagickWand, number_frames: c.size_t) -> ^MagickWand ---
        MagickMontageImage :: proc(wand: ^MagickWand, drawing_wand: ^DrawingWand, tile_geometry: cstring, mode: MontageMode, frame: cstring) -> ^MagickWand ---
        MagickOptimizeImageLayers :: proc(wand: ^MagickWand) -> ^MagickWand ---
        MagickPreviewImage :: proc(wand: ^MagickWand, preview: PreviewType) -> ^MagickWand ---
        MagickSimilarityImage :: proc(wand: ^MagickWand, reference: ^MagickWand, metric: MetricType, similarity_threshold: c.double, offset: ^RectangleInfo, similarity: ^c.double) -> ^MagickWand ---
        MagickSmushImages :: proc(wand: ^MagickWand, stack: MagickBooleanType, offset: c.ssize_t) -> ^MagickWand ---
        MagickSteganoImage :: proc(wand: ^MagickWand, watermark_wand: ^MagickWand, offset: c.ssize_t) -> ^MagickWand ---
        MagickStereoImage :: proc(wand: ^MagickWand, offset_Wand: ^MagickWand) -> ^MagickWand ---
        MagickTextureImage :: proc(wand: ^MagickWand, texture_wand: ^MagickWand) -> ^MagickWand ---

        MagickGetImageOrientation :: proc(wand: ^MagickWand) -> OrientationType ---

        MagickGetImageHistogram :: proc(wand: ^MagickWand, number_colors: ^c.size_t) -> [^]^PixelWand ---

        MagickGetImageRenderingIntent :: proc(wand: ^MagickWand) -> RenderingIntent ---

        MagickGetImageUnits :: proc(wand: ^MagickWand) -> ResolutionType ---

        MagickGetImageColors :: proc(wand: ^MagickWand) -> c.size_t ---
        MagickGetImageCompressionQuality :: proc(wand: ^MagickWand) -> c.size_t ---
        MagickGetImageDelay :: proc(wand: ^MagickWand) -> c.size_t ---
        MagickGetImageDepth :: proc(wand: ^MagickWand) -> c.size_t ---
        MagickGetImageHeight :: proc(wand: ^MagickWand) -> c.size_t ---
        MagickGetImageIterations :: proc(wand: ^MagickWand) -> c.size_t ---
        MagickGetImageScene :: proc(wand: ^MagickWand) -> c.size_t ---
        MagickGetImageTicksPerSecond :: proc(wand: ^MagickWand) -> c.size_t ---
        MagickGetImageWidth :: proc(wand: ^MagickWand) -> c.size_t ---
        MagickGetNumberImages :: proc(wand: ^MagickWand) -> c.size_t ---

        MagickGetImageBlob :: proc(wand: ^MagickWand, blob: rawptr) -> ^c.uchar ---
        MagickGetImagesBlob :: proc(wand: ^MagickWand, blob: rawptr) -> ^c.uchar ---

        MagickGetVirtualPixelMethod :: proc(wand: ^MagickWand) -> VirtualPixelMethod ---
        MagickSetVirtualPixelMethod :: proc(wand: ^MagickWand, method: VirtualPixelMethod) -> VirtualPixelMethod ---

        // MagickWand/magick-property.h
        MagickGetFilename :: proc(wand: ^MagickWand) -> cstring ---
        MagickGetFormat :: proc(wand: ^MagickWand) -> cstring ---
        MagickGetFont :: proc(wand: ^MagickWand) ->  cstring ---
        MagickGetHomeURL :: proc() -> cstring ---
        MagickGetImageArtifact :: proc(wand: ^MagickWand, artifact: cstring) -> cstring ---
        MagickGetImageArtifacts :: proc(wand: ^MagickWand, artifact: cstring, number_artifacts: ^c.size_t) -> [^]cstring ---
        MagickGetImageProfiles :: proc(wand: ^MagickWand, pattern: cstring, number_profiles: ^c.size_t) -> [^]cstring ---
        MagickGetImageProperty :: proc(wand: ^MagickWand, property: cstring) -> cstring ---
        MagickGetImageProperties :: proc(wand: ^MagickWand, pattern: cstring, number_properties: ^c.size_t) -> [^]cstring ---
        MagickGetOption :: proc(wand: ^MagickWand, key: cstring) -> cstring ---
        MagickGetOptions :: proc(wand: ^MagickWand, pattern: cstring, number_options: ^c.size_t) -> [^]cstring ---
        // these ones have their bodies in magick-wand.c not magick-property.h
        MagickQueryConfigureOption :: proc(option: cstring) -> cstring ---
        MagickQueryConfigureOptions :: proc(pattern: cstring, number_options: ^c.size_t) -> [^]cstring ---
        MagickQueryFonts :: proc(pattern: cstring, number_fonts: ^c.size_t) -> [^]cstring ---
        MagickQueryFormats:: proc(pattern: cstring, number_fonts: ^c.size_t) -> [^]cstring ---

        MagickGetColorspace :: proc(wand: ^MagickWand) -> ColorspaceType ---
        
        MagickGetCompression :: proc(wand: ^MagickWand) -> CompressionType ---

        MagickGetCopyright :: proc() -> cstring ---
        MagickGetPackageName :: proc() -> cstring ---
        MagickGetQuantumDepth :: proc(depth: ^c.size_t) -> cstring ---
        MagickGetQuantumRange :: proc(range: ^c.size_t) -> cstring ---
        MagickGetReleaseDate :: proc() -> cstring ---
        MagickGetVersion :: proc(version: ^c.size_t) -> cstring ---

        MagickGetPointSize :: proc(wand: ^MagickWand) -> c.double ---
        MagickGetSamplingFactors :: proc(wand: ^MagickWand, number_factors: ^c.size_t) -> ^c.double ---
        MagickQueryFontMetrics :: proc(wand: ^MagickWand, drawing_wand: ^DrawingWand, text: cstring) -> ^c.double ---
        MagickQueryMultilineFontMetrics :: proc(wand: ^MagickWand, drawing_wand: ^DrawingWand, text: cstring) -> ^c.double ---

        MagickGetFilter :: proc(wand: ^MagickWand) -> FilterType ---

        MagickGetGravity :: proc(wand: ^MagickWand) -> GravityType ---

        MagickGetType :: proc(wand: ^MagickWand) -> ImageType ---

        MagickGetInterlaceScheme :: proc(wand: ^MagickWand) -> InterlaceType ---

        MagickGetInterpolateMethod :: proc(wand: ^MagickWand) -> PixelInterpolateMethod ---

        MagickGetOrientation :: proc(wand: ^MagickWand) -> OrientationType ---

        MagickDeleteImageArtifact :: proc(wand: ^MagickWand, artifact: cstring) -> MagickBooleanType ---
        MagickDeleteImageProperty :: proc(wand: ^MagickWand, property: cstring) -> MagickBooleanType ---
        MagickDeleteOption :: proc(wand: ^MagickWand, option: cstring) -> MagickBooleanType ---
        MagickGetAntialias :: proc(wand: ^MagickWand) -> MagickBooleanType ---
        MagickGetPage :: proc(wand: ^MagickWand, width: ^c.size_t, height: ^c.size_t, x: ^c.ssize_t, y: ^c.ssize_t) -> MagickBooleanType ---
        MagickGetResolution :: proc(wand: ^MagickWand, x: ^c.double, y: ^c.double) -> MagickBooleanType ---
        MagickGetSize :: proc(wand: ^MagickWand, columns: ^c.size_t, rows: ^c.size_t) -> MagickBooleanType ---
        MagickGetSizeOffset :: proc(wand: ^MagickWand, offset: ^c.ssize_t) -> MagickBooleanType ---
        MagickProfileImage :: proc(wand: ^MagickWand, name: cstring, profile: rawptr, length: c.size_t) -> MagickBooleanType ---
        MagickSetAntialias :: proc(wand: ^MagickWand, antialias: MagickBooleanType) -> MagickBooleanType ---
        MagickSetBackgroundColor :: proc(wand: ^MagickWand, background: ^PixelWand) -> MagickBooleanType ---
        MagickSetColorspace :: proc(wand: ^MagickWand, colorspace: ColorspaceType) -> MagickBooleanType ---
        MagickSetCompression :: proc(wand: ^MagickWand, compression: CompressionType) -> MagickBooleanType ---
        MagickSetCompressionQuality :: proc(wand: ^MagickWand, quality: c.size_t) -> MagickBooleanType ---
        MagickSetDepth :: proc(wand: ^MagickWand, depth: c.size_t) -> MagickBooleanType ---
        MagickSetExtract :: proc(wand: ^MagickWand, geometry: cstring) -> MagickBooleanType ---
        MagickSetFilename :: proc(wand: ^MagickWand, filename: cstring) -> MagickBooleanType ---
        MagickSetFilter :: proc(wand: ^MagickWand, type: FilterType) -> MagickBooleanType ---
        MagickSetFormat :: proc(wand: ^MagickWand, format: cstring) -> MagickBooleanType ---
        MagickSetFont :: proc(wand: ^MagickWand, font: cstring) -> MagickBooleanType ---
        MagickSetGravity :: proc(wand: ^MagickWand, type: GravityType) -> MagickBooleanType ---
        MagickSetImageArtifact :: proc(wand: ^MagickWand, artifact: cstring, value: cstring) -> MagickBooleanType ---
        MagickSetImageProfile :: proc(wand: ^MagickWand, name: cstring, profile: rawptr, length: c.size_t) -> MagickBooleanType ---
        MagickSetImageProperty :: proc(wand: ^MagickWand, property: cstring, value: cstring) -> MagickBooleanType ---
        MagickSetInterlaceScheme :: proc(wand: ^MagickWand, interlace_scheme: InterlaceType) -> MagickBooleanType ---
        MagickSetInterpolateMethod :: proc(wand: ^MagickWand, method: PixelInterpolateMethod) -> MagickBooleanType ---
        MagickSetOption :: proc(wand: ^MagickWand, property: cstring, value: cstring) -> MagickBooleanType ---
        MagickSetOrientation :: proc(wand: ^MagickWand, orientation: OrientationType) -> MagickBooleanType ---
        MagickSetPage :: proc(wand: ^MagickWand, width: c.size_t, height: c.size_t, x: c.ssize_t, y: c.ssize_t) -> MagickBooleanType ---
        MagickSetPassphrase :: proc(wand: ^MagickWand, passphrase: cstring) -> MagickBooleanType ---
        MagickSetPointsize :: proc(wand: ^MagickWand, pointsize: c.double) -> MagickBooleanType ---
        MagickSetResolution :: proc(wand: ^MagickWand, x_resolution: c.double, y_resolution: c.double) -> MagickBooleanType ---
        MagickSetResourceLimit :: proc(type: ResourceType) -> MagickBooleanType ---
        MagickSetSamplingFactors :: proc(wand: ^MagickWand, number_factors: c.size_t, sampling_factors: ^c.double) -> MagickBooleanType ---
        MagickSetSecurityPolicy :: proc(wand: ^MagickWand, policy: cstring) -> MagickBooleanType ---
        MagickSetSize :: proc(wand: ^MagickWand, columns: c.size_t, rows: c.size_t) -> MagickBooleanType ---
        MagickSetSizeOffset :: proc(wand: ^MagickWand, columns: c.size_t, rows: c.size_t, offset: c.ssize_t) -> MagickBooleanType ---

        MagickSetProgressMonitor :: proc(wand: ^MagickWand, progress_monitor: MagickProgressMonitor, client_data: rawptr) -> MagickProgressMonitor ---

        MagickGetResource :: proc(type: ResourceType) -> MagickSizeType ---
        MagickGetResourceLimit :: proc(type: ResourceType) -> MagickSizeType ---

        MagickGetBackgroundColor :: proc(wand: ^MagickWand) -> ^PixelWand ---

        MagickGetOrientationType :: proc(wand: ^MagickWand) -> OrientationType ---

        MagickGetCompressionQuality :: proc(wand: ^MagickWand) -> c.size_t ---

        MagickGetImageProfile :: proc(wand: ^MagickWand, name: cstring, length: ^c.size_t) -> ^c.uchar ---
        MagickRemoveImageProfile :: proc(wand: ^MagickWand, name: cstring, length: ^c.size_t) -> ^c.uchar ---

        MagickSetSeed :: proc(seed: c.ulong) ---
    }

}