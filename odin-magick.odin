package odin_magick

/* 
    Most of the code is from the "development headers" that get installed with the windows installer
    some of it is from the github as some structs dont have full definitions in the development headers
    (so they will be from .c files instead of .h)

    Set the #config variable DISABLE_MAGICK_WAND to true to not link/include the MagickWand lbiraries and only use MagickCore
*/

import "core:c"
import "core:c/libc"
import "core:sys/windows"

DISABLE_MAGICK_WAND :: #config(DISABLE_MAGICK_WAND, false)

when ODIN_OS == .Windows {
	@(export) foreign import magick_core {"./lib/CORE_RL_MagickCore_.lib"}
    when !DISABLE_MAGICK_WAND {
        @(export) foreign import magick_wand {"./lib/CORE_RL_MagickWand_.lib"}
    }

    // MagickCore/thread-private.h line 43
    MagickMutexType :: windows.CRITICAL_SECTION 

    // MagickCore/thread_.h line 31
    MagickThreadType :: windows.DWORD

    // TODO: apparently 8 on MSVC but im not really sure
    LongDoubleByteSize :: 8
} else when ODIN_OS == .Linux {
    @(export) foreign import magick_core {"system:MagickCore-7.Q16HDRI"} 
    when !DISABLE_MAGICK_WAND {
        @(export) foreign import magick_wand { "system:MagickWand-7.Q16HDRI"}
    }

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

// MagickCore/Magick-type.h
MagickFloatType :: c.float
MagickOffsetType :: c.longlong
MagickSizeType  :: c.ulonglong
MagickDoubleType :: c.double
MagickRealType  :: MagickDoubleType

MagickStatusType :: c.uint

Quantum :: MagickFloatType

// This is in MagicKWand but its needed by some of the core somehow
// MagickWand/method-attribute.h
MagickPathExtent : c.int : 4096

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

// MagickCore/stream.c
StreamInfo :: struct {
    image_info: ^ImageInfo,
    image: ^Image,
    stream: ^Image,
    quantum_info: ^QuantumInfo,
    map_: cstring,
    storage_type: StorageType,
    pixels: ^c.uchar,
    extract_info: RectangleInfo,
    y: c.ssize_t,
    exception: ^ExceptionInfo,
    client_data: rawptr,
    signature: c.size_t
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
MaximumNumberOfImageMoments :: 8
MaximumNumberOfPerceptualColorspaces :: 6
MaximumNumberOfPerceptualHashes :: 7

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

ChannelMoments :: struct {
    invariant: [MaximumNumberOfImageMoments+1]c.double,
    centroid, ellipse_axis: PointInfo,
    ellipse_angle, elllipse_eccentricity, ellipse_intensity: c.double
}

ChannelPerceptualHash :: struct {
    srgb_hu_phash, hclp_hu_phash: [MaximumNumberOfImageMoments+1]c.double,
    number_colorspace: c.size_t,
    colorspace: [MaximumNumberOfPerceptualColorspaces+1]ColorspaceType,
    phash: [MaximumNumberOfPerceptualColorspaces+1][+MaximumNumberOfImageMoments+1]c.double,
    number_channels: c.size_t
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

GeometryFlags :: enum c.int {
    NoValue = 0x0000,
    XValue = 0x0001,
    XiValue = 0x0001,
    YValue = 0x0002,
    PsiValue = 0x0002,
    WidthValue = 0x0004,
    RhoValue = 0x0004,
    HeightValue = 0x0008,
    SigmaValue = 0x0008,
    ChiValue = 0x0010,
    XiNegative = 0x0020,
    XNegative = 0x0020,
    PsiNegative = 0x0040,
    YNegative = 0x0040,
    ChiNegative = 0x0080,
    PercentValue = 0x1000,       /* '%'  percentage of something */
    AspectValue = 0x2000,        /* '!'  resize no-aspect - special use flag */
    NormalizeValue = 0x2000,     /* '!'  ScaleKernelValue() in morphology.c */
    LessValue = 0x4000,          /* '<'  resize smaller - special use flag */
    GreaterValue = 0x8000,       /* '>'  resize larger - spacial use flag */
    MinimumValue = 0x10000,      /* '^'  special handling needed */
    CorrelateNormalizeValue = 0x10000, /* '^' see ScaleKernelValue() */
    AreaValue = 0x20000,         /* '@'  resize to area - special use flag */
    DecimalValue = 0x40000,      /* '.'  floating point numbers found */
    SeparatorValue = 0x80000,    /* 'x'  separator found */
    AspectRatioValue = 0x100000, /* '~'  special handling needed */
    AlphaValue = 0x200000,       /* '/'  alpha */
    MaximumValue = 0x400000,     /* '#'  special handling needed */
    AllValues = 0x7fffffff
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

// MagickCore/string_.h
StringInfo :: struct {
    path: cstring,
    datum: ^c.uchar,
    length, signature: c.size_t,
    name: cstring
}

// MagickCore/configure.h
ConfigureInfo :: struct {
    path, name, value: cstring,
    exempt, stealth: MagickBooleanType,
    signature: c.size_t
}

// MagickCore/linked-list-private.h
ElementInfo :: struct {
    value: rawptr,
    next: ^ElementInfo
}

// MagickCore/linked-list.c
LinkedListInfo :: struct {
    capacity, elements: c.size_t,
    head, tail, next: ^ElementInfo,
    semaphore: ^SemaphoreInfo,
    signature: c.size_t
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

TypeInfo :: struct {
    face: c.size_t,
    path, name, description, family: cstring,
    style: StyleType,
    weight: c.size_t,
    encoding, foundry, formats, metrics, glyphs: cstring,
    stealth: MagickBooleanType,
    signature: c.size_t
}

// MagickCore/cache-private.h
NexusInfo :: struct {
    mapped: MagickBooleanType,
    region: RectangleInfo,
    length: MagickSizeType,
    cache, pixels: ^Quantum,
    authentic_pixel_cache: MagickBooleanType,
    metacontent: rawptr,
    signature: c.size_t,
    virtual_nexus: ^NexusInfo
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

CacheView :: struct {
    image: ^Image,
    virtual_pixel_method: VirtualPixelMethod,
    number_threads: c.size_t,
    nexus_info: ^^NexusInfo,
    debug: MagickBooleanType,
    signature: c.size_t
}

// MagickCore/decorate.h
FrameInfo :: struct {
    width, height: c.size_t,
    x, y, inner_evel, outer_bevel : c.ssize_t
}

// MagickCore/delegate.h
DelegateInfo :: struct {
    path, decode, encode, commands: cstring,
    mode: c.ssize_t,
    thread_support, spawn, stealth: MagickBooleanType,
    semaphore: ^SemaphoreInfo,
    signature: c.size_t
}

// MagickCore/quantize.h
QuantizeInfo :: struct {
    number_colors: c.size_t,
    tree_depth: c.size_t,
    colorspace: ColorspaceType,
    dither_method: DitherMethod,
    measure_error: MagickBooleanType,
    signature: c.size_t
}

// MagickCore/quantum.h
EndianType :: enum c.int {
    UndefinedEndian,
    LSBEndian,
    MSBEndian
}

QuantumFormatType :: enum c.int {
    UndefinedQuantumFormat,
    FloatingPointQuantumFormat,
    SignedQuantumFormat,
    UnsignedQuantumFormat
}

QuantumAlphaType :: enum c.int {
    UndefinedQuantumAlpha,
    AssociatedQuantumAlpha,
    DisassociatedQuantumAlpha
}

// MagickCore/quantum-private.h
QuantumState :: struct {
    inverse_scale: c.double,
    pixel: c.uint,
    bits: c.size_t,
    mask: ^c.uint
}

QuantumInfo :: struct {
    depth, quantum: c.size_t,
    format: QuantumFormatType, 
    minimum, maximum, scale: c.double,
    pad: c.size_t,
    min_is_white, pack: MagickBooleanType,
    alpha_type: QuantumAlphaType,
    number_threads: c.size_t,
    pixels: ^^MemoryInfo,
    extent: c.size_t,
    endian: EndianType,
    state: QuantumState,
    semaphore: ^SemaphoreInfo,
    signature: c.size_t,
    meta_channel: c.size_t
}

// MagickCore/memory.c
VirtualMemoryType :: enum c.int {
    UndefinedVirtualMemory,
    AlignedVirtualMemory,
    MapVirtualMemory,
    UnalignedVirtualMemory
}

MemoryInfo :: struct {
    filename: [MagickPathExtent]c.char,
    type: VirtualMemoryType,
    length: c.size_t,
    blob: rawptr,
    signature: c.size_t
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

PrimitiveType :: enum c.int {
    UndefinedPrimitive,
    AlphaPrimitive,
    ArcPrimitive,
    BezierPrimitive,
    CirclePrimitive,
    ColorPrimitive,
    EllipsePrimitive,
    ImagePrimitive,
    LinePrimitive,
    PathPrimitive,
    PointPrimitive,
    PolygonPrimitive,
    PolylinePrimitive,
    RectanglePrimitive,
    RoundRectanglePrimitive,
    TextPrimitive
}

PaintMethod :: enum c.int {
    UndefinedMethod,
    PointMethod,
    ReplaceMethod,
    FloodfillMethod,
    FillToBorderMethod,
    ResetMethod
}

TypeMetric :: struct {
    pixels_per_em: PointInfo,
    ascent, descent, width, height, max_advance, underline_position, underline_thickness : c.double,
    bounds: SegmentInfo,
    origin: PointInfo
}

PrimitiveInfo :: struct {
    point: PointInfo,
    coordinates: c.size_t,
    primitive: PrimitiveType,
    method: PaintMethod,
    text: cstring,
    closed_subpath: MagickBooleanType
}

// log.c
LogHandlerType :: enum c.int {
    UndefinedHandler = 0x0000,
    NoHandler = 0x0000,
    ConsoleHandler = 0x0001,
    StdoutHandler = 0x0002,
    StderrHandler = 0x0004,
    FileHandler = 0x0008,
    DebugHandler = 0x0010,
    EventHandler = 0x0020,
    MethodHandler = 0x0040
}

LogInfo :: struct {
    event_mask: LogEventType,
    handler_mask: LogHandlerType,
    path, name, filename, format: string,
    generations: c.size_t,
    file: ^c.FILE,
    append, stealth: MagickBooleanType,
    limit: MagickSizeType,
    timer: TimerInfo,
    method: MagickLogMethod,
    event_semaphore: ^SemaphoreInfo,
    signature: c.size_t
}

// log.h
LogEventType :: enum c.int {
    UndefinedEvents = 0x000000,
    NoEvents = 0x00000,
    AccelerateEvent = 0x00001,
    AnnotateEvent = 0x00002,
    BlobEvent = 0x00004,
    CacheEvent = 0x00008,
    CoderEvent = 0x00010,
    ConfigureEvent = 0x00020,
    DeprecateEvent = 0x00040,
    DrawEvent = 0x00080,
    ExceptionEvent = 0x00100,   /* Log Errors and Warnings immediately */
    ImageEvent = 0x00200,
    LocaleEvent = 0x00400,
    ModuleEvent = 0x00800,      /* Log coder and filter modules */
    PixelEvent = 0x01000,
    PolicyEvent = 0x02000,
    ResourceEvent = 0x04000,
    TraceEvent = 0x08000,
    TransformEvent = 0x10000,
    UserEvent = 0x20000,
    WandEvent = 0x40000,        /* Log MagickWand */
    X11Event = 0x80000,
    CommandEvent = 0x100000,    /* Log Command Processing (CLI & Scripts) */
    AllEvents = 0x7fffffff
}

MagickLogMethod :: #type proc(LogEventType, cstring)

// MagickCore/cache.h
CacheType :: enum c.int {
    UndefinedCache,
    DiskCache,
    DistributedCache,
    MapCache,
    MemoryCache,
    PingCache
}

// MagickCore/matrix.c
MatrixInfo :: struct {
    type: CacheType,
    columns, rows, stride: c.size_t,
    length: MagickSizeType,
    mapped, synchronize: MagickBooleanType,
    path: [MagickPathExtent]c.char,
    file: c.int,
    elements: rawptr,
    semaphore: ^SemaphoreInfo,
    signature: c.size_t
}

// MagickCore/signature.c
SignatureInfo :: struct {
    digestsize, blocksize: c.uint,
    digest, message: ^StringInfo,
    accumulator: ^c.uint,
    low_order, high_order: c.uint,
    extent: c.size_t,
    lsb_first: MagickBooleanType,
    timestamp: libc.time_t,
    signature: c.size_t
}

// MagickCore/random.c
RandomInfo :: struct {
    signature_info: ^SignatureInfo,
    nonce, reservoir: ^StringInfo,
    i: c.size_t,
    seed: [4]MagickSizeType,
    normalize: c.double,
    secret_key: c.ulong,
    protocol_major, protocol_minor: c.ushort,
    semaphore: ^SemaphoreInfo,
    timestamp: libc.time_t,
    signature: c.size_t
}

// MagickCore/resample.c

// TODO: figure out if used
/* 
    #if ! FILTER_DIRECT
    #define WLUT_WIDTH 1024       /* size of the filter cache */
    #endif
*/
WLUT_WIDTH :: 1024

ResampleFilter :: struct {
    view: ^CacheView,
    image: ^Image,
    exception: ^ExceptionInfo,
    debug: MagickBooleanType,
    image_area: c.ssize_t,
    interpolate: PixelInterpolateMethod,
    virtual_pixel: VirtualPixelMethod,
    filter: FilterType,
    limit_reached, do_interpolate, average_defined: MagickBooleanType,
    average_pixel: PixelInfo,
    A, B, C, Vlimit, Ulimit, Uwidth, slope: c.double,

/* 
    TODO: see above
    #if FILTER_LUT
    /* LUT of weights for filtered average in elliptical area */
    double
    filter_lut[WLUT_WIDTH];
    #else
    /* Use a Direct call to the filter functions */
    ResizeFilter
    *filter_def;

    double
    F;
    #endif
*/

    filter_lut: [WLUT_WIDTH]c.double,
    support: c.double,
    signature: c.size_t
}

// MagickCore/resize-private.h
ResizeWeightingFunctionType :: enum c.int {
    BoxWeightingFunction = 0,
    TriangleWeightingFunction,
    CubicBCWeightingFunction,
    HannWeightingFunction,
    HammingWeightingFunction,
    BlackmanWeightingFunction,
    GaussianWeightingFunction,
    QuadraticWeightingFunction,
    JincWeightingFunction,
    SincWeightingFunction,
    SincFastWeightingFunction,
    KaiserWeightingFunction,
    WelchWeightingFunction,
    BohmanWeightingFunction,
    LagrangeWeightingFunction,
    CosineWeightingFunction,
    MagicKernelSharpWeightingFunction,
    LastWeightingFunction
}

// MagickCore/resize.c
ResizeFilter :: struct {
    filter: proc(c.double, ^ResizeFilter),
    window: proc(c.double, ^ResizeFilter),
    support, window_support, scale, blur: c.double,
    coeffiecient: [7]c.double,
    filterWeightingType, windowWeightingType: ResizeWeightingFunctionType,
    signature: c.size_t
}

// MagickCore/memory_.h
AcquireMemoryHandler :: #type proc(size: c.size_t) -> rawptr
DestroyMemoryHandler :: #type proc(memory: rawptr)
ResizeMemoryHandler :: #type proc(memory: rawptr, size: c.size_t) -> rawptr

// TODO: figure out what the parameters for this actually are
AcquireAlignedMemoryHandler :: #type proc(c.size_t, c.size_t) -> rawptr
RelinquishAlignedMemory :: #type proc(memory: rawptr)

// MagickCore/option.h
CommandOption :: enum c.int {
    MagickUndefinedOptions = -1,
    MagickAlignOptions = 0,
    MagickAlphaChannelOptions,
    MagickBooleanOptions,
    MagickCacheOptions,
    MagickChannelOptions,
    MagickClassOptions,
    MagickClipPathOptions,
    MagickCoderOptions,
    MagickColorOptions,
    MagickColorspaceOptions,
    MagickCommandOptions,
    MagickComplexOptions,
    MagickComplianceOptions,
    MagickComposeOptions,
    MagickCompressOptions,
    MagickConfigureOptions,
    MagickDataTypeOptions,
    MagickDebugOptions,
    MagickDecorateOptions,
    MagickDelegateOptions,
    MagickDirectionOptions,
    MagickDisposeOptions,
    MagickDistortOptions,
    MagickDitherOptions,
    MagickEndianOptions,
    MagickEvaluateOptions,
    MagickFillRuleOptions,
    MagickFilterOptions,
    MagickFontOptions,
    MagickFontsOptions,
    MagickFormatOptions,
    MagickFunctionOptions,
    MagickGradientOptions,
    MagickGravityOptions,
    MagickIntensityOptions,
    MagickIntentOptions,
    MagickInterlaceOptions,
    MagickInterpolateOptions,
    MagickKernelOptions,
    MagickLayerOptions,
    MagickLineCapOptions,
    MagickLineJoinOptions,
    MagickListOptions,
    MagickLocaleOptions,
    MagickLogEventOptions,
    MagickLogOptions,
    MagickMagicOptions,
    MagickMethodOptions,
    MagickMetricOptions,
    MagickMimeOptions,
    MagickModeOptions,
    MagickModuleOptions,
    MagickMorphologyOptions,
    MagickNoiseOptions,
    MagickOrientationOptions,
    MagickPixelChannelOptions,
    MagickPixelIntensityOptions,
    MagickPixelMaskOptions,
    MagickPixelTraitOptions,
    MagickPolicyOptions,
    MagickPolicyDomainOptions,
    MagickPolicyRightsOptions,
    MagickPreviewOptions,
    MagickPrimitiveOptions,
    MagickQuantumFormatOptions,
    MagickResolutionOptions,
    MagickResourceOptions,
    MagickSparseColorOptions,
    MagickStatisticOptions,
    MagickStorageOptions,
    MagickStretchOptions,
    MagickStyleOptions,
    MagickThresholdOptions,
    MagickTypeOptions,
    MagickValidateOptions,
    MagickVirtualPixelOptions,
    MagickWeightOptions,
    MagickAutoThresholdOptions,
    MagickToolOptions,
    MagickCLIOptions,
    MagickIlluminantOptions,
    MagickWordBreakOptions,
    MagickPagesizeOptions
}

ValidateType :: enum c.int {
    UndefinedValidate,
    NoValidate = 0x00000,
    ColorspaceValidate = 0x00001,
    CompareValidate = 0x00002,
    CompositeValidate = 0x00004,
    ConvertValidate = 0x00008,
    FormatsDiskValidate = 0x00010,
    FormatsMapValidate = 0x00020,
    FormatsMemoryValidate = 0x00040,
    IdentifyValidate = 0x00080,
    ImportExportValidate = 0x00100,
    MontageValidate = 0x00200,
    StreamValidate = 0x00400,
    MagickValidate = 0x00800,
    AllValidate = 0x7fffffff
}

CommandOptionFlags :: enum c.int {
    UndefinedOptionFlag       = 0x0000,  /* option flag is not in use */
    ImageInfoOptionFlag       = 0x0001,  /* Setting stored in ImageInfo */
    DrawInfoOptionFlag        = 0x0002,  /* Setting stored in DrawInfo */
    QuantizeInfoOptionFlag    = 0x0004,  /* Setting stored in QuantizeInfo */
    GlobalOptionFlag          = 0x0008,  /* Global Setting or Control */
    SettingOptionFlags        = 0x000F,  /* mask any setting option */
    NoImageOperatorFlag       = 0x0010,  /* Images not required operator */
    SimpleOperatorFlag        = 0x0020,  /* Simple Image processing operator */
    ListOperatorFlag          = 0x0040,  /* Multi-Image processing operator */
    GenesisOptionFlag         = 0x0080,  /* MagickCommandGenesis() Only Option */
    SpecialOptionFlag         = 0x0100,  /* Operator with Special Requirements EG: for specific CLI commands */
    AlwaysInterpretArgsFlag   = 0x0400,  /* Always Interpret escapes in Args CF: "convert" compatibility mode */
    NeverInterpretArgsFlag    = 0x0800,  /* Never Interpret escapes in Args EG: filename, or delayed escapes */
    NonMagickOptionFlag       = 0x1000,  /* Option not used by Magick Command */
    FireOptionFlag            = 0x2000,  /* Convert operation seq firing point */
    DeprecateOptionFlag       = 0x4000,  /* Deprecate option (no code) */
    ReplacedOptionFlag        = 0x8800   /* Replaced Option (but still works) */
}

OptionInfo :: struct {
    mnemonic: cstring,
    type, flags: c.ssize_t, 
    stealth: MagickBooleanType
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

MontageInfo :: struct {
    geometry, tile, title, frame, texture, font: cstring,
    pointsize: c.double,
    border_width: c.size_t,
    shadow: MagickBooleanType,
    alpha_color, background_color, border_color, fill, stroke: PixelInfo,
    gravity: GravityType,
    filename: [MagickPathExtent]c.char,
    debug: MagickBooleanType,
    signature: c.size_t,
    matte_color: PixelInfo
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