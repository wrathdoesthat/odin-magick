package odinmagick

/* 
    Most of the code is from the "development headers" that get installed with the windows installer
    some of it is from the github as some structs dont have full definitions in the development headers
    (so they will be from .c files instead of .h)
*/

import "core:c"
import "core:c/libc"
import "core:sys/windows"

when ODIN_OS == .Windows {
	foreign import lib {"./lib/CORE_RL_MagickCore_.lib", "./lib/CORE_RL_MagickWand_.lib"}

    // MagickCore/thread-private.h line 43
    MagickMutexType :: windows.CRITICAL_SECTION 

    // MagickCore/thread_.h line 31
    MagickThreadType :: windows.DWORD

    // TODO: apparently 8 on MSVC but im not really sure
    LongDoubleByteSize :: 8
} else when ODIN_OS == .Linux {
   foreign import lib {"system:MagickCore-7.Q16HDRI", "system:MagickWand-7.Q16HDRI"} 

    MagickMutexType :: c.size_t
    MagickThreadType :: c.int

     // TODO: verify this is correct
    when ODIN_ARCH == .amd64 {
        LongDoubleByteSize :: 16
    } else when ODIN_ARCH == .i386 {
        LongDoubleByteSize :: 12
    } else {
        #assert(false, "Unsupported odin-magick Architecture")
    }
} else {
	#assert(false, "Unsupported odin-magick OS")
}

/* 
    This is from sys/stat.h on windows its not bound to and i cant think of what file to contribute the binding to odin for
    so ill just put it here for now
*/
_dev_t :: c.uint
_ino_t :: c.ushort

// TODO: This is the stat64 for windows what is the linux version?
_stat64 :: struct {
    st_dev: _dev_t,
    st_ino: _ino_t,
    st_mode: c.ushort,
    st_nlink: c.short,
    st_uid: c.short,
    st_gid: c.short,
    st_rdev: _dev_t,
    st_size: c.int64_t, // __int64
    st_atime: libc.time_t,
    st_mtime: libc.time_t,
    st_ctime: libc.time_t
}

stat :: _stat64

// MagickWand/method-attribute.h
MagickPathExtent : c.int : 4096

// MagickCore/Magick-type.h
MagickFloatType :: c.float
MagickOffsetType :: c.longlong
MagickSizeType  :: c.ulonglong
MagickDoubleType :: c.double
MagickRealType  :: MagickDoubleType

MagickStatusType :: c.uint

Quantum :: MagickFloatType

ClassType :: enum c.int {
	UndefinedClass,
	DirectClass,
	PseudoClass,
}

MagickBooleanType :: enum c.int {
	MagickFalse = 0,
	MagickTrue  = 1,
}

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
StreamHandler :: #type ^proc(^Image, rawptr, c.size_t) -> c.size_t 

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
    length, extent, quantum: c.size_t,
    mode: BlobMode,
    mapped, eof: MagickBooleanType,
    error, error_number: c.int,
    offset: MagickOffsetType,
    size: MagickSizeType,
    exempt, synchronize, temporary: MagickBooleanType,
    status: c.int,
    type: StreamType,
    file_info: FileInfo,
    properties: stat,
    stream: StreamHandler,
    custom_stream: ^CustomStreamInfo,
    data: ^c.uchar,
    debug: MagickBooleanType,
    semaphore: ^SemaphoreInfo,
    reference_count: c.ssize_t,
    signature: c.size_t
}

CustomStreamInfo :: struct {
    reader, writer: CustomStreamHandler,
    seeker: CustomStreamSeeker,
    teller: CustomStreamTeller,
    data: rawptr,
    signature: c.size_t
}

// MagickCore/statistic.h
MagickEvaluateOperator :: enum c.int {
    UndefinedEvaluateOperator,
    AbsEvaluateOperator,
    AddEvaluateOperator,
    AddModulusEvaluateOperator,
    AndEvaluateOperator,
    CosineEvaluateOperator,
    DivideEvaluateOperator,
    ExponentialEvaluateOperator,
    GaussianNoiseEvaluateOperator,
    ImpulseNoiseEvaluateOperator,
    LaplacianNoiseEvaluateOperator,
    LeftShiftEvaluateOperator,
    LogEvaluateOperator,
    MaxEvaluateOperator,
    MeanEvaluateOperator,
    MedianEvaluateOperator,
    MinEvaluateOperator,
    MultiplicativeNoiseEvaluateOperator,
    MultiplyEvaluateOperator,
    OrEvaluateOperator,
    PoissonNoiseEvaluateOperator,
    PowEvaluateOperator,
    RightShiftEvaluateOperator,
    RootMeanSquareEvaluateOperator,
    SetEvaluateOperator,
    SineEvaluateOperator,
    SubtractEvaluateOperator,
    SumEvaluateOperator,
    ThresholdBlackEvaluateOperator,
    ThresholdEvaluateOperator,
    ThresholdWhiteEvaluateOperator,
    UniformNoiseEvaluateOperator,
    XorEvaluateOperator,
    InverseLogEvaluateOperator
}

StatisticType :: enum c.int {
    UndefinedStatistic,
    GradientStatistic,
    MaximumStatistic,
    MeanStatistic,
    MedianStatistic,
    MinimumStatistic,
    ModeStatistic,
    NonpeakStatistic,
    RootMeanSquareStatistic,
    StandardDeviationStatistic,
    ContrastStatistic
}

MagickFunction :: enum c.int {
    UndefinedFunction,
    ArcsinFunction,
    ArctanFunction,
    PolynomialFunction,
    SinusoidFunction
}

ChannelStatistics :: struct {
    depth: c.size_t,
    area: c.double,
    minima: c.double,
    maxima: c.double,
    sum: c.double,
    sum_squared: c.double,
    sum_cubed: c.double,
    sum_fourth_power: c.double,
    mean: c.double,
    variance: c.double,
    standard_deviation: c.double,
    kurtosis: c.double,
    skewness: c.double,
    entropy: c.double,
    median: c.double ,

    // These are 5 long doubles
    // TODO: figure out how to make this actually right
    // https://github.com/ImageMagick/ImageMagick/blob/fad6becfb5626be94553aa5a78034c017226aba4/MagickCore/statistic.h#L50
    _unused: [LongDoubleByteSize * 5]u8
}


// MagickCore/monitor.h
MagickProgressMonitor :: #type ^proc(cstring, MagickOffsetType, MagickSizeType, rawptr)

// MagickCore/timer.h
TimerState :: enum c.int {
    UndefinedTimerState,
    StoppedTimerState,
    RunningTimerState
}

Timer :: struct {
    start, stop, total: c.double
}

TimerInfo :: struct {
    user, elapsed: Timer,
    state: TimerState,
    signature: c.size_t
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
    mutex: MagickMutexType,
    id: MagickThreadType,
    reference_count: c.ssize_t,
    signature: c.size_t
}

// MagickCore/compare.h
MetricType :: enum c.int {
    UndefinedErrorMetric,
    AbsoluteErrorMetric,
    FuzzErrorMetric,
    MeanAbsoluteErrorMetric,
    MeanErrorPerPixelErrorMetric,
    MeanSquaredErrorMetric,
    NormalizedCrossCorrelationErrorMetric,
    PeakAbsoluteErrorMetric,
    PeakSignalToNoiseRatioErrorMetric,
    PerceptualHashErrorMetric,
    RootMeanSquaredErrorMetric,
    StructuralSimilarityErrorMetric,
    StructuralDissimilarityErrorMetric,
    PhaseCorrelationErrorMetric,
    DotProductCorrelationErrorMetric
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

// MagickCore/feature.h
ChannelFeatures :: struct {
    angular_second_moment: [4]c.double,
    contrast: [4]c.double,
    correlation: [4]c.double,
    variance_sum_of_squares: [4]c.double,
    inverse_difference_moment: [4]c.double,
    sum_average: [4]c.double,
    sum_variance: [4]c.double,
    sum_entropy: [4]c.double,
    entropy: [4]c.double,
    difference_variance: [4]c.double,
    difference_entropy: [4]c.double,
    measure_of_correlation_1: [4]c.double,
    measure_of_correlation_2: [4]c.double,
    maximum_correlation_coefficient: [4]c.double
}

// MagickCore/compress.c
Ascii85Info :: struct {
    offset, line_break: c.ssize_t,
    tuple: [6]c.char,
    buffer: [10]c.uchar
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
    channel: PixelChannel,
    traits: PixelTrait,
    offset: c.ssize_t
}

PixelInfo :: struct {
    storage_class: ClassType,
    colorspace: ColorspaceType,
    alpha_trait: PixelTrait,
    fuzz: c.double,
    depth: c.size_t,
    count: MagickSizeType,
    red, green, blue, black, alpha, index: MagickRealType
}

PixelPacket :: struct {
    red, green, blue, alpha, black: c.uint
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
    sx, rx, ry, sy, tx, ty: c.double
}

GeometryInfo :: struct {
    rho, sigma, xi, psi, chi: c.double
}

OffsetInfo :: struct {
    x, y: c.ssize_t
}

PointInfo :: struct {
    x, y: c.double
}

RectangleInfo :: struct {
    width, height: c.size_t,
    x, y: c.ssize_t
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

// MagickCore/resource_.h
ResourceType :: enum c.int {
    UndefinedResource,
    AreaResource,
    DiskResource,
    FileResource,
    HeightResource,
    MapResource,
    MemoryResource,
    ThreadResource,
    ThrottleResource,
    TimeResource,
    WidthResource,
    ListLengthResource
}

// MagickCore/distort.h
DistortMethod :: enum c.int {
    UndefinedDistortion,
    AffineDistortion,
    AffineProjectionDistortion,
    ScaleRotateTranslateDistortion,
    PerspectiveDistortion,
    PerspectiveProjectionDistortion,
    BilinearForwardDistortion,
    BilinearDistortion = BilinearForwardDistortion,
    BilinearReverseDistortion,
    PolynomialDistortion,
    ArcDistortion,
    PolarDistortion,
    DePolarDistortion,
    Cylinder2PlaneDistortion,
    Plane2CylinderDistortion,
    BarrelDistortion,
    BarrelInverseDistortion,
    ShepardsDistortion,
    ResizeDistortion,
    SentinelDistortion,
    RigidAffineDistortion
}

SparseColorMethod :: enum c.int {
    UndefinedColorInterpolate = cast(c.int)DistortMethod.UndefinedDistortion,
    BarycentricColorInterpolate = cast(c.int)DistortMethod.AffineDistortion,
    BilinearColorInterpolate = cast(c.int)DistortMethod.BilinearReverseDistortion,
    PolynomialColorInterpolate = cast(c.int)DistortMethod.PolynomialDistortion,
    ShepardsColorInterpolate = cast(c.int)DistortMethod.ShepardsDistortion,
    /*
    Methods unique to SparseColor().
    */
    VoronoiColorInterpolate = cast(c.int)DistortMethod.SentinelDistortion,
    InverseColorInterpolate,
    ManhattanColorInterpolate
}

// MagickCore/threshold.h
AutoThresholdMethod :: enum c.int {
    UndefinedThresholdMethod,
    KapurThresholdMethod,
    OTSUThresholdMethod,
    TriangleThresholdMethod
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

// MagickCore/profile.c
ProfileInfo :: struct {
    name: ^c.char,
    length: c.size_t,
    info: ^c.uchar,
    signature: c.size_t
}

// MagickCore/profile.h
RenderingIntent :: enum c.int {
    UndefinedIntent,
    SaturationIntent,
    PerceptualIntent,
    AbsoluteIntent,
    RelativeIntent
}

// MagickCore/effect.h
PreviewType :: enum c.int {
    UndefinedPreview,
    RotatePreview,
    ShearPreview,
    RollPreview,
    HuePreview,
    SaturationPreview,
    BrightnessPreview,
    GammaPreview,
    SpiffPreview,
    DullPreview,
    GrayscalePreview,
    QuantizePreview,
    DespecklePreview,
    ReduceNoisePreview,
    AddNoisePreview,
    SharpenPreview,
    BlurPreview,
    ThresholdPreview,
    EdgeDetectPreview,
    SpreadPreview,
    SolarizePreview,
    ShadePreview,
    RaisePreview,
    SegmentPreview,
    SwirlPreview,
    ImplodePreview,
    WavePreview,
    OilPaintPreview,
    CharcoalDrawingPreview,
    JPEGPreview
}

// MagickCore/visual-effects.h
NoiseType :: enum c.int {
    UndefinedNoise,
    UniformNoise,
    GaussianNoise,
    MultiplicativeGaussianNoise,
    ImpulseNoise,
    LaplacianNoise,
    PoissonNoise,
    RandomNoise
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
    path, name: ^c.char,
    compliance: ComplianceType,
    color: PixelInfo,
    exempt, stealth: MagickBooleanType,
    signature: c.size_t
}

ErrorInfo :: struct {
    mean_error_per_pixel, normalized_mean_error, normalized_maximum_error: c.double
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
    severity: ExceptionType,
    error_number: c.int,
    reason, description: ^c.char,
    exceptions: rawptr,
    relinquish: MagickBooleanType,
    semaphore: ^SemaphoreInfo,
    signature: c.size_t,
}

ErrorHandler :: #type proc(ExceptionType, cstring, cstring)
FatalErrorHandler :: #type proc(ExceptionType, cstring, cstring)
WarningHandler :: #type proc(ExceptionType, cstring, cstring)

// MagickCore/magick.h
DecodeImageHandler :: #type proc(^ImageInfo, ^ExceptionInfo) -> Image
EncodeImageHandler :: #type proc(^ImageInfo, ^Image, ^ExceptionInfo) -> MagickBooleanType
IsImageFormatHandler :: #type proc(cstring, c.size_t) -> MagickBooleanType

MagickFormatType :: enum c.int {
    UndefinedFormatType,
    ImplicitFormatType,
    ExplicitFormatType
}

MagickInfoFlag :: enum c.int {
    CoderNoFlag = 0x0000,
    CoderAdjoinFlag = 0x0001,
    CoderBlobSupportFlag = 0x0002,
    CoderDecoderThreadSupportFlag = 0x0004,
    CoderEncoderThreadSupportFlag = 0x0008,
    CoderEndianSupportFlag = 0x0010,
    CoderRawSupportFlag = 0x0020,
    CoderSeekableStreamFlag = 0x0040, /* deprecated */
    CoderStealthFlag = 0x0080,
    CoderUseExtensionFlag = 0x0100,
    CoderDecoderSeekableStreamFlag = 0x0200,
    CoderEncoderSeekableStreamFlag = 0x0400 
}

MagickInfo :: struct {
    name, description, version, mime_type, note, magick_module : cstring,
    decoder: ^DecodeImageHandler,
    encoder: ^EncodeImageHandler,
    image_info: ^ImageInfo,
    magick: ^IsImageFormatHandler,
    format_type: MagickFormatType,
    flags: MagickStatusType,
    semaphore: ^SemaphoreInfo,
    signature: c.size_t,
    client_data: rawptr
}

// MagickCore/type.h
StretchType :: enum c.int {
    UndefinedStretch,
    NormalStretch,
    UltraCondensedStretch,
    ExtraCondensedStretch,
    CondensedStretch,
    SemiCondensedStretch,
    SemiExpandedStretch,
    ExpandedStretch,
    ExtraExpandedStretch,
    UltraExpandedStretch,
    AnyStretch
} 

StyleType :: enum c.int {
    UndefinedStyle,
    NormalStyle,
    ItalicStyle,
    ObliqueStyle,
    AnyStyle,
    BoldStyle  /* deprecated */
}

// MagickCore/cache-view.h
VirtualPixelMethod :: enum c.int {
    UndefinedVirtualPixelMethod,
    BackgroundVirtualPixelMethod,
    DitherVirtualPixelMethod,
    EdgeVirtualPixelMethod,
    MirrorVirtualPixelMethod,
    RandomVirtualPixelMethod,
    TileVirtualPixelMethod,
    TransparentVirtualPixelMethod,
    MaskVirtualPixelMethod,
    BlackVirtualPixelMethod,
    GrayVirtualPixelMethod,
    WhiteVirtualPixelMethod,
    HorizontalTileVirtualPixelMethod,
    VerticalTileVirtualPixelMethod,
    HorizontalTileEdgeVirtualPixelMethod,
    VerticalTileEdgeVirtualPixelMethod,
    CheckerTileVirtualPixelMethod
}

// MagickCore/draw.h
StopInfo :: struct {
    color: PixelInfo,
    offset: c.double
}

FillRule :: enum c.int {
    UndefinedRule,
    EvenOddRule,
    NonZeroRule
}

SpreadMethod :: enum c.int {
    UndefinedSpread,
    PadSpread,
    ReflectSpread,
    RepeatSpread
}

AlignType :: enum c.int {
    UndefinedAlign,
    LeftAlign,
    CenterAlign,
    RightAlign
}

DirectionType :: enum c.int {
    UndefinedDirection,
    RightToLeftDirection,
    LeftToRightDirection,
    TopToBottomDirection
}

GradientType :: enum c.int {
    UndefinedGradient,
    LinearGradient,
    RadialGradient
}

LineCap :: enum c.int {
    UndefinedCap,
    ButtCap,
    RoundCap,
    SquareCap
}

ClipPathUnits :: enum c.int {
    UndefinedPathUnits,
    UserSpace,
    UserSpaceOnUse,
    ObjectBoundingBox
}

DecorationType :: enum c.int {
    UndefinedDecoration,
    NoDecoration,
    UnderlineDecoration,
    OverlineDecoration,
    LineThroughDecoration
}

ReferenceType :: enum c.int {
    UndefinedReference,
    GradientReference
}

WordBreakType :: enum c.int {
    UndefinedWordBreakType,
    NormalWordBreakType,
    BreakWordBreakType
}

LineJoin :: enum c.int {
    UndefinedJoin,
    MiterJoin,
    RoundJoin,
    BevelJoin
}

ElementReference :: struct {
    id: cstring,
    type: ReferenceType,
    gradient: GradientInfo,
    previous, next: ^ElementReference,
    signature: c.size_t
}

GradientInfo :: struct {
    type: GradientType,
    bounding_box: RectangleInfo,
    gradient_vector: SegmentInfo,
    stops: ^StopInfo,
    number_stops: c.size_t,
    spread: SpreadMethod,
    debug: MagickBooleanType,
    center, radii: PointInfo,
    radius, angle: c.double,
    signature: c.size_t
}

DrawInfo :: struct {
    primitive, geometry: cstring,
    viewbox: RectangleInfo,
    affine: AffineMatrix,
    fill, stroke, undercolor, border_color: PixelInfo,
    fill_pattern, stroke_pattern: ^Image,
    stroke_width: c.double,
    gradient: GradientInfo,
    stroke_antialias, text_antialias: MagickBooleanType,
    fill_rule: FillRule,
    linecap: LineCap,
    linejoin: LineJoin,
    miterlimit: c.size_t,
    dash_offset: c.double,
    decorate: DecorationType,
    compose: CompositeOperator,
    text, font, metrics, family: cstring,
    face: c.size_t,
    style: StyleType,
    stretch: StretchType,
    weight: c.size_t,
    encoding: cstring,
    pointsize: c.double,
    density: cstring,
    align: AlignType,
    gravity: GravityType,
    server_name: cstring,
    dash_pattern: ^c.double,
    clip_mask: cstring,
    bounds: SegmentInfo,
    clip_units: ClipPathUnits,
    alpha: Quantum,
    render: MagickBooleanType,
    element_reference: ElementReference,
    kerning, interword_spacing, interline_spacing: c.double,
    direction: DirectionType,
    debug: MagickBooleanType,
    signature: c.size_t,
    fill_alpha, stroke_alpha: c.double,
    clip_path: MagickBooleanType,
    clipping_mask: ^Image,
    compliance: ComplianceType,
    composite_mask: ^Image,
    id: cstring,
    word_break: WordBreakType,
    image_info: ^ImageInfo
}

// MagickCore/morphology.h
KernelInfoType :: enum c.int {
    UndefinedKernel,    /* equivalent to UnityKernel */
    UnityKernel,        /* The no-op or 'original image' kernel */
    GaussianKernel,     /* Convolution Kernels, Gaussian Based */
    DoGKernel,
    LoGKernel,
    BlurKernel,
    CometKernel,
    BinomialKernel,
    LaplacianKernel,    /* Convolution Kernels, by Name */
    SobelKernel,
    FreiChenKernel,
    RobertsKernel,
    PrewittKernel,
    CompassKernel,
    KirschKernel,
    DiamondKernel,      /* Shape Kernels */
    SquareKernel,
    RectangleKernel,
    OctagonKernel,
    DiskKernel,
    PlusKernel,
    CrossKernel,
    RingKernel,
    PeaksKernel,         /* Hit And Miss Kernels */
    EdgesKernel,
    CornersKernel,
    DiagonalsKernel,
    LineEndsKernel,
    LineJunctionsKernel,
    RidgesKernel,
    ConvexHullKernel,
    ThinSEKernel,
    SkeletonKernel,
    ChebyshevKernel,    /* Distance Measuring Kernels */
    ManhattanKernel,
    OctagonalKernel,
    EuclideanKernel,
    UserDefinedKernel   /* User Specified Kernel Array */
}

MorphologyMethod :: enum c.int {
    UndefinedMorphology,
    /* Convolve / Correlate weighted sums */
    ConvolveMorphology,           /* Weighted Sum with reflected kernel */
    CorrelateMorphology,          /* Weighted Sum using a sliding window */
    /* Low-level Morphology methods */
    ErodeMorphology,              /* Minimum Value in Neighbourhood */
    DilateMorphology,             /* Maximum Value in Neighbourhood */
    ErodeIntensityMorphology,     /* Pixel Pick using GreyScale Erode */
    DilateIntensityMorphology,    /* Pixel Pick using GreyScale Dilate */
    IterativeDistanceMorphology,  /* Add Kernel Value, take Minimum */
    /* Second-level Morphology methods */
    OpenMorphology,               /* Dilate then Erode */
    CloseMorphology,              /* Erode then Dilate */
    OpenIntensityMorphology,      /* Pixel Pick using GreyScale Open */
    CloseIntensityMorphology,     /* Pixel Pick using GreyScale Close */
    SmoothMorphology,             /* Open then Close */
    /* Difference Morphology methods */
    EdgeInMorphology,             /* Dilate difference from Original */
    EdgeOutMorphology,            /* Erode difference from Original */
    EdgeMorphology,               /* Dilate difference with Erode */
    TopHatMorphology,             /* Close difference from Original */
    BottomHatMorphology,          /* Open difference from Original */
    /* Recursive Morphology methods */
    HitAndMissMorphology,         /* Foreground/Background pattern matching */
    ThinningMorphology,           /* Remove matching pixels from image */
    ThickenMorphology,            /* Add matching pixels from image */
    /* Directly Applied Morphology methods */
    DistanceMorphology,           /* Add Kernel Value, take Minimum */
    VoronoiMorphology             /* Distance matte channel copy nearest color */
}

KernelInfo :: struct {
    type: KernelInfoType,
    width, height: c.size_t,
    x, y: c.ssize_t,
    values: ^MagickRealType,
    minimum, maximum, negative_range, positive_range, angle : c.double,
    next: ^KernelInfo,
    signature: c.size_t
}

// MagickCore/vision.h
CCObjectInfo :: struct {
    id: c.ssize_t,
    bounding_box: RectangleInfo,
    color: PixelInfo,
    centroid: PixelInfo,
    area, census: c.double,
    merge: MagickBooleanType,
    metric: [16]c.double,
    key: c.ssize_t
}

// MagickCore/quantize.h
DitherMethod :: enum c.int {
    UndefinedDitherMethod,
    NoDitherMethod,
    RiemersmaDitherMethod,
    FloydSteinbergDitherMethod
}

// MagickCore/fourier.h
ComplexOperator :: enum c.int {
    UndefinedComplexOperator,
    AddComplexOperator,
    ConjugateComplexOperator,
    DivideComplexOperator,
    MagnitudePhaseComplexOperator,
    MultiplyComplexOperator,
    RealImaginaryComplexOperator,
    SubtractComplexOperator
}

// MagickCore/channel.h
AlphaChannelOption :: enum c.int {
    UndefinedAlphaChannel,
    ActivateAlphaChannel,
    AssociateAlphaChannel,
    BackgroundAlphaChannel,
    CopyAlphaChannel,
    DeactivateAlphaChannel,
    DiscreteAlphaChannel,
    DisassociateAlphaChannel,
    ExtractAlphaChannel,
    OffAlphaChannel,
    OnAlphaChannel,
    OpaqueAlphaChannel,
    RemoveAlphaChannel,
    SetAlphaChannel,
    ShapeAlphaChannel,
    TransparentAlphaChannel,
    OffIfOpaqueAlphaChannel
}

// MagickCore/montage.h
MontageMode :: enum c.int {
    UndefinedMode,
    FrameMode,
    UnframeMode,
    ConcatenateMode
}

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
	x, y, z: c.double,
}

SegmentInfo :: struct {
	x1, y1, x2, y2: c.double,
}

ChromaticityInfo :: struct {
	red_primary, green_primary, blue_primary, white_point: PrimaryInfo,
}

ImageInfo :: struct {
    compression: CompressionType,
    orientation: OrientationType,
    temporary: MagickBooleanType, /* image file to be deleted after read "ephemeral:" */
    adjoin: MagickBooleanType, /* save images to separate scene files */
    affirm: MagickBooleanType,
    antialias: MagickBooleanType,
    size: ^c.char, /* image generation size */
    extract: ^c.char, /* crop/resize string on image read */
    page: ^c.char,
    scenes: ^c.char, /* scene numbers that is to be read in */
    scene: c.size_t, /* starting value for image save numbering */
    number_scenes: c.size_t, /* total number of images in list - for escapes */
    depth: c.size_t, /* current read/save depth of images */
    interlace: InterlaceType, /* interlace for image write */
    endian: EndianType, /* integer endian order for raw image data */
    units: ResolutionType, /* density pixels/inch or pixel/cm */
    quality: c.size_t, /* compression quality */
    sampling_factor: ^c.char, /* Chroma subsampling ratio string */
    server_name: ^c.char, /* X windows server name - display/animate */
    font: ^c.char, /* DUP for draw_info */
    texture: ^c.char, /* montage/display background tile */
    density: ^c.char, /* DUP for image and draw_info */
    pointsize: c.double,
    fuzz: c.double, /* current color fuzz attribute */
    alpha_color: PixelInfo, /* deprecated */
    background_color: PixelInfo, /* user set background color */
    border_color: PixelInfo, /* user set border color */
    /* 
        color for transparent index in color tables
        NB: fill color is only needed in draw_info!
        the same for undercolor (for font drawing) 
    */
    transparent_color: PixelInfo,
    dither: MagickBooleanType, /* dither enable-disable */
    monochrome: MagickBooleanType, /* read/write pcl,pdf,ps,xps as monochrome image */
    colorspace: ColorspaceType,
    compose: CompositeOperator,
    type: ImageType,
    ping: MagickBooleanType, /* fast read image attributes, not image data */
    verbose: MagickBooleanType, /* verbose output enable/disable */
    channel: ChannelType,
    options: rawptr, /* splay tree of global options */
    profile: rawptr, 
    synchronize: MagickBooleanType,
    progress_monitor: MagickProgressMonitor,
    client_data, cache: rawptr,
    stream: StreamHandler,
    file: ^c.FILE,
    blob: rawptr,
    length: c.size_t,
    magick: [MagickPathExtent]c.char, /* image file format (file magick) */
    unique: [MagickPathExtent]c.char, /* unique temporary filename - delegates */
    filename: [MagickPathExtent]c.char, /* filename when reading/writing image */
    debug: MagickBooleanType,
    signature: c.size_t,
    custom_stream: ^CustomStreamInfo,
    matte_color: PixelInfo
}

Image :: struct {
    storage_class: ClassType,
    colorspace: ColorspaceType,    /* colorspace of image data */
    compression: CompressionType,   /* compression of image when read/write */
    quality: c.size_t,          /* compression quality setting, meaning varies */
    orientation: OrientationType,   /* photo orientation of image */
    taint: MagickBooleanType, /* has image been modified since reading */
    columns, rows: c.size_t, /* physical size of image */
    depth: c.size_t, /* depth of image on read/write */
    colors: c.size_t, /* Size of color table, or actual color count Only valid if image is not DirectClass */
    colormap: ^PixelInfo,
    alpha_color: PixelInfo, /* deprecated */
    background_color: PixelInfo, /* current background color attribute */
    border_color: PixelInfo, /* current bordercolor attribute */
    transparent_color: PixelInfo,
    gamma: c.double,
    chromaticity: ChromaticityInfo,
    rendering_intent: RenderingIntent,
    profiles: rawptr,
    units: ResolutionType,
    montage, directory, geometry: ^c.char,
    offset: c.ssize_t, /* ??? */
    resolution: PointInfo, /* image resolution/density */
    page: RectangleInfo, /* virtual canvas size and offset of image */
    extract_info: RectangleInfo,
    fuzz: c.double, /* current color fuzz attribute - move to image_info */
    filter: FilterType, /* resize/distort filter to apply */
    intensity: PixelIntensityMethod, /* method to generate an intensity value from a pixel */
    interlace: InterlaceType,
    endian: EndianType, /* raw data integer ordering on read/write */
    gravity: GravityType, /* Gravity attribute for positioning in image */
    compose: CompositeOperator, /* alpha composition method for layered images */
    dispose: DisposeType, /* GIF animation disposal method */
    scene: c.size_t, /* index of image in multi-image file */
    delay: c.size_t, /* Animation delay time */
    duration: c.size_t, /* Total animation duration sum(delay*iterations) */
    ticks_per_second: c.ssize_t, /* units for delay time, default 100 for GIF */
    iteration: c.size_t, /* number of interactions for GIF animations */
    total_colors: c.size_t,
    start_loop: c.ssize_t, /* ??? */
    interpolate: PixelInterpolateMethod, /* Interpolation of color for between pixel lookups */
    black_point_compensation: MagickBooleanType,
    tile_offset: RectangleInfo,
    type: ImageType,
    dither: MagickBooleanType, /* dithering on/off */
    extent: MagickSizeType, /* Size of image read from disk */
    ping: MagickBooleanType, /* no image data read, just attributes */
    read_mask, write_mask: MagickBooleanType,
    alpha_trait: PixelTrait, /* is transparency channel defined and active */
    number_channels, number_meta_channels, metacontent_extent: c.size_t,
    channel_mask: ChannelType,
    channel_map: ^PixelChannelMap,
    cache: rawptr,
    error: ErrorInfo,
    timer: TimerInfo,
    progress_monitor: MagickProgressMonitor,
    client_data: rawptr,
    ascii85: ^Ascii85Info,
    generic_profile: ^ProfileInfo,
    properties: rawptr, /* general settings, to save with image */
    artifacts: rawptr, /* general operational/coder settings, not saved */
    filename: [MagickPathExtent]c.char, /* images input filename */
    magick_filename: [MagickPathExtent]c.char, /* given image filename (with read mods) */
    magick: [MagickPathExtent]c.char, /* images file format (file magic) */
    magick_rows, magick_columns: c.size_t, /* size of image when read/created */
    blob: ^BlobInfo,
    timestamp: libc.time_t,
    debug: MagickBooleanType,
    reference_count: c.ssize_t,
    semaphore: ^SemaphoreInfo,

    /* 
        (Optional) Image belongs to this ImageInfo 'list'
        * For access to 'global options' when no per-image
        * attribute, prosperity, or artifact has been set.
    */
    image_info: ^ImageInfo,
    list: ^Image, /* Undo/Redo image processing list (for display) */
    previous: ^Image, /* Image list links */
    next: ^Image,
    signature: c.size_t,
    matte_color: PixelInfo,
    composite_mask: MagickBooleanType,
    mask_trait: PixelTrait,
    channels: ChannelType,
    ttl: libc.time_t,
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
foreign lib {
    // MagickCore
    // MagickCore/magick.h
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

    // MagickCore/exception.h
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

    // MagickCore/option.h
    ParseChannelOption :: proc(channels: cstring) -> c.ssize_t --- 

    // MagickWand
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
    MagickSetOption :: proc(wand: ^MagickWand, value: cstring) -> MagickBooleanType ---
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