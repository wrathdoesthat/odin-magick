package odin_magick

import "core:c"

@(default_calling_convention="c")
foreign magick_core { 
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

    // MagickCore/property.h
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