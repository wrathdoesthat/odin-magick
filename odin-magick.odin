package odinmagick

import "core:c"

when ODIN_OS == .Windows {
	foreign import lib {"./lib/CORE_RL_MagickCore_.lib", "./lib/CORE_RL_MagickWand_.lib"}
} else {
	#assert(false, "Unsupported odin-magick OS")
}

// MagickWand/method-attribute.h
MagickPathExtent : c.int : 4096

// MagickCore/Magick-type.h
ClassType :: enum c.int {
	UndefinedClass,
	DirectClass,
	PseudoClass,
}

MagickBooleanType :: enum c.int {
	MagickFalse = 0,
	MagickTrue  = 1,
}

MagickOffsetType :: c.longlong
MagickSizeType   :: c.ulonglong
MagickDoubleType :: c.double
MagickRealType   :: MagickDoubleType

// MagickCore/pixel.h
MaxPixelChannels :: 64

// Note: If the library was compiled with MAGICKCORE_64BIT_CHANNEL_MASK_SUPPORT off this would be an enum of c.int
ChannelType :: enum c.longlong {
    UndefinedChannel = 0x0000,
    RedChannel = 0x0001,
    GrayChannel = 0x0001,
    CyanChannel = 0x0001,
    LChannel = 0x0001,
    GreenChannel = 0x0002,
    MagentaChannel = 0x0002,
    aChannel = 0x0002,
    BlueChannel = 0x0004,
    bChannel = 0x0002,
    YellowChannel = 0x0004,
    BlackChannel = 0x0008,
    AlphaChannel = 0x0010,
    OpacityChannel = 0x0010,
    IndexChannel = 0x0020,             /* Color Index Table? */
    ReadMaskChannel = 0x0040,          /* Pixel is Not Readable? */
    WriteMaskChannel = 0x0080,         /* Pixel is Write Protected? */
    MetaChannel = 0x0100,              /* not used */
    CompositeMaskChannel = 0x0200,     /* SVG mask */
    CompositeChannels = 0x001F,

    // TODO: support for the non 64bit channel build?
    //#if defined(MAGICKCORE_64BIT_CHANNEL_MASK_SUPPORT)
    AllChannels = 0x7FFFFFFFFFFFFFFF,
    //#else
    //AllChannels = 0X7FFFFFF,
    //#endif

    /*

    Special purpose channel types.
    FUTURE: are these needed any more - they are more like hacks
    SyncChannels for example is NOT a real channel but a 'flag'
    It really says -- "User has not defined channels"
    Though it does have extra meaning in the "-auto-level" operator

    */
    TrueAlphaChannel = 0x0100, /* extract actual alpha channel from opacity */
    RGBChannels = 0x0200,      /* set alpha from grayscale mask in RGB */
    GrayChannels = 0x0400,
    SyncChannels = 0x20000,    /* channels modified as a single unit */
    DefaultChannels = AllChannels
}

PixelChannel :: enum c.int {
    UndefinedPixelChannel = 0,
    RedPixelChannel = 0,
    CyanPixelChannel = 0,
    GrayPixelChannel = 0,
    LPixelChannel = 0,
    LabelPixelChannel = 0,
    YPixelChannel = 0,
    aPixelChannel = 1,
    GreenPixelChannel = 1,
    MagentaPixelChannel = 1,
    CbPixelChannel = 1,
    bPixelChannel = 2,
    BluePixelChannel = 2,
    YellowPixelChannel = 2,
    CrPixelChannel = 2,
    BlackPixelChannel = 3,
    AlphaPixelChannel = 4,
    IndexPixelChannel = 5,
    ReadMaskPixelChannel = 6,
    WriteMaskPixelChannel = 7,
    MetaPixelChannel = 8, /* deprecated */
    CompositeMaskPixelChannel = 9,
    MetaPixelChannels = 10,
    IntensityPixelChannel = MaxPixelChannels,  /* ???? */
    CompositePixelChannel = MaxPixelChannels,  /* ???? */
    SyncPixelChannel = MaxPixelChannels+1      /* not a real channel */
}

PixelIntensityMethod :: enum c.int {
    UndefinedPixelIntensityMethod = 0,
    AveragePixelIntensityMethod,
    BrightnessPixelIntensityMethod,
    LightnessPixelIntensityMethod,
    MSPixelIntensityMethod,
    Rec601LumaPixelIntensityMethod,
    Rec601LuminancePixelIntensityMethod,
    Rec709LumaPixelIntensityMethod,
    Rec709LuminancePixelIntensityMethod,
    RMSPixelIntensityMethod
}

PixelInterpolateMethod :: enum c.int {
    UndefinedInterpolatePixel,
    AverageInterpolatePixel,    /* Average 4 nearest neighbours */
    Average9InterpolatePixel,   /* Average 9 nearest neighbours */
    Average16InterpolatePixel,  /* Average 16 nearest neighbours */
    BackgroundInterpolatePixel, /* Just return background color */
    BilinearInterpolatePixel,   /* Triangular filter interpolation */
    BlendInterpolatePixel,      /* blend of nearest 1, 2 or 4 pixels */
    CatromInterpolatePixel,     /* Catmull-Rom interpolation */
    IntegerInterpolatePixel,    /* Integer (floor) interpolation */
    MeshInterpolatePixel,       /* Triangular Mesh interpolation */
    NearestInterpolatePixel,    /* Nearest Neighbour Only */
    SplineInterpolatePixel      /* Cubic Spline (blurred) interpolation */
}

PixelMask :: enum c.int {
    UndefinedPixelMask = 0x000000,
    ReadPixelMask = 0x000001,
    WritePixelMask = 0x000002,
    CompositePixelMask = 0x000004
}

PixelTrait :: enum c.int {
    UndefinedPixelTrait = 0x000000,
    CopyPixelTrait = 0x000001,
    UpdatePixelTrait = 0x000002,
    BlendPixelTrait = 0x000004
}

StorageType :: enum c.int {
    UndefinedPixel,
    CharPixel,
    DoublePixel,
    FloatPixel,
    LongPixel,
    LongLongPixel,
    QuantumPixel,
    ShortPixel
}

// MagickCore/timer.h
TimerState :: enum c.int {
    UndefinedTimerState,
    StoppedTimerState,
    RunningTimerState
}

Timer :: struct {
    start, stop, total : c.double
}

TimerInfo :: struct {
    user, elapsed: Timer,
    state : TimerState,
    signature : c.size_t
}

// MagickCore/resample.h
FilterType :: enum c.int {
    UndefinedFilter,
    PointFilter,
    BoxFilter,
    TriangleFilter,
    HermiteFilter,
    HannFilter,
    HammingFilter,
    BlackmanFilter,
    GaussianFilter,
    QuadraticFilter,
    CubicFilter,
    CatromFilter,
    MitchellFilter,
    JincFilter,
    SincFilter,
    SincFastFilter,
    KaiserFilter,
    WelchFilter,
    ParzenFilter,
    BohmanFilter,
    BartlettFilter,
    LagrangeFilter,
    LanczosFilter,
    LanczosSharpFilter,
    Lanczos2Filter,
    Lanczos2SharpFilter,
    RobidouxFilter,
    RobidouxSharpFilter,
    CosineFilter,
    SplineFilter,
    LanczosRadiusFilter,
    CubicSplineFilter,
    MagicKernelSharp2013Filter,
    MagicKernelSharp2021Filter,
    SentinelFilter  /* a count of all the filters, not a real filter */
}

// MagickCore/layer.h
DisposeType :: enum c.int {
    UnrecognizedDispose,
    UndefinedDispose = 0,
    NoneDispose = 1,
    BackgroundDispose = 2,
    PreviousDispose = 3
}

LayerMethod :: enum c.int {
    UndefinedLayer,
    CoalesceLayer,
    CompareAnyLayer,
    CompareClearLayer,
    CompareOverlayLayer,
    DisposeLayer,
    OptimizeLayer,
    OptimizeImageLayer,
    OptimizePlusLayer,
    OptimizeTransLayer,
    RemoveDupsLayer,
    RemoveZeroLayer,
    CompositeLayer,
    MergeLayer,
    FlattenLayer,
    MosaicLayer,
    TrimBoundsLayer
}

// MagickCore/quantum.h
EndianType :: enum c.int {
    UndefinedEndian,
    LSBEndian,
    MSBEndian
}

// MagickCore/compress.h
CompressionType :: enum c.int {
    UndefinedCompression,
    B44ACompression,
    B44Compression,
    BZipCompression,
    DXT1Compression,
    DXT3Compression,
    DXT5Compression,
    FaxCompression,
    Group4Compression,
    JBIG1Compression,        /* ISO/IEC std 11544 / ITU-T rec T.82 */
    JBIG2Compression,        /* ISO/IEC std 14492 / ITU-T rec T.88 */
    JPEG2000Compression,     /* ISO/IEC std 15444-1 */
    JPEGCompression,
    LosslessJPEGCompression,
    LZMACompression,         /* Lempel-Ziv-Markov chain algorithm */
    LZWCompression,
    NoCompression,
    PizCompression,
    Pxr24Compression,
    RLECompression,
    ZipCompression,
    ZipSCompression,
    ZstdCompression,
    WebPCompression,
    DWAACompression,
    DWABCompression,
    BC7Compression,
    BC5Compression,
    LERCCompression          /* https://github.com/Esri/lerc */
}

PixelChannelMap :: struct {
    channel : PixelChannel,
    traits  : PixelTrait,
    offset  : c.ssize_t
}

PixelInfo :: struct {
    storage_class : ClassType,
    colorspace : ColorspaceType,
    alpha_trait : PixelTrait,
    fuzz : c.double,
    depth : c.size_t,
    count : MagickSizeType,
    red, green, blue, black, alpha, index : MagickRealType
}

PixelPacket :: struct {
    red, green, blue, alpha, black : c.uint
}

// MagickCore/geometry.h
GravityType :: enum c.int {
    UndefinedGravity,
    ForgetGravity = 0,
    NorthWestGravity = 1,
    NorthGravity = 2,
    NorthEastGravity = 3,
    WestGravity = 4,
    CenterGravity = 5,
    EastGravity = 6,
    SouthWestGravity = 7,
    SouthGravity = 8,
    SouthEastGravity = 9
}

AffineMatrix :: struct {
    sx, rx, ry, sy, tx, ty : c.double
}

GeometryInfo :: struct {
    rho, sigma, xi, psi, chi : c.double
}

OffsetInfo :: struct {
    x, y : c.ssize_t
}

PointInfo :: struct {
    x, y : c.double
}

RectangleInfo :: struct {
    width, height : c.size_t,
    x, y : c.ssize_t
}

// MagickCore/composite.h
CompositeOperator :: enum c.int {
    UndefinedCompositeOp,
    AlphaCompositeOp,
    AtopCompositeOp,
    BlendCompositeOp,
    BlurCompositeOp,
    BumpmapCompositeOp,
    ChangeMaskCompositeOp,
    ClearCompositeOp,
    ColorBurnCompositeOp,
    ColorDodgeCompositeOp,
    ColorizeCompositeOp,
    CopyBlackCompositeOp,
    CopyBlueCompositeOp,
    CopyCompositeOp,
    CopyCyanCompositeOp,
    CopyGreenCompositeOp,
    CopyMagentaCompositeOp,
    CopyAlphaCompositeOp,
    CopyRedCompositeOp,
    CopyYellowCompositeOp,
    DarkenCompositeOp,
    DarkenIntensityCompositeOp,
    DifferenceCompositeOp,
    DisplaceCompositeOp,
    DissolveCompositeOp,
    DistortCompositeOp,
    DivideDstCompositeOp,
    DivideSrcCompositeOp,
    DstAtopCompositeOp,
    DstCompositeOp,
    DstInCompositeOp,
    DstOutCompositeOp,
    DstOverCompositeOp,
    ExclusionCompositeOp,
    HardLightCompositeOp,
    HardMixCompositeOp,
    HueCompositeOp,
    InCompositeOp,
    IntensityCompositeOp,
    LightenCompositeOp,
    LightenIntensityCompositeOp,
    LinearBurnCompositeOp,
    LinearDodgeCompositeOp,
    LinearLightCompositeOp,
    LuminizeCompositeOp,
    MathematicsCompositeOp,
    MinusDstCompositeOp,
    MinusSrcCompositeOp,
    ModulateCompositeOp,
    ModulusAddCompositeOp,
    ModulusSubtractCompositeOp,
    MultiplyCompositeOp,
    NoCompositeOp,
    OutCompositeOp,
    OverCompositeOp,
    OverlayCompositeOp,
    PegtopLightCompositeOp,
    PinLightCompositeOp,
    PlusCompositeOp,
    ReplaceCompositeOp,
    SaturateCompositeOp,
    ScreenCompositeOp,
    SoftLightCompositeOp,
    SrcAtopCompositeOp,
    SrcCompositeOp,
    SrcInCompositeOp,
    SrcOutCompositeOp,
    SrcOverCompositeOp,
    ThresholdCompositeOp,
    VividLightCompositeOp,
    XorCompositeOp,
    StereoCompositeOp,
    FreezeCompositeOp,
    InterpolateCompositeOp,
    NegateCompositeOp,
    ReflectCompositeOp,
    SoftBurnCompositeOp,
    SoftDodgeCompositeOp,
    StampCompositeOp,
    RMSECompositeOp,
    SaliencyBlendCompositeOp,
    SeamlessBlendCompositeOp
}

// MagickCore/colorspace.h
ColorspaceType :: enum c.int {
    UndefinedColorspace,
    CMYColorspace,           /* negated linear RGB colorspace */
    CMYKColorspace,          /* CMY with Black separation */
    GRAYColorspace,          /* Single Channel greyscale (non-linear) image */
    HCLColorspace,
    HCLpColorspace,
    HSBColorspace,
    HSIColorspace,
    HSLColorspace,
    HSVColorspace,           /* alias for HSB */
    HWBColorspace,
    LabColorspace,
    LCHColorspace,           /* alias for LCHuv */
    LCHabColorspace,         /* Cylindrical (Polar) Lab */
    LCHuvColorspace,         /* Cylindrical (Polar) Luv */
    LogColorspace,
    LMSColorspace,
    LuvColorspace,
    OHTAColorspace,
    Rec601YCbCrColorspace,
    Rec709YCbCrColorspace,
    RGBColorspace,           /* Linear RGB colorspace */
    scRGBColorspace,         /* ??? */
    sRGBColorspace,          /* Default: non-linear sRGB colorspace */
    TransparentColorspace,
    xyYColorspace,
    XYZColorspace,           /* IEEE Color Reference colorspace */
    YCbCrColorspace,
    YCCColorspace,
    YDbDrColorspace,
    YIQColorspace,
    YPbPrColorspace,
    YUVColorspace,
    LinearGRAYColorspace,     /* Single Channel greyscale (linear) image */
    JzazbzColorspace,
    DisplayP3Colorspace,
    Adobe98Colorspace,
    ProPhotoColorspace,
    OklabColorspace,
    OklchColorspace,
    CAT02LMSColorspace
}

// MagickCore/profile.h
RenderingIntent :: enum c.int {
    UndefinedIntent,
    SaturationIntent,
    PerceptualIntent,
    AbsoluteIntent,
    RelativeIntent
}

// MagickCore/color.h
ComplianceType :: enum c.int {
    UndefinedCompliance,
    NoCompliance = 0x0000,
    CSSCompliance = 0x0001,
    SVGCompliance = 0x0001,
    X11Compliance = 0x0002,
    XPMCompliance = 0x0004,
    MVGCompliance = 0x0008,
    AllCompliance = 0x7fffffff
}

ColorInfo :: struct {
    path, name : ^c.char,
    compliance : ComplianceType,
    color : PixelInfo,
    exempt, stealth : MagickBooleanType,
    signature : c.size_t
}

ErrorInfo :: struct {
    mean_error_per_pixel, normalized_mean_error, normalized_maximum_error : c.double
}

// MagickCore/image.h
ImageType :: enum c.int {
	UndefinedType,
	BilevelType,
	GrayscaleType,
	GrayscaleAlphaType,
	PaletteType,
	PaletteAlphaType,
	TrueColorType,
	TrueColorAlphaType,
	ColorSeparationType,
	ColorSeparationAlphaType,
	OptimizeType,
	PaletteBilevelAlphaType,
}

InterlaceType :: enum c.int {
	UndefinedInterlace,
	NoInterlace,
	LineInterlace,
	PlaneInterlace,
	PartitionInterlace,
	GIFInterlace,
	JPEGInterlace,
	PNGInterlace,
}

OrientationType :: enum c.int {
	UndefinedOrientation,
	TopLeftOrientation,
	TopRightOrientation,
	BottomRightOrientation,
	BottomLeftOrientation,
	LeftTopOrientation,
	RightTopOrientation,
	RightBottomOrientation,
	LeftBottomOrientation,
}

ResolutionType :: enum c.int {
	UndefinedResolution,
	PixelsPerInchResolution,
	PixelsPerCentimeterResolution,
}

TransmitType :: enum c.int {
	UndefinedTransmitType,
	FileTransmitType,
	BlobTransmitType,
	StreamTransmitType,
	ImageTransmitType,
}

PrimaryInfo :: struct {
	x, y, z : c.double,
}

SegmentInfo :: struct {
	x1, y1, x2, y2 : c.double,
}

ChromaticityInfo :: struct {
	red_primary, green_primary, blue_primary, white_point : PrimaryInfo,
}

Image :: struct {
    storage_class : ClassType,
    colorspace : ColorspaceType,    /* colorspace of image data */
    compression : CompressionType,   /* compression of image when read/write */
    quality : c.size_t,          /* compression quality setting, meaning varies */
    orientation : OrientationType,   /* photo orientation of image */
    taint : MagickBooleanType, /* has image been modified since reading */
    columns, rows : c.size_t, /* physical size of image */
    depth : c.size_t, /* depth of image on read/write */
    colors : c.size_t, /* Size of color table, or actual color count Only valid if image is not DirectClass */
    colormap : ^PixelInfo,
    alpha_color : PixelInfo, /* deprecated */
    background_color : PixelInfo, /* current background color attribute */
    border_color : PixelInfo, /* current bordercolor attribute */
    transparent_color : PixelInfo,
    gamma : c.double,
    chromaticity : ChromaticityInfo,
    rendering_intent : RenderingIntent,
    profiles : rawptr,
    units : ResolutionType,
    montage, directory, geometry : ^c.char,
    offset : c.ssize_t, /* ??? */
    resolution : PointInfo, /* image resolution/density */
    page : RectangleInfo, /* virtual canvas size and offset of image */
    extract_info : RectangleInfo,
    fuzz : c.double, /* current color fuzz attribute - move to image_info */
    filter : FilterType, /* resize/distort filter to apply */
    intensity : PixelIntensityMethod, /* method to generate an intensity value from a pixel */
    interlace : InterlaceType,
    endian : EndianType, /* raw data integer ordering on read/write */
    gravity : GravityType, /* Gravity attribute for positioning in image */
    compose : CompositeOperator, /* alpha composition method for layered images */
    dispose : DisposeType, /* GIF animation disposal method */
    scene : c.size_t, /* index of image in multi-image file */
    delay : c.size_t, /* Animation delay time */
    duration : c.size_t, /* Total animation duration sum(delay*iterations) */
    ticks_per_second : c.ssize_t, /* units for delay time, default 100 for GIF */
    iteration : c.size_t, /* number of interactions for GIF animations */
    total_colors : c.size_t,
    start_loop : c.ssize_t, /* ??? */
    interpolate : PixelInterpolateMethod, /* Interpolation of color for between pixel lookups */
    black_point_compensation : MagickBooleanType,
    tile_offset : RectangleInfo,
    type : ImageType,
    dither : MagickBooleanType, /* dithering on/off */
    extent : MagickSizeType, /* Size of image read from disk */
    ping : MagickBooleanType, /* no image data read, just attributes */
    read_mask, write_mask : MagickBooleanType,
    alpha_trait : PixelTrait, /* is transparency channel defined and active */
    number_channels, number_meta_channels, metacontent_extent : c.size_t,
    channel_mask : ChannelType,
    channel_map : ^PixelChannelMap,
    cache : rawptr,
    error : ErrorInfo,
}

// MagickWand/magick-wand-private.h
MagickWand :: struct {
	id  :   c.size_t,
	name: [MagickPathExtent]c.char,
}
