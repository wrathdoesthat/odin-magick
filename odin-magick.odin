package odinmagick

/* 
    Most of the code is from the "development headers" that get installed with the windows installer
    some of it is from the github as some structs dont have full definitions in the development headers
    (so they will be from .c files instead of .h)
*/

import "core:c"
import "core:sys/windows"

when ODIN_OS == .Windows {
	foreign import lib {"./lib/CORE_RL_MagickCore_.lib", "./lib/CORE_RL_MagickWand_.lib"}
} else {
	#assert(false, "Unsupported odin-magick OS")
}

// MagickCore/thread-private.h line 43
when ODIN_OS == .Windows {
    MagickMutexType :: windows.CRITICAL_SECTION 
} else {
    MagickMutexType :: c.size_t
}

// MagickCore/thread_.h line 31
when ODIN_OS == .Windows {
    MagickThreadType :: windows.DWORD
}

/* 
    This is from sys/stat.h on windows its not bound to and i cant think of what file to contribute the binding to odin for
    so ill just put it here for now
*/
_dev_t     :: c.uint
_ino_t     :: c.ushort
__time64_t :: c.int64_t // __int64
time_t :: __time64_t

_stat64 :: struct {
    st_dev : _dev_t,
    st_ino : _ino_t,
    st_mode : c.ushort,
    st_nlink : c.short,
    st_uid : c.short,
    st_gid : c.short,
    st_rdev : _dev_t,
    st_size : c.int64_t, // __int64
    st_atime : __time64_t,
    st_mtime : __time64_t,
    st_ctime : __time64_t
}

stat :: _stat64

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

// MagickCore/blob-private.h
BlobMode :: enum c.int {
    UndefinedBlobMode,
    ReadBlobMode,
    ReadBinaryBlobMode,
    WriteBlobMode,
    WriteBinaryBlobMode,
    AppendBlobMode,
    AppendBinaryBlobMode
}

StreamType :: enum c.int {
    UndefinedStream,
    FileStream,
    StandardStream,
    PipeStream,
    ZipStream,
    BZipStream,
    FifoStream,
    BlobStream,
    CustomStream
}

// MagickCore/stream.h
StreamHandler :: #type ^proc(#by_ptr Image, rawptr, c.size_t) -> c.size_t 

// MagickCore/blob.h
CustomStreamHandler :: #type ^proc(^c.uchar, c.size_t, rawptr) -> c.ssize_t
CustomStreamSeeker :: #type ^proc(MagickOffsetType, c.int, rawptr) -> MagickOffsetType
CustomStreamTeller :: #type ^proc(MagickOffsetType, c.int, rawptr) -> MagickOffsetType

// MagickCore/blob.c
FileInfo :: struct #raw_union {
    file: ^c.FILE    
/* 
TODO: are these needed? they are in the union as well
#if defined(MAGICKCORE_ZLIB_DELEGATE)
  gzFile
    gzfile;
#endif

#if defined(MAGICKCORE_BZLIB_DELEGATE)
  BZFILE
    *bzfile;
#endif 
*/
}

BlobInfo :: struct {
    length, extent, quantum : c.size_t,
    mode : BlobMode,
    mapped, eof : MagickBooleanType,
    error, error_number : c.int,
    offset : MagickOffsetType,
    size : MagickSizeType,
    exempt, synchronize, temporary : MagickBooleanType,
    status : c.int,
    type : StreamType,
    file_info : FileInfo,
    properties : stat,
    stream : StreamHandler,
    custom_stream: ^CustomStreamInfo,
    data : ^c.uchar,
    debug : MagickBooleanType,
    semaphore : ^SemaphoreInfo,
    reference_count : c.ssize_t,
    signature : c.size_t
}

CustomStreamInfo :: struct {
    reader, writer : CustomStreamHandler,
    seeker : CustomStreamSeeker,
    teller : CustomStreamTeller,
    data : rawptr,
    signature : c.size_t
}

// MagickCore/monitor.h
MagickProgressMonitor :: #type ^proc(#by_ptr c.char, MagickOffsetType, MagickSizeType, rawptr)

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

// MagickCore/semaphore.c
SemaphoreInfo :: struct {
    mutex : MagickMutexType,
    id : MagickThreadType,
    reference_count : c.ssize_t,
    signature : c.size_t
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

// MagickCore/compress.c
Ascii85Info :: struct {
    offset, line_break : c.ssize_t,
    tuple : [6]c.char,
    buffer : [10]c.uchar
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

// MagickCore/profile.c
ProfileInfo :: struct {
    name : ^c.char,
    length : c.size_t,
    info : ^c.uchar,
    signature : c.size_t
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

// MagickCore/exception.h
ExceptionType :: enum c.int {
    UndefinedException,
    WarningException = 300,
    ResourceLimitWarning = 300,
    TypeWarning = 305,
    OptionWarning = 310,
    DelegateWarning = 315,
    MissingDelegateWarning = 320,
    CorruptImageWarning = 325,
    FileOpenWarning = 330,
    BlobWarning = 335,
    StreamWarning = 340,
    CacheWarning = 345,
    CoderWarning = 350,
    FilterWarning = 352,
    ModuleWarning = 355,
    DrawWarning = 360,
    ImageWarning = 365,
    WandWarning = 370,
    RandomWarning = 375,
    XServerWarning = 380,
    MonitorWarning = 385,
    RegistryWarning = 390,
    ConfigureWarning = 395,
    PolicyWarning = 399,
    ErrorException = 400,
    ResourceLimitError = 400,
    TypeError = 405,
    OptionError = 410,
    DelegateError = 415,
    MissingDelegateError = 420,
    CorruptImageError = 425,
    FileOpenError = 430,
    BlobError = 435,
    StreamError = 440,
    CacheError = 445,
    CoderError = 450,
    FilterError = 452,
    ModuleError = 455,
    DrawError = 460,
    ImageError = 465,
    WandError = 470,
    RandomError = 475,
    XServerError = 480,
    MonitorError = 485,
    RegistryError = 490,
    ConfigureError = 495,
    PolicyError = 499,
    FatalErrorException = 700,
    ResourceLimitFatalError = 700,
    TypeFatalError = 705,
    OptionFatalError = 710,
    DelegateFatalError = 715,
    MissingDelegateFatalError = 720,
    CorruptImageFatalError = 725,
    FileOpenFatalError = 730,
    BlobFatalError = 735,
    StreamFatalError = 740,
    CacheFatalError = 745,
    CoderFatalError = 750,
    FilterFatalError = 752,
    ModuleFatalError = 755,
    DrawFatalError = 760,
    ImageFatalError = 765,
    WandFatalError = 770,
    RandomFatalError = 775,
    XServerFatalError = 780,
    MonitorFatalError = 785,
    RegistryFatalError = 790,
    ConfigureFatalError = 795,
    PolicyFatalError = 799
}

ExceptionInfo :: struct {
    severity : ExceptionType,
    error_number : c.int,
    reason, description : ^c.char,
    exceptions : rawptr,
    relinquish : MagickBooleanType,
    semaphore : ^SemaphoreInfo,
    signature : c.size_t,
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

ImageInfo :: struct {
    compression : CompressionType,
    orientation : OrientationType,
    temporary : MagickBooleanType, /* image file to be deleted after read "ephemeral:" */
    adjoin : MagickBooleanType, /* save images to separate scene files */
    affirm : MagickBooleanType,
    antialias : MagickBooleanType,
    size : ^c.char, /* image generation size */
    extract : ^c.char, /* crop/resize string on image read */
    page : ^c.char,
    scenes : ^c.char, /* scene numbers that is to be read in */
    scene : c.size_t, /* starting value for image save numbering */
    number_scenes : c.size_t, /* total number of images in list - for escapes */
    depth : c.size_t, /* current read/save depth of images */
    interlace : InterlaceType, /* interlace for image write */
    endian : EndianType, /* integer endian order for raw image data */
    units : ResolutionType, /* density pixels/inch or pixel/cm */
    quality : c.size_t, /* compression quality */
    sampling_factor : ^c.char, /* Chroma subsampling ratio string */
    server_name : ^c.char, /* X windows server name - display/animate */
    font : ^c.char, /* DUP for draw_info */
    texture : ^c.char, /* montage/display background tile */
    density : ^c.char, /* DUP for image and draw_info */
    pointsize : c.double,
    fuzz : c.double, /* current color fuzz attribute */
    alpha_color : PixelInfo, /* deprecated */
    background_color : PixelInfo, /* user set background color */
    border_color : PixelInfo, /* user set border color */
    /* 
        color for transparent index in color tables
        NB: fill color is only needed in draw_info!
        the same for undercolor (for font drawing) 
    */
    transparent_color : PixelInfo,
    dither : MagickBooleanType, /* dither enable-disable */
    monochrome : MagickBooleanType, /* read/write pcl,pdf,ps,xps as monochrome image */
    colorspace : ColorspaceType,
    compose : CompositeOperator,
    type : ImageType,
    ping : MagickBooleanType, /* fast read image attributes, not image data */
    verbose : MagickBooleanType, /* verbose output enable/disable */
    channel : ChannelType,
    options : rawptr, /* splay tree of global options */
    profile : rawptr, 
    synchronize : MagickBooleanType,
    progress_monitor : MagickProgressMonitor,
    client_data, cache: rawptr,
    stream : StreamHandler,
    file : ^c.FILE,
    blob : rawptr,
    length : c.size_t,
    magick : [MagickPathExtent]c.char, /* image file format (file magick) */
    unique : [MagickPathExtent]c.char, /* unique temporary filename - delegates */
    filename : [MagickPathExtent]c.char, /* filename when reading/writing image */
    debug : MagickBooleanType,
    signature : c.size_t,
    custom_stream : ^CustomStreamInfo,
    matte_color : PixelInfo
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
    timer : TimerInfo,
    progress_monitor : MagickProgressMonitor,
    client_data : rawptr,
    ascii85 : ^Ascii85Info,
    generic_profile : ^ProfileInfo,
    properties : rawptr, /* general settings, to save with image */
    artifacts : rawptr, /* general operational/coder settings, not saved */
    filename : [MagickPathExtent]c.char, /* images input filename */
    magick_filename : [MagickPathExtent]c.char, /* given image filename (with read mods) */
    magick : [MagickPathExtent]c.char, /* images file format (file magic) */
    magick_rows, magick_columns : c.size_t, /* size of image when read/created */
    blob : ^BlobInfo,
    timestamp : time_t,
    debug : MagickBooleanType,
    reference_count : c.ssize_t,
    semaphore : ^SemaphoreInfo,

    /* 
        (Optional) Image belongs to this ImageInfo 'list'
        * For access to 'global options' when no per-image
        * attribute, prosperity, or artifact has been set.
    */
    image_info : ^ImageInfo,
    list : ^Image, /* Undo/Redo image processing list (for display) */
    previous : ^Image, /* Image list links */
    next : ^Image,
    signature : c.size_t,
    matte_color : PixelInfo,
    composite_mask : MagickBooleanType,
    mask_trait : PixelTrait,
    channels : ChannelType,
    ttl : time_t,
}

// MagickWand/magick-wand-private.h
MagickWand :: struct {
	id  : c.size_t,
	name : [MagickPathExtent]c.char, /* Wand name to use for MagickWand Logs */
    images : ^Image, /* The images in this wand - also the current image */
    image_info : ^ImageInfo, /* Global settings used for images in Wand */
    exception : ^ExceptionInfo,
    insert_before : MagickBooleanType, /* wand set to first image, prepend new images */
    image_pending : MagickBooleanType, /* this image is pending Next/Previous Iteration */
    debug : MagickBooleanType, /* Log calls to MagickWand library */
    signature : c.size_t
}

// MagickCore functions

// MagickWand functions
@(default_calling_convention="c")
foreign lib {
    MagickWandGenesis :: proc() ---
    MagickWandTerminus :: proc() --- 

    MagickReadImage :: proc(^MagickWand, cstring) -> MagickBooleanType ---
    MagickWriteImage :: proc(^MagickWand, cstring) -> MagickBooleanType ---
    MagickResizeImage :: proc(^MagickWand, c.size_t, c.size_t, FilterType) -> MagickBooleanType ---

    NewMagickWand :: proc() -> ^MagickWand ---
    DestroyMagickWand :: proc(^MagickWand) -> ^MagickWand ---
}