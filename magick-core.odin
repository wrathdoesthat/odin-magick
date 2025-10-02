package odin_magick

import "core:c"

/* 
    TODO LIST:
    blob.h
    cache.h
    cipher.h
    compress.h
    locale_.h
    memory_.h
    mime.h
    module.h
    monitor.h
    mutex.h
    policy.h
    quantum.h
    registry.h
    resource_.h
    splay-tree.h
    static.h
    string_.h
    studio.h
    thread_.h
    threshold.h
    timer.h
    token.h
    utility.h
    version.h
    xml-tree.h
    x-window.h

    // Not adding
    most of the stuff in -private.h files
    deprecate.h (The functions are deprecated)
    nt-base-private.h
    nt-base.h
    nt-feature.h
    opencl.h
    vms.h
    widget.h (empty)
    
*/

@(default_calling_convention="c")
foreign magick_core { 
    // magick.h
    GetMagickList :: proc(pattern: cstring, number_formats: ^c.size_t, exception: ^ExceptionInfo) -> [^]^c.char ---

    GetMagickDescription :: proc(magick_info: ^MagickInfo) -> cstring ---
    GetMagickMimeType :: proc(magick_info: ^MagickInfo) -> cstring ---
    GetMagickModuleName :: proc(magick_info: ^MagickInfo) -> cstring ---
    GetMagickName :: proc(magick_info: ^MagickInfo) -> cstring ---

    GetImageDecoder :: proc(magick_info: ^MagickInfo) -> ^DecodeImageHandler ---
    
    GetImageEncoder :: proc(magick_info: ^MagickInfo) -> ^EncodeImageHandler ---

    GetMagickPrecision :: proc() -> c.int ---
    SetMagickPrecision :: proc(precision: c.int) -> c.int ---

    GetImageMagick :: proc(magick: ^c.uchar, length: c.size_t, format: cstring) -> MagickBooleanType ---
    GetMagickAdjoin :: proc(magick_info: ^MagickInfo) -> MagickBooleanType ---
    GetMagickBlobSupport :: proc(magick_info: ^MagickInfo) -> MagickBooleanType ---
    GetMagickDecoderSeekableStream :: proc(magick_info: ^MagickInfo) -> MagickBooleanType ---
    GetMagickDecoderThreadSupport :: proc(magick_info: ^MagickInfo) -> MagickBooleanType ---
    GetMagickEncoderSeekableStream :: proc(magick_info: ^MagickInfo) -> MagickBooleanType ---
    GetMagickEncoderThreadSupport :: proc(magick_info: ^MagickInfo) -> MagickBooleanType ---
    GetMagickEndianSupport :: proc(magick_info: ^MagickInfo) -> MagickBooleanType ---
    GetMagickRawSupport :: proc(magick_info: ^MagickInfo) -> MagickBooleanType ---
    GetMagickStealth :: proc(magick_info: ^MagickInfo) -> MagickBooleanType ---
    GetMagickUseExtension :: proc(magick_info: ^MagickInfo) -> MagickBooleanType ---
    IsMagickCoreInstantiated :: proc() -> MagickBooleanType ---
    RegisterMagickInfo :: proc(magick_info: ^MagickInfo) -> MagickBooleanType ---
    UnregisterMagickInfo :: proc(name: cstring) -> MagickBooleanType ---

    GetMagickInfo :: proc(name: cstring, exception: ^ExceptionInfo) -> ^MagickInfo ---
    GetMagickInfoList :: proc(pattern: cstring, number_formats: ^c.size_t, exception: ^ExceptionInfo) -> [^]^MagickInfo ---

    AcquireMagickInfo :: proc(magick_module: cstring, name: cstring, description: cstring) -> ^MagickInfo ---

    MagickCoreGenesis :: proc(path: cstring, establish_signal_handlers: MagickBooleanType) ---
    MagickCoreTerminus :: proc() ---

    // animate.h
    AnimateImages :: proc(image_info: ^ImageInfo, images: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---

    // annotate.h
    AnnotateImage :: proc(image: ^Image, draw_info: ^DrawInfo, exception: ^ExceptionInfo) -> MagickBooleanType ---
    GetMultilineTypeMetrics :: proc(image: ^Image, draw_info: ^DrawInfo, metrics: ^TypeMetric, exception: ^ExceptionInfo) -> MagickBooleanType ---
    GetTypeMetrics :: proc(image: ^Image, draw_info: ^DrawInfo, metrics: ^TypeMetric, exception: ^ExceptionInfo) -> MagickBooleanType ---

    FormatMagickCaption :: proc(image: ^Image, draw_info: ^DrawInfo, split: MagickBooleanType, metrics: ^TypeMetric, caption: [^]cstring, exception: ^ExceptionInfo) -> c.size_t ---

    // artifact.h
    RemoveImageArtifact :: proc(image: ^Image, artifact: cstring) -> cstring ---

    GetNextImageArtifact :: proc(image: ^Image) -> cstring ---
    GetImageArtifact :: proc(image: ^Image, artifact: cstring) -> cstring ---

    CloneImageArtifacts :: proc(image: ^Image, clone_image: ^Image) -> MagickBooleanType ---
    DefineImageArtifact :: proc(image: ^Image, artifact: cstring) -> MagickBooleanType ---
    DeleteImageArtifact :: proc(image: ^Image, artifact: cstring) -> MagickBooleanType ---
    SetImageArtifact  :: proc(image: ^Image, artifact: cstring, value: cstring) -> MagickBooleanType ---

    DestroyImageArtifacts :: proc(image: ^Image) ---
    ResetImageArtifactIterator :: proc(image: ^Image) ---

    // attribute.h
    GetImageType :: proc(image: ^Image) -> ImageType ---
    IdentifyImageGray :: proc(image: ^Image, exception: ^ExceptionInfo) -> ImageType ---
    IdentifyImageType :: proc(image: ^Image, exception: ^ExceptionInfo) -> ImageType ---

    IdentifyImageMonochrome :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    IsImageGray :: proc(image: ^Image) -> MagickBooleanType ---
    IsImageMonochrome :: proc(image: ^Image) -> MagickBooleanType ---
    IsImageOpaque :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetImageDepth :: proc(image: ^Image, depth: c.size_t, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetImageType :: proc(image: ^Image, type: ImageType, exception: ^ExceptionInfo) -> MagickBooleanType ---

    GetImageConvexHull :: proc(image: ^Image, number_vertices: ^c.size_t, exception: ^ExceptionInfo) -> ^PointInfo ---
    GetImageMinimumBoundingBox :: proc(image: ^Image, number_vertices: ^c.size_t, exception: ^ExceptionInfo) -> ^PointInfo ---

    GetImageDepth :: proc(image: ^Image, exception: ^ExceptionInfo) -> c.size_t ---
    GetImageQuantumDepth :: proc(image: ^Image, constrain: MagickBooleanType) -> c.size_t ---

    // channel.h
    ChannelFxImage :: proc(image: ^Image, expression: cstring, exception: ^ExceptionInfo) -> ^Image ---
    CombineImages :: proc(image: ^Image, colorspace: ColorspaceType, exception: ^ExceptionInfo) -> ^Image ---
    SeparateImage :: proc(image: ^Image, channel_type: ChannelType, exception: ^ExceptionInfo) -> ^Image ---
    SeparateImages :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^Image ---

    GetImageAlphaChannel :: proc(image: ^Image) -> MagickBooleanType ---
    SetImageAlphaChannel :: proc(image: ^Image, alpha_type: AlphaChannelOption, exception: ^ExceptionInfo) -> MagickBooleanType ---
    
    // cipher.h
    DecipherImage :: proc(image: ^Image, passphrase: cstring, exception: ^ExceptionInfo) -> MagickBooleanType ---
    EncipherImage :: proc(image: ^Image, passphrase: cstring, exception: ^ExceptionInfo) -> MagickBooleanType ---
    PasskeyDecipherImage :: proc(image: ^Image, passkey: ^StringInfo, exception: ^ExceptionInfo) -> MagickBooleanType ---
    PasskeyEncipherImage :: proc(image: ^Image, passkey: ^StringInfo, exception: ^ExceptionInfo) -> MagickBooleanType ---
    
    // client.h
    GetClientPath :: proc() -> cstring ---
    GetClientName :: proc() -> cstring ---
    SetClientName :: proc(name: cstring) -> cstring ---
    SetClientPath :: proc(path: cstring) -> cstring ---

    // color.h
    GetColorList :: proc(pattern: cstring, number_colors: ^c.size_t, exception: ^ExceptionInfo) -> [^]cstring ---

    GetColorInfo :: proc(name: cstring, exception: ^ExceptionInfo) -> ^ColorInfo ---
    GetColorInfoList :: proc(pattern: cstring, number_colors: ^c.size_t, exception: ^ExceptionInfo) -> [^]^ColorInfo ---

    IsEquivalentImage :: proc(image: ^Image, target_iamge: ^Image, x_offset: ^c.ssize_t, y_offset: ^c.ssize_t, exception: ^ExceptionInfo) -> MagickBooleanType ---
    ListColorInfo :: proc(file: ^c.FILE, exception: ^ExceptionInfo) -> MagickBooleanType ---
    QueryColorCompliance :: proc(name: cstring, compliance: ComplianceType, color: ^PixelInfo, exception: ^ExceptionInfo) -> MagickBooleanType ---
    QueryColorname :: proc(image: ^Image, color: ^PixelInfo, compliance: ComplianceType, name: cstring, exception: ^ExceptionInfo) -> MagickBooleanType ---

    ConcatenateColorComponent :: proc(pixel: ^PixelInfo, channel: PixelChannel, compliance: ComplianceType, tuple: cstring) ---
    GetColorTuple :: proc(pixel: ^PixelInfo, hex: MagickBooleanType, tuple: cstring) ---

    // colormap.h
    AcquireImageColormap :: proc(image: ^Image, colors: c.size_t, exception: ^ExceptionInfo) -> MagickBooleanType ---
    CycleColormapImage :: proc(image: ^Image, displace: c.ssize_t, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SortColormapByIntensity :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---

    // colorspace.h
    GetImageColorspaceType :: proc(image: ^Image, exception: ^ExceptionInfo) -> ColorspaceType ---

    SetImageColorspace :: proc(image: ^Image, colorspace: ColorspaceType, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetImageGray :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetImageMonochrome :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    TransformImageColorspace :: proc(image: ^Image, colorspace: ColorspaceType, exception: ^ExceptionInfo) -> MagickBooleanType ---

    // compare.h
    GetImageDistortions :: proc(image: ^Image, reconstruct_image: ^Image, metric: MetricType, exception: ^ExceptionInfo) -> ^c.double ---

    CompareImages :: proc(image: ^Image, reconstruct_image: ^Image, metric: MetricType, distortion: ^c.double, exception: ^ExceptionInfo) -> ^Image ---
    SimilarityImage :: proc(image: ^Image, reconstruct: ^Image, metric: MetricType, similarity_threshold: c.double, offset: ^RectangleInfo, similarity_metric: ^c.double, exception: ^ExceptionInfo) -> ^Image ---

    GetImageDistortion :: proc(image: ^Image, reconstruct_image: ^Image, metric: MetricType, exception: ^ExceptionInfo) -> MagickBooleanType ---
    IsImagesEqual :: proc(image: ^Image, reconstruct_image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetImageColorMetric :: proc(image: ^Image, reconstruct_image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---

    // composite.h
    CompositeImage :: proc(image: ^Image, composite: ^Image, compose: CompositeOperator, clip_to_self: MagickBooleanType, x_offset: c.ssize_t, y_offset: c.ssize_t, exception: ^ExceptionInfo) -> MagickBooleanType ---
    TextureImage :: proc(image: ^Image, texture: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---

    // configure.h
    GetConfigureList :: proc(pattern: cstring, number_options: ^c.size_t, exception: ^ExceptionInfo) -> [^]cstring ---
    GetConfigureOption :: proc(option: cstring) -> cstring ---

    GetConfigureValue :: proc(configure_info: ^ConfigureInfo) -> cstring ---

    GetConfigureInfo :: proc(name: cstring, exception: ^ExceptionInfo) -> cstring ---
    GetConfigureInfoList :: proc(pattern: cstring, number_options: ^c.size_t, exception: ^ExceptionInfo) -> [^]cstring ---

    DestroyConfigureOptions :: proc(options: ^LinkedListInfo) -> ^LinkedListInfo ---
    GetConfigurePaths :: proc(filename: cstring, exception: ^ExceptionInfo) -> ^LinkedListInfo ---
    GetConfigureOptions :: proc(filename: cstring, exception: ^ExceptionInfo) -> ^LinkedListInfo ---
    
    ListConfigureInfo :: proc(file: ^c.FILE, exception: ^ExceptionInfo) -> MagickBooleanType ---

    // constitute.h
    ConstituteImage :: proc(columns: c.size_t, rows: c.size_t, map_: cstring, storage: StorageType, pixels: rawptr, exception: ^ExceptionInfo) -> ^Image ---
    PingImage :: proc(image_info: ^ImageInfo, exception: ^ExceptionInfo) -> ^Image ---
    PingImages :: proc(image_info: ^ImageInfo, filename: cstring, exception: ^ExceptionInfo) -> ^Image ---
    ReadImage :: proc(image_info: ^ImageInfo, exception: ^ExceptionInfo) -> ^Image ---
    ReadImages :: proc(image_info: ^ImageInfo, filename: cstring, exception: ^ExceptionInfo) -> ^Image ---
    ReadInlineImage :: proc(image_info: ^ImageInfo, content: cstring, exception: ^ExceptionInfo) -> ^Image ---
    
    WriteImage :: proc(image_info: ^ImageInfo, image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    WriteImages :: proc(image_info: ^ImageInfo, image: ^Image, filename: cstring, exception: ^ExceptionInfo) -> MagickBooleanType ---

    // decorate.h
    BorderImage :: proc(image: ^Image, border_info: ^RectangleInfo, compose: CompositeOperator, exception: ^ExceptionInfo) -> ^Image ---
    FrameImage :: proc(image: ^Image, frame_info: ^FrameInfo, compose: CompositeOperator, exception: ^ExceptionInfo) -> ^Image ---
    
    RaiseImage :: proc(image: ^Image, raise_info: ^RectangleInfo, raise: MagickBooleanType, exception: ^ExceptionInfo) -> MagickBooleanType ---

    // delegate.h
    GetDelegateCommand :: proc(image_info: ^ImageInfo, image: ^Image, decode: cstring, encode: cstring, exception: ^ExceptionInfo) -> cstring ---
    GetDelegateList :: proc(pattern: cstring, number_delegates: ^c.size_t, exception: ^ExceptionInfo) -> [^]cstring ---

    GetDelegateCommands :: proc(delegate_info: ^DelegateInfo) -> cstring ---

    GetDelegateInfo :: proc(decode: cstring, encode: cstring, exception: ^ExceptionInfo) -> ^DelegateInfo ---
    GetDelegateInfoList :: proc(pattern: cstring, number_delegates: ^c.size_t, exception: ^ExceptionInfo) -> [^]^DelegateInfo ---

    ExternalDelegateCommand :: proc(asynchronous: MagickBooleanType, verbose: MagickBooleanType, command: cstring, message: cstring, exception: ^ExceptionInfo) -> int ---

    GetDelegateMode :: proc(delegate_info: ^DelegateInfo) -> c.ssize_t ---

    GetDelegateThreadSupport :: proc(delegate_info: ^DelegateInfo) -> MagickBooleanType ---
    InvokeDelegate :: proc(image_info: ^ImageInfo, image: ^Image, decode: cstring, encode: cstring, exception: ^ExceptionInfo) -> MagickBooleanType ---
    ListDelegateInfo :: proc(file: ^c.FILE, exception: ^ExceptionInfo) -> MagickBooleanType ---

    // display.h
    DisplayImages :: proc(image_info: ^ImageInfo, images: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    RemoteDisplayCommand :: proc(image_info: ^ImageInfo, window: cstring, filename: cstring, exception: ^ExceptionInfo) -> MagickBooleanType ---

    // distort.h
    AffineTransformImage :: proc(image: ^Image, affine_matrix: ^AffineMatrix, exception: ^ExceptionInfo) -> ^Image ---
    DistortImage :: proc(image: ^Image, method: DistortMethod, number_arguments: c.size_t, arguments: ^c.double, bestfit: MagickBooleanType, exception: ^ExceptionInfo) -> ^Image ---
    DistortResizeImage :: proc(image: ^Image, columns: c.size_t, rows: c.size_t, exception: ^ExceptionInfo) -> ^Image ---
    RotateImage :: proc(image: ^Image, degrees: c.double, exception: ^ExceptionInfo) -> ^Image ---
    SparseColorImage :: proc(image: ^Image, method: SparseColorMethod, number_arguments: c.size_t, arguments: ^c.double, exception: ^ExceptionInfo) -> ^Image ---

    // distribute-cache.h
    DistributePixelCacheServer :: proc(server: c.int, exception: ^ExceptionInfo) ---

    // draw.h
    AcquireDrawInfo :: proc() -> ^DrawInfo ---
    CloneDrawInfo :: proc(image_info: ^ImageInfo, draw_info: ^DrawInfo) -> ^DrawInfo ---
    DestroyDrawInfo :: proc(draw_info: ^DrawInfo) -> ^DrawInfo ---

    DrawAffineImage :: proc(image: ^Image, source: ^Image, affine: ^AffineMatrix, exception: ^ExceptionInfo) -> MagickBooleanType ---
    DrawClipPath :: proc(image: ^Image, draw_info: ^DrawInfo, id: cstring, exception: ^ExceptionInfo) -> MagickBooleanType ---
    DrawGradientImage :: proc(image: ^Image, draw_info: ^DrawInfo, exception: ^ExceptionInfo) -> MagickBooleanType ---
    DrawImage :: proc(image: ^Image, draw_info: ^DrawInfo, exception: ^ExceptionInfo) -> MagickBooleanType ---
    DrawPatternPath :: proc(image: ^Image, draw_info: ^DrawInfo, name: cstring, pattern: [^]^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    DrawPrimitive :: proc(image: ^Image, draw_info: ^DrawInfo, primitive_info: ^PrimitiveInfo, exception: ^ExceptionInfo) -> MagickBooleanType ---

    GetAffineMatrix :: proc(affine_matrix: ^AffineMatrix) ---
    GetDrawInfo :: proc(image_info: ^ImageInfo, draw_info: ^DrawInfo) ---

    // effect.h
    AdaptiveBlurImage :: proc(image: ^Image, radius: c.double, sigma: c.double, exception: ^ExceptionInfo) -> ^Image ---
    AdaptiveSharpenImage :: proc(image: ^Image, radius: c.double, sigma: c.double, exception: ^ExceptionInfo) -> ^Image ---
    BilateralBlurImage :: proc(image: ^Image, width: c.size_t, height: c.size_t, intensity_sigma: c.double, spatial_sigma: c.double, exception: ^ExceptionInfo) -> ^Image ---
    BlurImage :: proc(image: ^Image, radius: c.double, sigma: c.double, exception: ^ExceptionInfo) -> ^Image ---
    ConvolveImage :: proc(image: ^Image, kernel_info: ^KernelInfo, exception: ^ExceptionInfo) -> ^Image ---
    DespeckleImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^Image ---
    EdgeImage :: proc(image: ^Image, radius: c.double, exception: ^ExceptionInfo) -> ^Image ---
    EmbossImage :: proc(image: ^Image, radius: c.double, sigma: c.double, exception: ^ExceptionInfo) -> ^Image ---
    GaussianBlurImage :: proc(image: ^Image, radius: c.double, sigma: c.double, exception: ^ExceptionInfo) -> ^Image ---
    KuwaharaImage :: proc(image: ^Image, radius: c.double, sigma: c.double, exception: ^ExceptionInfo) -> ^Image ---
    LocalContrastImage :: proc(image: ^Image, radius: c.double, strength: c.double, exception: ^ExceptionInfo) -> ^Image ---
    MotionBlurImage :: proc(image: ^Image, radius: c.double, sigma: c.double, angle: c.double, exception: ^ExceptionInfo) -> ^Image ---
    PreviewImage :: proc(image: ^Image, preview: PreviewType, exception: ^ExceptionInfo) -> ^Image ---
    RotationalBlurImage :: proc(image: ^Image, angle: c.double, exception: ^ExceptionInfo) -> ^Image ---
    SelectiveBlurImage :: proc(image: ^Image, radius: c.double, sigma: c.double, threshold: c.double, exception: ^ExceptionInfo) -> ^Image ---
    ShadeImage :: proc(image: ^Image, gray: MagickBooleanType, azimuth: c.double, elevation: c.double, exception: ^ExceptionInfo) -> ^Image ---
    SharpenImage :: proc(image: ^Image, radius: c.double, sigma: c.double, exception: ^ExceptionInfo) -> ^Image ---
    SpreadImage :: proc(image: ^Image, method: PixelInterpolateMethod, radius: c.double, exception: ^ExceptionInfo) -> ^Image ---
    UnsharpMaskImage :: proc(image: ^Image, radius: c.double, sigma: c.double, gain: c.double, threshold: c.double, exception: ^ExceptionInfo) -> ^Image ---

    // enhance.h
    AutoGammaImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    AutoLevelImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    BrightnessContrastImage :: proc(image: ^Image, brightness: c.double, contrast: c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    CLAHEImage :: proc(image: ^Image, width: c.size_t, height: c.size_t, number_buns: c.size_t, clip_limit: c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    ClutImage :: proc(image: ^Image, clut_image: ^Image, method: PixelInterpolateMethod, exception: ^ExceptionInfo) -> MagickBooleanType ---
    ColorDecisionListImage :: proc(image: ^Image, color_correction_collection: cstring, exception: ^ExceptionInfo) -> MagickBooleanType ---
    ContrastImage :: proc(image: ^Image, sharpen: MagickBooleanType, exception: ^ExceptionInfo) -> MagickBooleanType ---
    ContrastStretchImage :: proc(image: ^Image, black_point: c.double, white_point: c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    EqualizeImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    GammaImage :: proc(image: ^Image, gamma: c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    GrayscaleImage :: proc(image: ^Image, method: PixelIntensityMethod, exception: ^ExceptionInfo) -> MagickBooleanType ---
    HaldClutImage :: proc(image: ^Image, hald_image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    LevelImage :: proc(image: ^Image, black_point: c.double, white_point: c.double, gamma: c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    LevelizeImage :: proc(image: ^Image, black_point: c.double, white_point: c.double, gamma: c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    LevelImageColors :: proc(image: ^Image, black_color: ^PixelInfo, white_color: ^PixelInfo, invert: MagickBooleanType, exception: ^ExceptionInfo) -> MagickBooleanType ---
    LinearStretchImage :: proc(image: ^Image, black_point: c.double, white_point: c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    ModulateImage :: proc(image: ^Image, modulate: cstring, exception: ^ExceptionInfo) -> MagickBooleanType ---
    NegateImage :: proc(image: ^Image, grayscale: MagickBooleanType, exception: ^ExceptionInfo) -> MagickBooleanType ---
    NormalizeImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SigmoidalContrastImage :: proc(image: ^Image, sharpen: MagickBooleanType, constrast: c.double, midpoint: c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    WhiteBalanceImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---

    EnhanceImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^Image ---

    // feature.h
    GetImageFeatures :: proc(image: ^Image, distance: c.size_t, exception: ^ExceptionInfo) -> ^ChannelFeatures ---

    CannyEdgeImage :: proc(image: ^Image, radius: c.double, sigma: c.double, lower_percent: c.double, upper_percent: c.double, exception: ^ExceptionInfo) -> ^Image ---
    HoughLineImage :: proc(image: ^Image, width: c.size_t, height: c.size_t, threshold: c.size_t, exception: ^ExceptionInfo) -> ^Image ---
    MeanShiftImage :: proc(image: ^Image, width: c.size_t, height: c.size_t, color_distance: c.double, exception: ^ExceptionInfo) -> ^Image ---
    
    // fourier.h
    ComplexImages :: proc(image: ^Image, op: ComplexOperator, exception: ^ExceptionInfo) -> ^Image ---
    ForwardFourierTransformImage :: proc(image: ^Image, modulus: MagickBooleanType, exception: ^ExceptionInfo) -> ^Image ---
    InverseFourierTransformImage :: proc(magnitude_image: ^Image, phase_image: ^Image, modulus: MagickBooleanType, exception: ^ExceptionInfo) -> ^Image ---

    // fx.h
    FxImage :: proc(image: ^Image, expression: cstring, exception: ^ExceptionInfo) -> ^Image ---

    // gem.h
    ExpandAffine :: proc(affine: ^AffineMatrix) -> c.double ---

    ConvertHSLToRGB :: proc(hue: c.double, saturation: c.double, lightness: c.double, red: ^c.double, green: ^c.double, blue: ^c.double) ---
    ConvertRGBToHSL :: proc(red: c.double, green: c.double, blue: c.double, hue: ^c.double, saturation: ^c.double, lightness: ^c.double) ---

    // geometry.h
    GetPageGeometry :: proc(page_geometry: cstring) -> cstring ---

    IsGeometry :: proc(geometry: cstring) -> MagickBooleanType ---
    IsSceneGeometry :: proc(geometry: cstring, pedantic: MagickBooleanType) -> MagickBooleanType ---

    GetGeometry :: proc(geometry: cstring, x: ^c.ssize_t, y: ^c.ssize_t, width: ^c.size_t, height: ^c.size_t) -> MagickStatusType ---
    ParseAbsoluteGeometry :: proc(geometry: cstring, region_info: ^RectangleInfo) -> MagickStatusType ---
    ParseAffineGeometry :: proc(geometry: cstring, affine_matrix: ^AffineMatrix, exception: ^ExceptionInfo) -> MagickStatusType ---
    ParseGeometry :: proc(geometry: cstring, geometry_info: ^GeometryInfo) -> MagickStatusType ---
    ParseGravityGeometry :: proc(image: ^Image, geometry: cstring, region_info: ^RectangleInfo, exception: ^ExceptionInfo) -> MagickStatusType ---
    ParseMetaGeometry :: proc(geometry: cstring, x: ^c.ssize_t, y: ^c.ssize_t, width: ^c.size_t, height: ^c.size_t) -> MagickStatusType ---
    ParsePageGeometry :: proc(image: ^Image, geometry: cstring, region_info: ^RectangleInfo, exception: ^ExceptionInfo) -> MagickStatusType ---
    ParseRegionGeometry :: proc(image: ^Image, geometry: cstring, region_info: ^RectangleInfo, exception: ^ExceptionInfo) -> MagickStatusType ---

    GravityAdjustGeometry :: proc(width: c.size_t, height: c.size_t, gravity: GravityType, region: ^RectangleInfo) ---
    SetGeometry :: proc(image: ^Image, geometry: ^RectangleInfo) ---
    SetGeometryInfo :: proc(geometry_info: ^GeometryInfo) ---

    // histogram.h
    GetImageHistogram :: proc(image: ^Image, number_colors: ^c.size_t, exception: ^ExceptionInfo) -> ^PixelInfo ---

    UniqueImageColors :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^Image ---

    IdentifyPaletteImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    IsHistogramImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    IsPaletteImage :: proc(image: ^Image) -> MagickBooleanType ---
    MinMaxStretchImage :: proc(image: ^Image, black: c.double, white: c.double, gamma: c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---

    GetNumberColors :: proc(image: ^Image, file: ^c.FILE, exception: ^ExceptionInfo) -> c.size_t ---

    // identify.h
    IdentifyImage :: proc(image: ^Image, file: ^c.FILE, verbose: MagickBooleanType, exception: ^ExceptionInfo) -> MagickBooleanType ---

    // image.h
    SetImageChannelMask :: proc(image: ^Image, channel_mask: ChannelType) -> ChannelType ---

    CatchImageException :: proc(image: ^Image) -> ExceptionType ---

    GetImageInfoFile :: proc(image_info: ^ImageInfo) -> ^c.FILE ---

    AcquireImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^Image ---
    AppendImages :: proc(image: ^Image, stack: MagickBooleanType, exception: ^ExceptionType) -> ^Image ---
    CloneImage :: proc(image: ^Image, columns: c.size_t, rows: c.size_t, detach: MagickBooleanType, exception: ^ExceptionInfo) -> ^Image ---
    DestroyImage :: proc(image: ^Image) -> ^Image ---
    GetImageMask :: proc(image: ^Image, type: PixelMask, exception: ^ExceptionInfo) -> ^Image ---
    NewMagickImage :: proc(image_info: ^ImageInfo, width: c.size_t, height: c.size_t, background: ^PixelInfo, exception: ^ExceptionInfo) -> ^Image ---
    ReferenceImage :: proc(image: ^Image) -> ^Image ---
    SmushImages :: proc(image: ^Image, stack: MagickBooleanType, offset: c.ssize_t, exception: ^ExceptionInfo) -> ^Image ---

    AcquireImageInfo :: proc() -> ^ImageInfo ---
    CloneImageInfo :: proc(image_info: ^ImageInfo) -> ^ImageInfo ---
    DestroyImageInfo :: proc(image_info: ^ImageInfo) -> ^ImageInfo ---

    ClipImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    ClipImagePath :: proc(image: ^Image, pathname: cstring, inside: MagickBooleanType, exception: ^ExceptionInfo) -> MagickBooleanType ---
    CopyImagePixels :: proc(image: ^Image, source_image: ^Image, geometry: ^RectangleInfo, offset: ^OffsetInfo, exception: ^ExceptionInfo) -> MagickBooleanType ---
    IsTaintImage :: proc(image: ^Image) -> MagickBooleanType ---
    IsHighDynamicRangeImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    IsImageObject :: proc(image: ^Image) -> MagickBooleanType ---
    ListMagickInfo :: proc(file: ^c.FILE, exception: ^ExceptionInfo) -> MagickBooleanType ---
    ModifyImage :: proc(image: ^^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    ResetImagePage :: proc(image: ^Image, page: cstring) -> MagickBooleanType ---
    ResetImagePixels :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetImageAlpha :: proc(image: ^Image, alpha: Quantum, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetImageBackgroundColor :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetImageColor :: proc(image: ^Image, color: ^PixelInfo, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetImageExtent :: proc(image: ^Image, columns: c.size_t, rows: c.size_t, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetImageInfo :: proc(image_info: ^ImageInfo, frames: c.uint, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetImageMask :: proc(image: ^Image, type: PixelMask, mask: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetImageRegionMask :: proc(image: ^Image, type: PixelMask, region: ^RectangleInfo, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetImageStorageClass :: proc(image: ^Image, storage_class: ClassType, exception: ^ExceptionInfo) -> MagickBooleanType ---
    StripImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SyncImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SyncImageSettings :: proc(image_info: ^ImageInfo, image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SyncImagesSettings :: proc(image_info: ^ImageInfo, image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    
    InterpretImageFilename :: proc(image_info: ^ImageInfo, image: ^Image, format: cstring, value: c.int, filename: cstring, exception: ^ExceptionInfo) -> MagickBooleanType ---

    GetImageReferenceCount :: proc(image: ^Image) -> c.ssize_t ---

    GetImageVirtualPixelMethod :: proc(image: ^Image) -> VirtualPixelMethod ---
    SetImageVirtualPixelMethod :: proc(image: ^Image, virtual_pixel_method: VirtualPixelMethod, exception: ^ExceptionInfo) -> VirtualPixelMethod ---

    AcquireNextImage :: proc(image_info: ^ImageInfo, image: ^Image, exception: ^ExceptionInfo) ---
    DestroyImagePixels :: proc(image: ^Image) ---
    DisassociateImageStream :: proc(image: ^Image) ---
    GetImageInfo :: proc(image_info: ^ImageInfo) ---
    SetImageInfoBlob :: proc(image_info: ^ImageInfo, blob: rawptr, length: c.size_t) ---
    SetImageInfoFile :: proc(image_info: ^ImageInfo, file: ^c.FILE) ---
    SetImageInfoCustomStream :: proc(image_info: ^ImageInfo, custom_stream: ^CustomStreamInfo) ---

    // layer.h
    CoalesceImages :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^Image ---
    DisposeImages :: proc(image: ^Image, exception: ^Image) -> ^Image ---
    CompareImagesLayers :: proc(image: ^Image, method: LayerMethod, exception: ^ExceptionInfo) -> ^Image ---
    MergeImageLayers :: proc(image: ^Image, method: LayerMethod, exception: ^ExceptionInfo) -> ^Image ---
    OptimizeImageLayers :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^Image ---
    OptimizePlusImageLayers :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^Image ---

    CompositeLayers :: proc(destination: ^Image, compose: CompositeOperator, source: ^Image, x_offset: c.ssize_t, y_offset: c.ssize_t, exception: ^ExceptionInfo) ---
    OptimizeImageTransparency :: proc(image: ^Image, exception: ^ExceptionInfo) ---
    RemoveDuplicateLayers :: proc(image: ^^Image, exception: ^ExceptionInfo) ---
    RemoveZeroDelayLayers :: proc(image: ^^Image, exception: ^ExceptionInfo) ---

    // linked-list.h
    DestroyLinkedList :: proc(list_info: ^LinkedListInfo, relinquish_value : proc(rawptr)) -> ^LinkedListInfo ---
    NewLinkedList :: proc(capacity: c.size_t) -> ^LinkedListInfo ---

    AppendValueToLinkedList :: proc(list_info: ^LinkedListInfo, value: rawptr) -> MagickBooleanType ---
    InsertValueInLinkedList :: proc(list_info: ^LinkedListInfo, index: c.size_t, value: rawptr) -> MagickBooleanType ---
    InsertValueInSortedLinkedList :: proc(list_info: ^LinkedListInfo, compare: proc(rawptr, rawptr), replace: ^rawptr, value: rawptr) -> MagickBooleanType ---
    IsLinkedListEmpty :: proc(list_info: ^LinkedListInfo) -> MagickBooleanType ---
    LinkedListToArray :: proc(list_info: ^LinkedListInfo, array: ^rawptr) -> MagickBooleanType ---

    GetNumberOfElementsInLinkedList :: proc(list_info: ^LinkedListInfo) -> c.size_t ---

    ClearLinkedList :: proc(list_info: ^LinkedListInfo, relinquish_value: proc(rawptr)) ---
    GetLastValueInLinkedList :: proc(list_info: ^LinkedListInfo) -> rawptr ---
    GetNextValueInLinkedList :: proc(list_info: ^LinkedListInfo) -> rawptr ---
    GetValueFromLinkedList :: proc(list_info: ^LinkedListInfo, index: c.size_t) -> rawptr ---
    RemoveElementByValueFromLinkedList :: proc(list_info: ^LinkedListInfo, value: rawptr) -> rawptr ---
    RemoveElementFromLinkedList :: proc(list_info: ^LinkedListInfo, index: c.size_t) -> rawptr ---
    RemoveLastElementFromLinkedList :: proc(list_info: ^LinkedListInfo) -> rawptr ---
    ResetLinkedListIterator :: proc(list_info: ^LinkedListInfo) ---

    // list.h
    CloneImageList :: proc(images: ^Image, exception: ^ExceptionInfo) -> ^Image ---
    CloneImages :: proc(images: ^Image, scenes: cstring, exception: ^ExceptionInfo) -> ^Image ---
    DestroyImageList :: proc(images: ^Image) -> ^Image ---
    DuplicateImages :: proc(images: ^Image, number_duplicates: c.size_t, scenes: cstring, exception: ^ExceptionInfo) -> ^Image ---
    GetFirstImageInList :: proc(images: ^Image) -> ^Image ---
    GetImageFromList :: proc(images: ^Image, index: c.ssize_t) -> ^Image ---
    GetLastImageInList :: proc(images: ^Image) -> ^Image ---
    GetNextImageInList :: proc(images: ^Image) -> ^Image ---
    GetPreviousImageInList :: proc(images: ^Image) -> ^Image ---
    ImageListToArray :: proc(images: ^Image, exception: ^ExceptionInfo) -> ^^Image ---
    NewImageList :: proc() -> ^Image ---
    RemoveImageFromList :: proc(images: ^^Image) -> ^Image ---
    RemoveLastImageFromList :: proc(images: ^^Image) -> ^Image ---
    RemoveFirstImageFromList :: proc(images: ^^Image) -> ^Image ---
    SpliceImageIntoList :: proc(images: ^^Image, length: c.size_t, splice: ^Image) -> ^Image ---
    SplitImageList :: proc(images: ^Image) -> ^Image ---
    SyncNextImageList :: proc(images: ^Image) -> ^Image ---

    GetImageListLength :: proc(images: ^Image) -> c.size_t ---

    GetImageIndexInList :: proc(images: ^Image) -> c.ssize_t ---

    AppendImageToList :: proc(images: ^^Image, append: ^Image) ---
    DeleteImageFromList :: proc(images: ^^Image) ---
    DeleteImages :: proc(images: ^^Image, scenes: cstring, exception: ^ExceptionInfo) ---
    InsertImageInList :: proc(images: ^^Image, insert: ^Image) ---
    PrependImageToList :: proc(images: ^^Image, insert: ^Image) ---
    ReplaceImageInList :: proc(images: ^^Image, insert: ^Image) ---
    ReplaceImageInListReturnLast :: proc(images: ^^Image, insert: ^Image) ---
    ReverseImageList :: proc(images: ^^Image) ---
    SyncImageList :: proc(image: ^Image) ---

    // log.h
    GetLogList :: proc(pattern: cstring, number_preferences: c.size_t, exception: ExceptionInfo) -> [^]cstring ---

    GetLogName :: proc() -> cstring ---
    SetLogName :: proc(name: cstring) -> cstring ---

    GetLogEventMask :: proc(name: cstring) -> cstring ---

    GetLogInfoList :: proc(pattern: cstring, number_preferences: ^c.size_t, exception: ^ExceptionInfo) -> [^]^LogInfo ---

    SetLogEventMask :: proc(mask: cstring) -> LogEventType ---

    IsEventLogging :: proc() -> MagickBooleanType ---
    ListLogInfo :: proc(file: ^c.FILE, exception: ^ExceptionInfo) -> MagickBooleanType ---
    LogMagickEvent :: proc(type: LogEventType, module: cstring, function: cstring, line: c.size_t, format: cstring, #c_vararg args: ..any) -> MagickBooleanType ---
    LogMagickEventList :: proc(type: LogEventType, module: cstring, function: cstring, line: c.size_t, format: cstring, operands: c.va_list) -> MagickBooleanType ---

    CloseMagickLog :: proc() ---
    SetLogFormat :: proc(format: cstring) ---
    SetLogMethod :: proc(method: MagickLogMethod) ---
 
    // magic.h
    GetMagicList :: proc(pattern: cstring, number_aliases: ^c.size_t, exception: ^ExceptionInfo) -> [^]cstring ---

    GetMagicName :: proc(magic_info: ^MagickInfo) -> cstring ---

    ListMagicInfo :: proc(file: ^c.FILE, exception: ^ExceptionInfo) -> MagickBooleanType ---

    GetMagicInfo :: proc(magic: string, length: c.size_t, exception: ^ExceptionInfo) -> ^MagickInfo ---
    GetMagicInfoList :: proc(pattern: cstring, number_aliases: ^c.size_t, exception: ^ExceptionInfo) -> [^]^MagickInfo ---

    GetMagicPatternExtent :: proc(exception: ^ExceptionInfo) -> c.size_t ---

    // matrix.h
    AcquireMagickMatrix :: proc(number_rows: c.size_t, size: c.size_t) -> [^]^c.double ---
    RelinquishMagickMatrix :: proc(mat: [^]^c.double, number_rows: c.size_t) -> [^]^c.double ---

    MatrixToImage :: proc(matrix_info: ^MatrixInfo, exception: ^ExceptionInfo) -> ^Image ---

    GetMatrixElement :: proc(matrix_info: ^MatrixInfo, x: c.ssize_t, y: c.ssize_t, value: rawptr) -> MagickBooleanType ---
    NullMatrix :: proc(matrix_info: ^MatrixInfo) -> MagickBooleanType ---
    SetMatrixElement :: proc(matrix_info: ^MatrixInfo, x: c.ssize_t, y: c.ssize_t, value: rawptr) -> MagickBooleanType ---

    AcquireMatrixInfo :: proc(columns: c.size_t, rows: c.size_t, stride: c.size_t, exception: ^ExceptionInfo) -> ^MatrixInfo ---
    DestroyMatrixInfo :: proc(matrix_info: ^MatrixInfo) -> ^MatrixInfo ---

    GetMatrixColumns :: proc(matrix_info: ^MatrixInfo) -> c.size_t ---
    GetMatrixRows :: proc(matrix_info: ^MatrixInfo) -> c.size_t ---

    // montage.h 
    MontageImages :: proc(images: ^Image, montage_info: ^MontageInfo, exception: ^ExceptionInfo) -> ^Image ---
    MontageImageList :: proc(image_info: ^ImageInfo, montage_info: ^MontageInfo, images: ^Image, exception: ^ExceptionInfo) -> ^Image ---

    CloneMontageInfo :: proc(image_info: ^ImageInfo, montage_info: ^MontageInfo) -> ^MontageInfo ---
    DestroyMontageInfo :: proc(montage_info: ^MontageInfo) -> ^MontageInfo ---

    GetMontageInfo :: proc(image_info: ^ImageInfo, montage_info: ^MontageInfo) ---

    // morphology.h
    AcquireKernelInfo :: proc(kernel_string: cstring, exception: ^ExceptionInfo) -> ^KernelInfo ---
    AcquireKernelBuiltIn :: proc(type: KernelInfoType, args: ^GeometryInfo, exception: ^ExceptionInfo) -> ^KernelInfo ---
    CloneKernelInfo :: proc(kernel_info: ^KernelInfo) -> ^KernelInfo ---
    DestroyKernelInfo :: proc(kernel_info: ^KernelInfo) -> ^KernelInfo ---

    MorphologyImage :: proc(image: ^Image, method: MorphologyMethod, iterations: c.ssize_t, kernel: ^KernelInfo, exception: ^ExceptionInfo) -> ^Image ---

    ScaleGeometryKernelInfo :: proc(kernel: ^KernelInfo, geometry: cstring) ---
    ScaleKernelInfo :: proc(kernel: ^KernelInfo, scaling_factor: c.double, normalize_flags: GeometryFlags) ---
    UnityAddKernelInfo :: proc(kernel: ^KernelInfo, scale: c.double) ---

    // paint.h
    OilPaintImage :: proc(image: ^Image, radius: c.double, sigma: c.double, exception: ^ExceptionInfo) -> ^ImageInfo ---

    FloodfillPaintImage :: proc(image: ^Image, draw_info: ^DrawInfo, target: ^PixelInfo, c_offset: c.ssize_t, y_offset: c.ssize_t, invert: MagickBooleanType, exception: ^ExceptionInfo) -> MagickBooleanType ---
    GradientImage :: proc(image: ^Image, type: GradientType, method: SpreadMethod, spots: ^StopInfo, number_stops: c.size_t, exception: ^ExceptionInfo) -> MagickBooleanType ---
    OpaquePaintImage :: proc(image: ^Image, target: ^PixelInfo, fill: ^PixelInfo, invert: MagickBooleanType, exception: ^ExceptionInfo) -> MagickBooleanType ---
    TransparentPaintImage :: proc(image: ^Image, target: ^PixelInfo, opacity: Quantum, invert: MagickBooleanType, exception: ^ExceptionInfo) -> MagickBooleanType ---
    TransparentPainImageChroma :: proc(image: ^Image, low: ^PixelInfo, high: ^PixelInfo, opacity: Quantum, invert: MagickBooleanType, exception: ^ExceptionInfo) -> MagickBooleanType ---

    // pixel.h
    SetPixelChannelMask :: proc(image: ^Image, channel_mask: ChannelType) -> ChannelType ---

    ExportImagePixels :: proc(image: ^Image, x: c.ssize_t, y: c.ssize_t, width: c.size_t, height: c.size_t, map_: cstring, type: StorageType, pixels: rawptr, exception: ^ExceptionInfo) -> MagickBooleanType ---
    ImportImagePixels :: proc(image: ^Image, x: c.ssize_t, y: c.ssize_t, width: c.size_t, height: c.size_t, map_: cstring, type: StorageType, pixels: rawptr, exception: ^ExceptionInfo) -> MagickBooleanType ---
    InterpolatePixelChannel :: proc(image: ^Image, image_view: ^CacheView, channel: PixelChannel, method: PixelInterpolateMethod, x: c.double, y: c.double, pixel: ^c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    InterpolatePixelChannels :: proc(source: ^Image, source_view: ^CacheView, destination: ^Image, method: PixelInterpolateMethod, x: c.double, y: c.double, pixel: ^Quantum, exception: ^ExceptionInfo) -> MagickBooleanType ---
    InterpolatePixelInfo :: proc(image: ^Image, image_view: ^CacheView, method: PixelInterpolateMethod, x: c.double, y: c.double, pixel: ^PixelInfo, exception: ^ExceptionInfo) -> MagickBooleanType ---
    IsFuzzyEquivalencePixel :: proc(image: ^Image, p: ^Quantum, target_image: ^Image, q: ^Quantum) -> MagickBooleanType ---
    IsFuzzyEquivalencePixelInfo :: proc(p: ^PixelInfo, q: ^PixelInfo) -> MagickBooleanType ---
    SetPixelMetaChannels :: proc(image: ^Image, number_meta_channels: c.size_t, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SortImagePixels :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---

    GetPixelInfoIntensity :: proc(image: ^Image, pixel: ^PixelInfo) -> MagickRealType ---
    GetPixelIntensity :: proc(image: ^Image, pixel: ^Quantum) -> MagickRealType ---

    AcquirePixelChannelMap :: proc() -> ^PixelChannelMap ---
    ClonePixelChannelMap :: proc(channel_map: ^PixelChannelMap) -> ^PixelChannelMap ---
    DestroyPixelChannelMap :: proc(channel_map: ^PixelChannelMap) -> ^PixelChannelMap ---

    ClonePixelInfo :: proc(pixel: ^PixelInfo) -> ^PixelInfo ---

    DecodePixelGamma :: proc(x: MagickRealType) -> MagickRealType ---
    EncodePixelGamma :: proc(x: MagickRealType) -> MagickRealType ---

    ConformPixelInfo :: proc(image: ^Image, source: ^PixelInfo, destination: ^PixelInfo, exception: ^ExceptionInfo) ---
    GetPixelInfo :: proc(image: ^Image, pixel: ^PixelInfo) ---

    // prepress.h
    GetImageTotalInkDensity :: proc(image: ^Image, exception: ^ExceptionInfo) -> c.double ---

    // profile.h
    GetNextImageProfile :: proc(image: ^Image) -> cstring ---

    GetImageProfile :: proc(image: ^Image, name: cstring) -> ^StringInfo ---

    CloneImageProfiles :: proc(image: ^Image, clone_image: ^Image) -> MagickBooleanType ---
    DeleteImageProfile :: proc(image: ^Image, name: cstring) -> MagickBooleanType ---
    ProfileImage :: proc(image: ^Image, name: cstring, datum: rawptr, length: c.size_t, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetImageProfile :: proc(image: ^Image, name: cstring, profile: ^StringInfo, exception: ^ExceptionInfo) -> MagickBooleanType ---

    RemoveImageProfile :: proc(image: ^Image, name: cstring) -> ^StringInfo ---

    DestroyImageProfiles :: proc(image: ^Image) ---
    ResetImageProfileIterator :: proc(image: ^Image) ---

    // quantize.h
    CompressImageColormap :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    GetImageQuantizeError :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    KmeansImage :: proc(image: ^Image, number_colors: c.size_t, max_iterations: c.size_t, tolerance: c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    PosterizeImage :: proc(image: ^Image, levels: c.size_t, dither_method: DitherMethod, exception: ^ExceptionInfo) -> MagickBooleanType ---
    QuantizeImage :: proc(quantize_info: ^QuantizeInfo, image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    QuantizeImages :: proc(quantize_info: ^QuantizeInfo, images: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    RemapImage :: proc(quantize_info: ^QuantizeInfo, image: ^Image, remap_image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    RemapImages :: proc(quantize_info: ^QuantizeInfo, images: ^Image, remap_image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---
    
    AcquireQuantizeInfo :: proc(image_info: ^ImageInfo) -> ^QuantizeInfo ---
    CloneQuantizeInfo :: proc(image_info: ^ImageInfo) -> ^QuantizeInfo ---
    DestroyQuantizeInfo :: proc(image_info: ^ImageInfo) -> ^QuantizeInfo ---

    GetQuantizeInfo :: proc(quantize_info: ^QuantizeInfo) ---

    // random.h
    GetRandomValue :: proc(random_info: ^RandomInfo) -> c.double ---
    GetPseudoRandomValue :: proc(random_info: ^RandomInfo) -> c.double ---

    AcquireRandomInfo :: proc() -> ^RandomInfo ---
    DestroyRandomInfo :: proc(random_info: ^RandomInfo) -> ^RandomInfo ---

    GetRandomKey :: proc(random_info: ^RandomInfo) -> ^StringInfo ---

    SetRandomKey :: proc(random_info: ^RandomInfo, length: c.size_t, key: cstring) ---
    SetRandomSecretKey :: proc(key: c.ulong) ---
    SetRandomTrueRandom :: proc(true_random: MagickBooleanType) ---

    // resample.h
    ResamplePixelColor :: proc(resample_filter: ^ResampleFilter, u0: c.double, v0: c.double, pixel: ^PixelInfo, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetResampleFilterInterpolateMethod :: proc(resample_filter: ^ResampleFilter, method: PixelInterpolateMethod) -> MagickBooleanType ---
    SetResampleFilterVirtualPixelMethod :: proc(resample_filter: ^ResampleFilter, method: VirtualPixelMethod) -> MagickBooleanType ---

    AcquireResampleFilter :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^ResampleFilter ---
    DestroyResampleFilter :: proc(resample_filter: ^ResampleFilter) -> ^ResampleFilter ---

    ScaleResampleFilter :: proc(resample_filter: ^ResampleFilter, dux: c.double, duy: c.double, dvx: c.double, dvy: c.double) ---
    SetResampleFIlter :: proc(resample_filter: ^ResampleFilter, filter: FilterType) ---

    // resize.h
    AdaptiveResizeImage :: proc(image: ^Image, columns: c.size_t, rows: c.size_t, exception: ^ExceptionInfo) -> ^Image ---
    InterpolativeResizeImage :: proc(image: ^Image, columns: c.size_t, rows: c.size_t, method: PixelInterpolateMethod, exception: ^ExceptionInfo) -> ^Image ---
    LiquidRescaleImage :: proc(image: ^Image, columns: c.size_t, rows: c.size_t, delta_x: c.double, delta_y: c.double, rigidity: c.double, exception: ^ExceptionInfo) -> ^Image ---
    MagnifyImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^Image ---
    MinifyImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^Image ---
    ResampleImage :: proc(image: ^Image, x_resolution: c.double, y_resolution: c.double, filter: FilterType, exception: ^ExceptionInfo) -> ^Image ---
    ResizeImage :: proc(image: ^Image, columns: c.size_t, rows: c.size_t, filter: FilterType, exception: ^ExceptionInfo) -> ^Image ---
    SampleImage :: proc(image: ^Image, columns: c.size_t, rows: c.size_t, exception: ^ExceptionInfo) -> ^Image ---
    ScaleImage :: proc(image: ^Image, columns: c.size_t, rows: c.size_t, exception: ^ExceptionInfo) -> ^Image ---
    ThumbnailImage :: proc(image: ^Image, columns: c.size_t, rows: c.size_t, exception: ^ExceptionInfo) -> ^Image ---

    // segment.h
    GetImageDynamicThreshold :: proc(image: ^Image, cluster_threshold: c.double, smooth_threshold: c.double, pixel: ^PixelInfo, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SegmentImage :: proc(image: ^Image, colorspace: ColorspaceType, verbose: MagickBooleanType, cluster_threshold: c.double, smooth_threshold: c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---

    // semaphore.h
    AcquireSemaphoreInfo :: proc() -> ^SemaphoreInfo ---
    ActivateSemaphoreInfo :: proc(semaphore_info: ^SemaphoreInfo) ---
    LockSemaphoreInfo :: proc(semaphore_info: ^SemaphoreInfo) ---
    RelinquishSemaphoreInfo :: proc(semaphore_info: ^^SemaphoreInfo) ---
    UnlockSemaphoreInfo :: proc(semaphore_info: ^SemaphoreInfo) ---

    // shear.h
    DeskewImage :: proc(image: ^Image, threshold: c.double, exception: ^ExceptionInfo) -> ^Image ---
    IntegralRotateImage :: proc(image: ^Image, rotations: c.size_t, exception: ^ExceptionInfo) -> ^Image ---
    ShearImage :: proc(image: ^Image, x_shear: c.double, y_shear: c.double, exception: ^ExceptionInfo) -> ^Image ---
    ShearRotateImage :: proc(image: ^Image, degrees: c.double, exception: ^ExceptionInfo) -> ^Image ---

    // signature.h
    SignatureImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> MagickBooleanType ---

    // statistic.h
    GetImageStatistics :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^ChannelStatistics ---

    GetImageMoments :: proc(iamge: ^Image, exception: ^ExceptionInfo) -> ^ChannelMoments ---

    GetImagePerceptualHash :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^ChannelPerceptualHash ---

    EvaluateImages :: proc(image: ^Image, op: MagickEvaluateOperator, exception: ^ExceptionInfo) -> ^Image ---
    PolynomialImage :: proc(image: ^Image, number_terms: c.size_t, terms: ^c.double, exceptions: ^ExceptionInfo) -> ^Image ---
    StatisticImage :: proc(image: ^Image, type: StatisticType, width: c.size_t, height: c.size_t, exception: ^ExceptionInfo) -> ^Image ---

    EvaluateImage :: proc(image: ^Image, op: MagickEvaluateOperator, value: c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    FunctionImage :: proc(image: ^Image, function: MagickFunction, number_parameters: c.size_t, parameters: ^c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    GetImageEntropy :: proc(image: ^Image, entropy: ^c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    GetImageExtreme :: proc(image: ^Image, minima: ^c.size_t, maxima: c.size_t, exception: ^ExceptionInfo) -> MagickBooleanType ---
    GetImageMean :: proc(image: ^Image, mean: ^c.double, standard_deviation: ^c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    GetImageMedian :: proc(image: ^Image, median: ^c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    GetImageKurtosis :: proc(image: ^Image, kurtosis: ^c.double, skewness: ^c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---
    GetImageRange :: proc(image: ^Image, minima: ^c.double, maxima: ^c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---

    // stream.h
    ReadStream :: proc(image_info: ^ImageInfo, stream: StreamHandler, exception: ^ExceptionInfo) -> ^Image ---
    StreamImage :: proc(image_info: ^ImageInfo, stream_info: ^StreamInfo, exception: ^ExceptionInfo) -> ^Image ---

    OpenStream :: proc(image_info: ^ImageInfo, stream_info: ^StreamInfo, filename: cstring, exception: ^ExceptionInfo) -> MagickBooleanType ---
    WriteStream :: proc(iamge_info: ^ImageInfo, image: ^Image, stream: StreamHandler, exception: ^ExceptionInfo) -> ^MagickBooleanType ---

    AcquireStreamInfo :: proc(image_info: ^ImageInfo, exception: ^ExceptionInfo) -> ^StreamInfo ---
    DestroyStreamInfo :: proc(stream_info: ^StreamInfo) -> ^StreamInfo ---

    SetStreamInfoMap :: proc(stream_info: ^StreamInfo, map_: cstring) ---
    SetStreamInfoStorageType :: proc(stream_info: ^StreamInfo, storage_type: StorageType) ---

    // transform.h
    AutoOrientImage :: proc(image: ^Image, orientation: OrientationType, exception: ^ExceptionInfo) -> ^Image ---
    ChopImage :: proc(image: ^Image, chop_info: ^RectangleInfo, exception: ^ExceptionInfo) -> ^Image ---
    ConsolidateCMYKImages :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^Image ---
    CropImage :: proc(image: ^Image, geometry: ^RectangleInfo, exception: ^ExceptionInfo) -> ^Image ---
    CropImageToTiles :: proc(image: ^Image, crop_geometry: cstring, exception: ^ExceptionInfo) -> ^Image ---
    ExcerptImage :: proc(image: ^Image, geometry: ^RectangleInfo, exception: ^ExceptionInfo) -> ^Image ---
    ExtentImage :: proc(image: ^Image, geometry: ^RectangleInfo, exception: ^ExceptionInfo) -> ^Image ---
    FlipImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^Image ---
    FlopImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^Image ---
    RollImage :: proc(image: ^Image, x_offset: c.ssize_t, y_offset: c.ssize_t, exception: ^ExceptionInfo) -> ^Image ---
    ShaveImage :: proc(image: ^Image, shave_info: ^RectangleInfo, exception: ^ExceptionInfo) -> ^Image ---
    SpliceImage :: proc(image: ^Image, geometry: ^RectangleInfo, exception: ^ExceptionInfo) -> ^Image ---
    TransposeImage :: proc(image: ^Image, exception: ^Image) -> ^Image ---
    TransverseImage :: proc(image: ^Image, exception: ^Image) -> ^Image ---
    TrimImage :: proc(image: ^Image, exception: ^Image) -> ^Image ---

    // type.h
    GetTypeList :: proc(pattern: cstring, number_fonts: ^c.size_t, exception: ^ExceptionInfo) -> [^]cstring ---

    ListTypeInfo :: proc(file: ^c.FILE, exception: ^ExceptionInfo) -> MagickBooleanType ---

    GetTypeInfo :: proc(name: cstring, exception: ^ExceptionInfo) -> ^TypeInfo ---
    GetTypeInfoByFamily :: proc(family: cstring, style: StyleType, stretch: StretchType, weight: c.size_t, exception: ^ExceptionInfo) -> ^TypeInfo ---
    GetTypeInfoList :: proc(pattern: cstring, number_fonts: ^c.size_t, exception: ^ExceptionInfo) -> ^TypeInfo ---

    // vision.h
    ConnectedComponentsImage :: proc(image: ^Image, connectivity: c.size_t, objects: [^]^CCObjectInfo, exception: ^ExceptionInfo) -> ^Image ---
    IntegralImage :: proc(image: ^Image, exception: ^ExceptionInfo) -> ^Image ---

    // visual-effects.h
    AddNoiseImage :: proc(image: ^Image, noise_type: NoiseType, attenuate: c.double, exception: ^ExceptionInfo) -> ^Image ---
    BlueShiftImage :: proc(image: ^Image, factor: c.double, exception: ^ExceptionInfo) -> ^Image ---
    CharcoalImage :: proc(image: ^Image, radius: c.double, sigma: c.double, exception: ^ExceptionInfo) -> ^Image ---
    ColorizeImage :: proc(image: ^Image, blend: cstring, colorize: ^PixelInfo, exception: ^ExceptionInfo) -> ^Image ---
    ColorMatrixImage :: proc(image: ^Image, color_matrix: ^KernelInfo, exception: ^ExceptionInfo) -> ^Image ---
    ImplodeImage :: proc(image: ^Image, amount: c.double, method: PixelInterpolateMethod, exception: ^ExceptionInfo) -> ^Image ---
    MorphImage :: proc(image: ^Image, number_frames: c.size_t, exception: ^ExceptionInfo) -> ^Image ---
    PolaroidImage :: proc(image: ^Image, draw_info: ^DrawInfo, caption: cstring, angle: c.double, method: PixelInterpolateMethod, exception: ^ExceptionInfo) -> ^Image ---
    SepiaToneImage :: proc(image: ^Image, threshold: c.double, exception: ^ExceptionInfo) -> ^Image ---
    ShadowImage :: proc(image: ^Image, alpha: c.double, sigma: c.double, c_offset: c.ssize_t, y_offset: c.ssize_t, exception: ^ExceptionInfo) -> ^Image ---
    SketchImage :: proc(image: ^Image, radius: c.double, sigma: c.double, angle: c.double, exception: ^ExceptionInfo) -> ^Image ---
    SteganoImage :: proc(image: ^Image, watermark: ^Image, exception: ^ExceptionInfo) -> ^Image ---
    StereoImage :: proc(left_image: ^Image, right_image: ^Image, c_offset: c.ssize_t, y_offset: c.ssize_t, exception: ^ExceptionInfo) -> ^Image ---
    StereoAnaglyphImage :: proc(left_image: ^Image, right_image: ^Image , x_offset: c.ssize_t, y_offset: c.ssize_t, exception: ^ExceptionInfo) -> ^Image ---
    SwirlImage :: proc(image: ^Image, degrees: c.double, method: PixelInterpolateMethod, exception: ^ExceptionInfo) -> ^Image ---
    TintImage :: proc(image: ^Image, blend: cstring, tint: ^PixelInfo, exception: ^ExceptionInfo) -> ^Image ---
    VignetteImage :: proc(image: ^Image, radius: c.double, sigma: c.double, x: c.ssize_t, y: c.ssize_t, exception: ^ExceptionInfo) -> ^Image ---
    WaveImage :: proc(image: ^Image, aplitude: c.double, wave_length: c.double, method: PixelInterpolateMethod, exception: ^ExceptionInfo) -> ^Image ---
    WaveletDenoiseImage :: proc(image: ^Image, threshold: c.double, softness: c.double, exception: ^ExceptionInfo) -> ^Image ---

    PlasmaImage :: proc(image: ^Image, segment: ^SegmentInfo, attenuate: c.size_t, depth: c.size_t, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SolarizeImage :: proc(image: ^Image, threshold: c.double, exception: ^ExceptionInfo) -> MagickBooleanType ---


    // exception.h
    GetExceptionMessage :: proc(error: c.int) -> cstring ---
    GetLocaleExceptionMessage :: proc(severity: ExceptionType, tag: cstring) -> cstring ---

    SetErrorHandler :: proc(handler: ErrorHandler) -> ErrorHandler ---

    AcquireExceptionInfo :: proc() -> ^ExceptionInfo ---
    CloneExceptionInfo :: proc(exception: ^ExceptionInfo) ---
    DestroyExceptionInfo :: proc(exception: ^ExceptionInfo) ---

    ThrowException :: proc(exception: ^ExceptionInfo, severity: ExceptionType, reason: cstring, description: cstring) -> MagickBooleanType ---
    ThrowMagickExceptionList :: proc(exception: ^ExceptionInfo, module: cstring, function: cstring, line: c.size_t, severity: ExceptionType, tag: cstring, format: cstring, operands: c.va_list) -> MagickBooleanType --- 
    // TODO: bind ThrowMagickException

    CatchException :: proc(exception: ^ExceptionInfo) ---
    ClearMagickException :: proc(exception: ^ExceptionInfo) ---
    InheritException :: proc(exception: ^ExceptionInfo, relative: ^ExceptionInfo) ---
    MagickError :: proc(error: ExceptionType, reason: cstring, description: cstring) ---
    MagickFatalError :: proc(error: ExceptionType, reason: cstring, description: cstring) ---
    MagickWarning :: proc(error: ExceptionType, reason: cstring, description: cstring) ---

    // option.h
    GetCommandOptions :: proc(option: CommandOption) -> [^]cstring ---
    GetNextImageOption :: proc(image_info: ^ImageInfo) -> cstring ---
    RemoveImageOption :: proc(image_info: ^ImageInfo, option: cstring) -> cstring ---

    CommandOptionToMnemonic :: proc(option: CommandOption, type: c.ssize_t) -> cstring ---
    GetImageOption :: proc(image_info: ^ImageInfo, option: cstring) -> cstring ---

    CloneImageOptions :: proc(image_info: ^ImageInfo, clone_info: ^ImageInfo) -> MagickBooleanType ---
    DefineImageOption :: proc(image_info: ^ImageInfo, option: cstring) -> MagickBooleanType ---
    DeleteImageOption :: proc(image_info: ^ImageInfo, option: cstring) -> MagickBooleanType ---
    IsCommandOption :: proc(option: cstring) -> MagickBooleanType ---
    IsOptionMember :: proc(option: cstring, options: cstring) -> MagickBooleanType ---
    ListCommandOptions :: proc(file: ^c.FILE, option: CommandOption, exception: ^ExceptionInfo) -> MagickBooleanType ---
    SetImageOption :: proc(image_info: ^ImageInfo, option: cstring, value: cstring) -> MagickBooleanType ---

    GetCommandOptionFlags :: proc(option: CommandOption, list: MagickBooleanType, options: cstring) -> c.ssize_t ---
    ParseChannelOption :: proc(option: cstring) -> c.ssize_t ---
    ParsePixelChannelOption :: proc(option: cstring) -> c.ssize_t ---
    ParseCommandOption :: proc(option: CommandOption, list: MagickBooleanType, options: cstring) -> c.ssize_t ---

    DestroyImageOptions :: proc(image_info: ^ImageInfo) ---
    ResetImageOptions :: proc(image_info: ^ImageInfo) ---
    ResetImageOptionIterator :: proc(image_info: ^ImageInfo) ---

    GetCommandOptionInfo :: proc(option: cstring) -> ^OptionInfo ---



    // property.h
    InterpretImageProperties :: proc(image_info: ^ImageInfo, image: ^Image, embed_text: cstring, exception: ^ExceptionInfo) -> cstring ---
    RemoveImageProperty :: proc(image: ^Image, property: cstring) -> cstring --- 

    GetNextImageProperty :: proc(image: ^Image) -> cstring ---
    GetImageProperty :: proc(image: ^Image, property: cstring, exception: ^ExceptionInfo) -> cstring ---
    GetMagickProperty :: proc(image_info: ^ImageInfo, image: ^Image, property: cstring, exception: ^ExceptionInfo) -> cstring ---

    CloneImageProperties :: proc(image: ^Image, clone_image: ^Image) -> MagickBooleanType ---
    DefineImageProperty :: proc(image: ^Image, property: cstring, exception: ^ExceptionInfo) -> MagickBooleanType ---
    DeleteImageProperty :: proc(image: ^Image, property: cstring) -> MagickBooleanType ---
    // TODO: bind FormatImageProperty(Image *,const char *,const char *,...)
    SetImageProperty :: proc(image: ^Image, property: cstring, value: cstring, exception: ^ExceptionInfo) -> MagickBooleanType ---

    DestroyImageProperties :: proc(image: ^Image) ---
    ResetImagePropertyIterator :: proc(image: ^Image) ---
}