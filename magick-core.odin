package odin_magick

import "core:c"

/* 
    TODO LIST:
    blob.h
    cache.h
    cipher.h
    compress.h

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
    ParseChannelOption :: proc(channels: cstring) -> c.ssize_t --- 

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