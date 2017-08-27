//
//  TXSakuraManager.m
//  SakuraKit
//
//  Created by tingxins on 23/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//
#define TXSakuraRGBHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#import "TXSakuraManager.h"
#import "ZipArchive.h"
#import <objc/runtime.h>


/***********/
UIKIT_EXTERN char *const kTXSakuraSELHeader;
UIKIT_EXTERN char *const kTXSakuraSELCon;
UIKIT_EXTERN NSString *const kTXSakura2DStateSELTail;
UIKIT_EXTERN NSString *const kTXSakura2DAnimatedSELTail;

// 参数类型
UIKIT_EXTERN NSString *const kTXSakuraArgBool;
UIKIT_EXTERN NSString *const kTXSakuraArgFloat;
UIKIT_EXTERN NSString *const kTXSakuraArgCustomInt;
UIKIT_EXTERN NSString *const kTXSakuraArgColor;
UIKIT_EXTERN NSString *const kTXSakuraArgCGColor;
UIKIT_EXTERN NSString *const kTXSakuraArgFont;
UIKIT_EXTERN NSString *const kTXSakuraArgImage;
UIKIT_EXTERN NSString *const kTXSakuraArgTextAttributes;
UIKIT_EXTERN NSString *const kTXSakuraArgStatusBarStyle;
UIKIT_EXTERN NSString *const kTXSakuraArgBarStyle;
UIKIT_EXTERN NSString *const kTXSakuraArgTitle;
UIKIT_EXTERN NSString *const kTXSakuraArgKeyboardAppearance;
UIKIT_EXTERN NSString *const kTXSakuraActivityIndicatorViewStyle;
/***********/

UIKIT_EXTERN NSString *const TXSakuraSkinChangeNotification;

// Default sakura name.
TXSakuraName *const kTXSakuraDefault = @"default";

// Format of config files
static NSString *const kTXFileExtensionJSON = @"json";
static NSString *const kTXFileExtensionPLIST = @"plist";
static NSString *const kTXFileExtensionZIP = @"zip";
// Format of image files
static NSString *const kTXImageExtensionPNG = @"png";
static NSString *const kTXImageExtensionJPG = @"jpg";

static NSString *const kTXSakuraCurrentName = @"com.tingxins.sakura.current.name";
static NSString *const kTXSakuraCurrentType = @"com.tingxins.sakura.current.type";
static NSString *const kTXSakuraManagerLockName = @"com.tingxins.sakura.manager.lock";


/** Just an agent for each download task! */
@interface TXSakuraDownloadTaskDelegateWrapper: NSObject <NSURLSessionDownloadDelegate>

@property (weak, nonatomic) TXSakuraManager *manager;
@property (strong, nonatomic) id<TXSakuraDownloadDelegate> delegate;
@property (strong, nonatomic) id<TXSakuraDownloadProtocol> sakuraDownloadInfos;

@property (nonatomic, copy) TXSakuraDownloadProgressHandler downloadProgressHandler;
@property (nonatomic, copy) TXSakuraErrorHandler downloadErrorHandler;
@property (nonatomic, copy) TXSakuraUnzipProgressHandler unzipProgressHandler;
@property (nonatomic, copy) TXSakuraDownloadCompletedHandler completedHandler;

- (instancetype)initWithManager:(TXSakuraManager *)manager
                       delegate:(id<TXSakuraDownloadDelegate>)delegate
            sakuraDownloadInfos:(id<TXSakuraDownloadProtocol>)sakuraDownloadInfos;

- (instancetype)initWithManager:(TXSakuraManager *)manager
            sakuraDownloadInfos:(id<TXSakuraDownloadProtocol>)sakuraDownloadInfos
                progressHandler:(TXSakuraDownloadProgressHandler)downloadProgressHandler
                   errorHandler:(TXSakuraErrorHandler)errorHandler
           unzipProgressHandler:(TXSakuraUnzipProgressHandler)unzipProgressHandler
               completedHandler:(TXSakuraDownloadCompletedHandler)completedHandler;

+ (instancetype)wrapperWithManager:(TXSakuraManager *)manager
                          delegate:(id<TXSakuraDownloadDelegate>)delegate
               sakuraDownloadInfos:(id<TXSakuraDownloadProtocol>)sakuraDownloadInfos;

+ (instancetype)wrapperWithManager:(TXSakuraManager *)manager
               sakuraDownloadInfos:(id<TXSakuraDownloadProtocol>)sakuraDownloadInfos
                   progressHandler:(TXSakuraDownloadProgressHandler)downloadProgressHandler
                      errorHandler:(TXSakuraErrorHandler)errorHandler
              unzipProgressHandler:(TXSakuraUnzipProgressHandler)unzipProgressHandler
                  completedHandler:(TXSakuraDownloadCompletedHandler)completedHandler;

@end

@interface TXSakuraManager()<SSZipArchiveDelegate>
/** For cancel task！ */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSURLSessionDownloadTask *> *sakuraDownloadTaskCache;
/** Task wrappers. */
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,  TXSakuraDownloadTaskDelegateWrapper*> *sakuraDownloadTaskDelegateWrappersByIdentifier;
/** Just lock. */
@property (nonatomic, strong) NSLock *lock;
@end

@implementation TXSakuraManager
/** Resources Path */
static NSString *_resourcesPath;
/** Configs file of resources */
static NSString *_configsFilePath;
/** Share instance */
static TXSakuraManager *_manager;
/** Bundle or Sandbox */
static TXSakuraType _currentSakuraType;
/** Current name of sakura  */
static TXSakuraName *_currentSakuraName;
/** Reserved for future use */
static NSMutableArray<TXSakuraName *> *_localSakuras;

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Please use + manager: method instead." userInfo:nil];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}

- (instancetype)initWithTaskCacheAndDelegateWrappers{
    if (self = [super init]) {
        self.sakuraDownloadTaskCache = [NSMutableDictionary dictionary];
        self.sakuraDownloadTaskDelegateWrappersByIdentifier = [NSMutableDictionary dictionary];
        
        NSLock *lock = [[NSLock alloc] init];
        lock.name = kTXSakuraManagerLockName;
        self.lock = lock;
    }
    return self;
}

+ (instancetype)_taskCacheAndDelegateWrappers {
    return [[self alloc] initWithTaskCacheAndDelegateWrappers];
}

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [TXSakuraManager _taskCacheAndDelegateWrappers];
    });
    return _manager;
}

+ (void)formatSakuraPath:(NSString *)sakuraPath cleanCachePath:(NSString * _Nullable)cachePath {
    if (!sakuraPath || !sakuraPath.length) return;
    if (cachePath) {
        [TXSakuraManager tx_clearSakuraCacheWithPath:cachePath];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *folders = [fileManager contentsOfDirectoryAtPath:sakuraPath error:&error];
    NSString *folderName = sakuraPath.lastPathComponent;
    NSString *tempName = [folders.lastObject stringByAppendingString:folderName];
    NSString *moveItemPath = [sakuraPath stringByAppendingPathComponent:folders.lastObject];
    NSString *tempItemPath = [[sakuraPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:tempName];
    [fileManager moveItemAtPath:moveItemPath toPath:tempItemPath error:&error];
    [fileManager removeItemAtPath:sakuraPath error:&error];
    [fileManager moveItemAtPath:tempItemPath toPath:sakuraPath error:&error];
#ifdef DEBUG
    NSLog(@"folders:%@", folders);
    NSLog(@"sakuraPath:%@--%@",sakuraPath, error);
#endif
}

+ (BOOL)shiftSakuraWithName:(TXSakuraName *)name type:(TXSakuraType)type {
    if (name &&
        [name isEqualToString:_currentSakuraName]) return NO;
    if (!name) name = kTXSakuraDefault;
    switch (type) {
        case TXSakuraTypeMainBundle:
            _resourcesPath = nil;
            _configsFilePath = [self tx_getSakuraConfigsFileBundlePathWithName:name];
            break;
        case TXSakuraTypeSandbox:{
            _resourcesPath = [self tx_getSakuraResourceSandboxPathWithName:name];
            _configsFilePath = [self tx_tryGetSakuraConfigsFileSandboxPathWithName:name];
            if (!_configsFilePath.length && _resourcesPath.length) {
                _configsFilePath = [self tx_getSakuraConfigsFileBundlePathWithName:kTXSakuraDefault];
            }
        }
            break;
        default:
            break;
    }
    
    if (_configsFilePath.length) {
        [self saveCurrentSakuraInfosWithName:name type:type];
        [[NSNotificationCenter defaultCenter] postNotificationName:TXSakuraSkinChangeNotification object:nil];
        return YES;
    }
#ifdef DEBUG
    else {
        NSLog(@"resources not exists!");
    }
    NSLog(@"%@", _configsFilePath);
#endif
    return NO;
}


/**
 Save informations of current sakura

 @param name Current sakura name
 @param type Current sakura type
 */
+ (void)saveCurrentSakuraInfosWithName:(TXSakuraName *)name type:(TXSakuraType)type {
    _currentSakuraName = name;
    _currentSakuraType = type;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_currentSakuraName forKey:kTXSakuraCurrentName];
    [userDefaults setObject:@(_currentSakuraType) forKey:kTXSakuraCurrentType];
    [userDefaults synchronize];
}

+ (TXSakuraType)getSakuraCurrentType {
    if (_currentSakuraType) {
        return _currentSakuraType;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    TXSakuraType currentSakuraType = [[userDefaults objectForKey:kTXSakuraCurrentType] integerValue];
    return currentSakuraType;
}

+ (TXSakuraName *)getSakuraCurrentName {
    if (_currentSakuraName && _currentSakuraName.length) {
        return _currentSakuraName;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    TXSakuraName *currentSakuraName = [userDefaults objectForKey:kTXSakuraCurrentName];
    return currentSakuraName;
}

#pragma mark - Fetch Resource

+ (NSDictionary *)getSakuraConfigsFileData {
    NSDictionary *configsFile = [NSDictionary dictionaryWithContentsOfFile:_configsFilePath];
    if (!configsFile && _configsFilePath) {
        NSData *data = [NSData dataWithContentsOfFile:_configsFilePath];
        if (!data) return nil;
        configsFile = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
#ifdef DEBUG
        if (!configsFile) {
            NSLog(@"Maybe an error: %@ file content format!",[_configsFilePath lastPathComponent]);
        }
#endif
    }
    if (![configsFile isKindOfClass:[NSDictionary class]]) return nil;
    return configsFile;
}

#pragma mark - C Function

SEL getSelectorWithPattern(const char *prefix, const char *key, const char *suffix) {
    size_t prefixLength = prefix ? strlen(prefix) : 0;
    size_t suffixLength = suffix ? strlen(suffix) : 0;
    
    char initial = key[0];
    if (prefixLength) initial = (char)toupper(initial);
    size_t initialLength = 1;
    
    const char *rest = key + initialLength;
    size_t restLength = strlen(rest);
    
    char selector[prefixLength + initialLength + restLength + suffixLength + 1];
    memcpy(selector, prefix, prefixLength);
    selector[prefixLength] = initial;
    memcpy(selector + prefixLength + initialLength, rest, restLength);
    memcpy(selector + prefixLength + initialLength + restLength, suffix, suffixLength);
    selector[prefixLength + initialLength + restLength + suffixLength] = '\0';
    
    return sel_registerName(selector);
}

#pragma mark - Manual Sakura

+ (NSArray<TXSakuraName *> *)getLocalSakuraNames {
    return [_localSakuras copy];
}

+ (void)registerLocalSakuraWithNames:(NSArray<TXSakuraName *> *)names {
    if (!names || !names.count) return;
    _localSakuras = nil;
    if (!_localSakuras) {
        @synchronized(self) {
            _localSakuras = [NSMutableArray array];
        }
    }
    [_localSakuras addObjectsFromArray:names];
}

@end

@implementation TXSakuraManager(TXSerialization)

+ (NSDictionary *)tx_getObjVectorOperationKV {
    return @{
             kTXSakuraArgColor:@"tx_colorWithPath:",
             kTXSakuraArgCGColor:@"tx_cgColorWithPath:",
             kTXSakuraArgImage:@"tx_imageWithPath:",
             kTXSakuraArgFont:@"tx_fontWithPath:",
             kTXSakuraArgTextAttributes:@"tx_titleTextAttributesDictionaryWithPath:",
             kTXSakuraArgTitle:@"tx_stringWithPath:"
             };
}

+ (NSDictionary *)tx_getIntVectorOperationKV {
    return @{
             kTXSakuraArgBarStyle:@"tx_barStyleWithPath:",
             kTXSakuraArgStatusBarStyle:@"tx_statusBarStyleWithPath:",
             kTXSakuraActivityIndicatorViewStyle:@"tx_activityIndicatorStyleWithPath:",
             kTXSakuraArgKeyboardAppearance:@"tx_keyboardAppearanceWithPath:",
             kTXSakuraArgBool:@"tx_boolWithPath:"
             };
}

+ (NSDictionary *)tx_getFloatVectorOperationKV {
    return @{
             kTXSakuraArgFloat:@"tx_floatWithPath:"
             };
}

+ (UIColor *)tx_colorWithPath:(NSString *)path {
    NSString *colorHexStr = [[self getSakuraConfigsFileData] valueForKeyPath:path];
    if (!colorHexStr) return nil;
    return [self tx_colorFromString:colorHexStr];
}

+ (CGColorRef)tx_cgColorWithPath:(NSString *)path {
    UIColor *rgbColor = [self tx_colorWithPath:path];
    return rgbColor.CGColor;
}

+ (CGFloat)tx_floatWithPath:(NSString *)path {
    NSString *valueStr = [[self getSakuraConfigsFileData] valueForKeyPath:path];
    return [valueStr floatValue];
}

+ (BOOL)tx_boolWithPath:(NSString *)path {
    return [[[self getSakuraConfigsFileData] valueForKeyPath:path] boolValue];
}

+ (NSString *)tx_stringWithPath:(NSString *)path {
    return [[self getSakuraConfigsFileData] valueForKeyPath:path];
}

// UIImage from NSBundle or Sandbox
+ (UIImage *)tx_imageWithPath:(NSString *)path {
    NSString *imageName = [self tx_stringWithPath:path];
    UIImage *image = nil;
    if (imageName && imageName.length) {
        if (_currentSakuraType == TXSakuraTypeMainBundle) {
            image = [UIImage imageNamed:imageName];
        }else if (_currentSakuraType == TXSakuraTypeSandbox) {
            image = [self _getImagePathWithImageName:imageName fileType:kTXImageExtensionPNG];
            if (!image) {
                image = [self _getImagePathWithImageName:imageName fileType:kTXImageExtensionJPG];
            }
        }
    }
    if (image) return image;
    return [self _searchImageWithPath:path];
}

+ (UIFont *)tx_fontWithPath:(NSString *)path {
    CGFloat fontSize = [self tx_floatWithPath:path];
    if (!fontSize) return nil;
    return [UIFont systemFontOfSize:fontSize];
}

+ (NSDictionary *)tx_origDictionaryWithPath:(NSString *)path {
    return [[self getSakuraConfigsFileData] valueForKeyPath:path];
}

+ (NSDictionary *)tx_titleTextAttributesDictionaryWithPath:(NSString *)path {
    NSDictionary *origDict = [self tx_origDictionaryWithPath:path];
    NSMutableDictionary *factDict = [NSMutableDictionary dictionary];
    // 暂时只支持两种类型（Welcome PR ！）
    [origDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"NSForegroundColorAttributeName"]) {
            UIColor *color = [self tx_colorFromString:(NSString *)obj];
            [factDict setObject:color forKey:NSForegroundColorAttributeName];
        }else if ([key isEqualToString:@"NSFontAttributeName"]) {
            CGFloat fontValue = [obj floatValue];
            UIFont *font = [UIFont systemFontOfSize:fontValue];
            [factDict setObject:font forKey:NSFontAttributeName];
        }else {}
    }];
    return factDict;
}

+ (NSInteger)tx_integerWithPath:(NSString *)path {
    return [[[self getSakuraConfigsFileData] valueForKeyPath:path] integerValue];
}

+ (UIStatusBarStyle)tx_statusBarStyleWithPath:(NSString *)path {
    NSString *stateStr = [self tx_stringWithPath:path];
    if ([stateStr isKindOfClass:[NSNumber class]]) {
        return [self _enumValueWith:(NSNumber *)stateStr];
    }
    if (![stateStr isKindOfClass:[NSString class]]) return UIStatusBarStyleDefault;
    
    if ([stateStr isEqualToString:@"UIStatusBarStyleLightContent"]) {
        return UIStatusBarStyleLightContent;
    }else {
        return UIStatusBarStyleDefault;
    }
}

+ (UIBarStyle)tx_barStyleWithPath:(NSString *)path {
    NSString *barStyle = [self tx_stringWithPath:path];
    if ([barStyle isKindOfClass:[NSNumber class]]) {
        return [self _enumValueWith:(NSNumber *)barStyle];
    }
    if (![barStyle isKindOfClass:[NSString class]]) return UIBarStyleDefault;
    
    if ([barStyle isEqualToString:@"UIBarStyleBlack"]) {
        return UIBarStyleBlack;
    }else {
        return UIBarStyleDefault;
    }
}

+ (UIKeyboardAppearance)tx_keyboardAppearanceWithPath:(NSString *)path {
    NSString *kbAppearance = [self tx_stringWithPath:path];
    
    if ([kbAppearance isKindOfClass:[NSNumber class]]) {
        return [self _enumValueWith:(NSNumber *)kbAppearance];
    }
    if (![kbAppearance isKindOfClass:[NSString class]]) return UIKeyboardAppearanceDefault;
    
    if ([kbAppearance isEqualToString:@"UIKeyboardAppearanceLight"]) {
        return UIKeyboardAppearanceLight;
    }else if ([kbAppearance isEqualToString:@"UIKeyboardAppearanceDark"]) {
        return UIKeyboardAppearanceDark;
    }else {
        return UIKeyboardAppearanceDefault;
    }
}

+ (UIActivityIndicatorViewStyle)tx_activityIndicatorStyleWithPath:(NSString *)path {
    NSString *activityIndicatorStyle = [self tx_stringWithPath:path];
    
    if ([activityIndicatorStyle isKindOfClass:[NSNumber class]]) {
        return [self _enumValueWith:(NSNumber *)activityIndicatorStyle];
    }
    if (![activityIndicatorStyle isKindOfClass:[NSString class]]) return UIActivityIndicatorViewStyleWhite;
    
    if ([activityIndicatorStyle isEqualToString:@"UIActivityIndicatorViewStyleWhiteLarge"]) {
        return UIActivityIndicatorViewStyleWhiteLarge;
    }else if ([activityIndicatorStyle isEqualToString:@"UIActivityIndicatorViewStyleGray"]) {
        return UIActivityIndicatorViewStyleGray;
    }else {
        return UIActivityIndicatorViewStyleWhite;
    }
}

#pragma mark - Private

+ (NSUInteger)_enumValueWith:(NSNumber *)number {
    return [number unsignedIntegerValue];
}

+ (UIImage *)_getImagePathWithImageName:(NSString *)imageName fileType:(NSString *)fileType {
    NSString *imagePath = [_resourcesPath stringByAppendingPathComponent:[imageName stringByAppendingPathExtension:fileType]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

/** searching local resouces */
+ (UIImage *)_searchImageWithPath:(NSString *)path {
    NSArray *components = [path componentsSeparatedByString:@"."];
    NSString *component = [components lastObject];
    
    if ((component && [component isEqualToString:kTXImageExtensionPNG]) ||
        [component isEqualToString:kTXImageExtensionJPG]) {
        component = path;
    }
    
    if (component) {
        UIImage *localImage = [UIImage imageNamed:component];
        return localImage;
    }
    return nil;
}

@end

@implementation TXSakuraManager(TXTool)

+ (UIColor*)tx_colorFromString:(NSString*)hexStr {
    hexStr = [hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([hexStr hasPrefix:@"0x"]) {
        hexStr = [hexStr substringFromIndex:2];
    }
    if([hexStr hasPrefix:@"#"]) {
        hexStr = [hexStr substringFromIndex:1];
    }
    
    NSUInteger hex = [self _intFromHexString:hexStr];
    if(hexStr.length > 6) {
        return TXSakuraRGBHex(hex);
    }
    return TXSakuraRGBHex(hex);
}

#pragma mark - Private

+ (NSUInteger)_intFromHexString:(NSString *)hexStr {
    unsigned int hexInt = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    [scanner scanHexInt:&hexInt];
    return hexInt;
}

@end

static NSString *kTXSakuraDiretoryName = @"com.tingxins.sakura";

@implementation TXSakuraManager(TXDownload)

#pragma mark - Local sakura path operation(Public)

// Sakura
+ (NSString *)tx_getSakurasDirectoryPath {
    NSString *libraryPath = [self _getLibraryPath];
    NSString *path = [libraryPath stringByAppendingPathComponent:kTXSakuraDiretoryName];
    return path;
}

// Sakura/[folderName]
+ (NSString *)tx_getSakuraSandboxPathWithName:(NSString *)name {
    NSString *sakurasDirectoryPath = [self tx_getSakurasDirectoryPath];
    NSString *savePath = [sakurasDirectoryPath stringByAppendingPathComponent:name];
    return savePath;
}

// Sakura/[folderName]
+ (NSString *)tx_getSakuraResourceSandboxPathWithName:(NSString *)sakuraName {
    if (!sakuraName) return nil;
    NSString *fileFolder = [sakuraName stringByDeletingPathExtension];
    NSString *savePath = [self tx_getSakuraSandboxPathWithName:fileFolder];
    return savePath;
}

#pragma mark - File manager(Public)

// Catch local configs file in sandbox
+ (NSString *)tx_tryGetSakuraConfigsFileSandboxPathWithName:(NSString *)sakuraName {
    if (!sakuraName) return nil;
    NSString *configsFilePath = [self _filePathWithName:sakuraName type:kTXFileExtensionJSON];
    if (![self _fileExistsAtPath:configsFilePath]) {
        configsFilePath = [self _filePathWithName:sakuraName type:kTXFileExtensionPLIST];
        if (![self _fileExistsAtPath:configsFilePath]) return nil;
    }
    return configsFilePath;
}

// Catch local configs file in bundle
+ (NSString *)tx_getSakuraConfigsFileBundlePathWithName:(NSString *)sakuraName {
    NSString *configsFilepath = [[NSBundle mainBundle] pathForResource:sakuraName ofType:kTXFileExtensionPLIST];
    if (!configsFilepath) {
        configsFilepath = [[NSBundle mainBundle] pathForResource:sakuraName ofType:kTXFileExtensionJSON];
    }
    return configsFilepath;
}

#pragma mark - Cache operation(Public)

+ (NSArray *)tx_getSakurasList {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray<TXSakuraName *> *remoteItems = [fileManager contentsOfDirectoryAtPath:[self tx_getSakurasDirectoryPath] error:&error];
    NSMutableArray<TXSakuraName *> *mutableFileItems = [NSMutableArray array];
    [mutableFileItems addObject:kTXSakuraDefault];
    if (_localSakuras) {
        [mutableFileItems addObjectsFromArray:_localSakuras];
    }
    [mutableFileItems addObjectsFromArray:remoteItems];
#ifdef DEBUG
    NSLog(@"tx_getSakurasList error:%@", error);
#endif
    [mutableFileItems removeObject:@".DS_Store"];
    
    return mutableFileItems;
}

#pragma mark - Clear operation(Public)

+ (BOOL)tx_clearSakuraAllCaches {
    return [self tx_clearSakuraCacheWithName:nil pathHandler:^NSString *(NSString *name) {
        return [self tx_getSakurasDirectoryPath];
    }];
}

+ (BOOL)tx_clearSakuraCacheWithName:(NSString *)sakuraName {
    return [self tx_clearSakuraCacheWithName:sakuraName pathHandler:^NSString *(NSString *name) {
        return [self tx_getSakuraSandboxPathWithName:name];
    }];
}

+ (BOOL)tx_clearSakuraCacheWithName:(NSString *)sakuraName pathHandler:(NSString *(^)(NSString *))pathHandler {
    NSString *sakuraPath = pathHandler(sakuraName);
    return [self tx_clearSakuraCacheWithPath:sakuraPath];
}

+ (BOOL)tx_clearSakuraCacheWithPath:(NSString *)path {
    return [[TXSakuraManager manager] tx_clearSakuraCacheWithPath:path];
}

- (BOOL)tx_clearSakuraCacheWithPath:(NSString *)path {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL flag = YES;
    if ([fileManager fileExistsAtPath:path]) {
        flag = [fileManager removeItemAtPath:path error:&error];
        if (flag && [NSThread currentThread] == [NSThread mainThread]) {
            [TXSakuraManager shiftSakuraWithName:kTXSakuraDefault type:TXSakuraTypeMainBundle];
        }
    }
#ifdef DEBUG
    NSLog(@"tx_clearSakuraCacheWithName error:%@", error);
#endif
    return flag;
}

#pragma mark - Block download operation(Public)

- (NSURLSessionDownloadTask *)tx_sakuraDownloadWithInfos:(id<TXSakuraDownloadProtocol>)infos
                                  downloadProgressHandler:(TXSakuraDownloadProgressHandler)downloadProgressHandler
                                     downloadErrorHandler:(TXSakuraErrorHandler)downloadErrorHandler
                                     unzipProgressHandler:(TXSakuraUnzipProgressHandler)unzipProgressHandler
                                         completedHandler:(TXSakuraDownloadCompletedHandler)completedHandler {
    TXSakuraDownloadTaskStatus status;
    NSURLSessionDownloadTask *downloadTask = [self _sakuraDownloadWithInfos:infos status:&status];
    switch (status) {
        case TXSakuraDownloadTaskStatusAlreadyExist:{
            downloadErrorHandler([NSError errorWithDomain:@"This task already exist!" code:0 userInfo:@{@"status":@(status), @"task": downloadTask}]);
        }
            break;
        case TXSakuraDownloadTaskStatusDownloading:{
            downloadErrorHandler([NSError errorWithDomain:@"This task is downloading!" code:0 userInfo:@{@"status":@(status), @"task": downloadTask}]);
        }
            break;
            
        default:
            break;
    }
    if (downloadTask) {
        TXSakuraDownloadTaskDelegateWrapper *delegateWrapper = [TXSakuraDownloadTaskDelegateWrapper wrapperWithManager:self sakuraDownloadInfos:infos progressHandler:downloadProgressHandler errorHandler:downloadErrorHandler unzipProgressHandler:unzipProgressHandler completedHandler:completedHandler];
        self.sakuraDownloadTaskDelegateWrappersByIdentifier[@(downloadTask.taskIdentifier)] = delegateWrapper;
    }
    return downloadTask;
}

#pragma mark - Delegate download operation(Public)

- (NSURLSessionDownloadTask *)tx_sakuraDownloadWithInfos:(id<TXSakuraDownloadProtocol>)infos
                                                 delegate:(id<TXSakuraDownloadDelegate>)delegate {
    TXSakuraDownloadTaskStatus status;
    NSURLSessionDownloadTask *downloadTask = [self _sakuraDownloadWithInfos:infos status:&status];
    switch (status) {
        case TXSakuraDownloadTaskStatusAlreadyExist:{
            if (delegate && [delegate respondsToSelector:@selector(sakuraManagerDownload:downloadTask:status:)]) {
                [delegate sakuraManagerDownload:self downloadTask:nil status:TXSakuraDownloadTaskStatusAlreadyExist];
            }
        }
            break;
        case TXSakuraDownloadTaskStatusDownloading:{
            if (delegate && [delegate respondsToSelector:@selector(sakuraManagerDownload:downloadTask:status:)]) {
                [delegate sakuraManagerDownload:self downloadTask:downloadTask status:TXSakuraDownloadTaskStatusDownloading];
            }
        }
            break;
            
        default:
            break;
    }
    if (downloadTask) {
        TXSakuraDownloadTaskDelegateWrapper *delegateWrapper = [TXSakuraDownloadTaskDelegateWrapper wrapperWithManager:self delegate:delegate sakuraDownloadInfos:infos];
        self.sakuraDownloadTaskDelegateWrappersByIdentifier[@(downloadTask.taskIdentifier)] = delegateWrapper;
    }
    return downloadTask;
}

#pragma mark - Download cancel operation(Public)

- (void)tx_cancelSakuraDownloadTaskWithURLStr:(NSString *)URLStr {
    if (URLStr || !URLStr.length || !_sakuraDownloadTaskCache) return;
    NSURLSessionDownloadTask *downloadTask = [_sakuraDownloadTaskCache objectForKey:URLStr];
    [self tx_cancelSakuraDownloadTask:downloadTask];
}

- (void)tx_cancelSakuraDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    if (!downloadTask || !_sakuraDownloadTaskCache) return;
    [downloadTask cancel];
    NSString *key = downloadTask.originalRequest.URL.absoluteString;
    if (key) {
        [_sakuraDownloadTaskCache removeObjectForKey:key];
    }
    [self _removeSakuraHandlersWithDownloadTask:downloadTask];
}

- (void)tx_cancelSakuraAllDownloadTask {
    [[_sakuraDownloadTaskCache copy] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSURLSessionDownloadTask * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj cancel];
        [_sakuraDownloadTaskCache removeObjectForKey:key];
    }];
    [self _removeSakuraAllHandlers];
}

#pragma mark - Private

#pragma mark - Local sakura path operation(Private)

+ (NSString *)_getLibraryPath {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

// Sakura/[folderName]/[zipFileName.zip]
+ (NSString *)_getSakuraZipFileSandboxPathWithName:(NSString *)name {
    NSString *fileName = [name stringByAppendingPathExtension:kTXFileExtensionZIP];
    NSString *zipFilePath = [[self tx_getSakuraSandboxPathWithName:name] stringByAppendingPathComponent:fileName];
    return zipFilePath;
}

// SakuraName 
+ (NSString *)_getSakuraNameWithInfos:(id<TXSakuraDownloadProtocol>)infos {
    if (infos.sakuraName.length) return infos.sakuraName;
    return [[infos.remoteURL lastPathComponent] stringByDeletingPathExtension];
}

// Sakura/[folderName]
+ (NSString *)_getSakuraPathWithInfos:(id<TXSakuraDownloadProtocol>)infos {
    NSString *fileFolder = [self _getSakuraNameWithInfos:infos];
    return [self tx_getSakuraSandboxPathWithName:fileFolder];
}

#pragma mark - File manager(Private)

+ (NSString *)_filePathWithName:(NSString *)configsName type:(NSString *)type {
    NSString *configsFullName = [configsName stringByAppendingPathExtension:type];
    NSString *configFilePath = [[self tx_getSakuraResourceSandboxPathWithName:configsName] stringByAppendingPathComponent:configsFullName];
    return configFilePath;
}

+ (BOOL)_fileExistsAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

#pragma mark - Delegate download operation(Private)

- (NSURLSessionDownloadTask *)_sakuraDownloadWithInfos:(id<TXSakuraDownloadProtocol>)infos
                                                 status:(TXSakuraDownloadTaskStatus *)status {
    NSURL *url = [NSURL URLWithString:infos.remoteURL];
    // URL not exist!
    if (!url) return nil;
    // Sakura do not exist in local ?
    NSString *configsName = [TXSakuraManager _getSakuraNameWithInfos:infos];
    NSString *isAlreadyExist = [TXSakuraManager tx_tryGetSakuraConfigsFileSandboxPathWithName:configsName];
    // Is alreadying download ?
    BOOL isDownloading = [_sakuraDownloadTaskCache.allKeys containsObject:infos.remoteURL];
    // Status changing.
    if (isAlreadyExist && isAlreadyExist.length) {
        *status = TXSakuraDownloadTaskStatusAlreadyExist;
        return nil;
    }
    if (isDownloading) {
        NSURLSessionDownloadTask *downloadTask = [_sakuraDownloadTaskCache objectForKey:infos.remoteURL];
        *status = TXSakuraDownloadTaskStatusDownloading;
        return downloadTask;
    }
    // Create & Start.
    NSURLSessionDownloadTask *downloadTask = [self _sakuraDownloadTaskWithURL:url];
    return downloadTask;
}

- (NSURLSession *)session {
    NSURLSession *urlSession = objc_getAssociatedObject(self, _cmd);
    if (urlSession) return urlSession;
    @synchronized(self) {
        NSURLSessionConfiguration *congfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:congfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        objc_setAssociatedObject(self, _cmd, session, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        urlSession = session;
    }
    return urlSession;
}

- (NSURLSessionDownloadTask *)_sakuraDownloadTaskWithURL:(NSURL *)url {
    if (!url) return nil;
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:url];
    [downloadTask resume];
    NSString *key = url.absoluteString;
    if (key) {
        [_sakuraDownloadTaskCache setObject:downloadTask forKey:key];
    }
    return downloadTask;
}


#pragma mark - NSLock operation(Private)

- (TXSakuraDownloadTaskDelegateWrapper *)_getSakuraDownloadTaskDelegateWrapperWithTask:(NSURLSessionTask *)task {
    TXSakuraDownloadTaskDelegateWrapper *delegateWrapper = nil;
    [self.lock lock];
    delegateWrapper = self.sakuraDownloadTaskDelegateWrappersByIdentifier[@(task.taskIdentifier)];
    [self.lock unlock];
    return delegateWrapper;
}

- (void)_setSakuraDownloadTaskDelegateWrapper:(TXSakuraDownloadTaskDelegateWrapper *)delegateWrapper
                                      forTask:(NSURLSessionTask *)task {
    [self.lock lock];
    self.sakuraDownloadTaskDelegateWrappersByIdentifier[@(task.taskIdentifier)] = delegateWrapper;
    [self.lock unlock];
}

- (void)_removeSakuraDownloadTaskDelegateWrapperForTask:(NSURLSessionTask *)task {
    [self.lock lock];
    [self.sakuraDownloadTaskDelegateWrappersByIdentifier removeObjectForKey:@(task.taskIdentifier)];
    [self.lock unlock];
}

- (void)_removeAllSakuraDownloadTaskDelegateWrapper {
    [self.lock lock];
    [self.sakuraDownloadTaskDelegateWrappersByIdentifier removeAllObjects];
    [self.lock unlock];
}

#pragma mark - Download cancel operation(Private)

- (void)_removeSakuraHandlersWithDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    [self _removeSakuraDownloadTaskDelegateWrapperForTask:downloadTask];
    if (!_sakuraDownloadTaskCache.allKeys.count) {
        [self _sessionInvalidateAndCancel];
    }
}

- (void)_removeSakuraAllHandlers {
    [self _removeAllSakuraDownloadTaskDelegateWrapper];
    [self _sessionInvalidateAndCancel];
}

- (void)_sessionInvalidateAndCancel {
    NSURLSession *session = [self session];
    [session invalidateAndCancel];
    objc_setAssociatedObject(self, @selector(session), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 Create a concurrent queue for SakuraKit
 */
static dispatch_queue_t _getSakuraBackgroundQueue(void)
{
    static dispatch_once_t onceToken;
    static dispatch_queue_t backgroundQueue = nil;
    dispatch_once(&onceToken, ^{
        /** backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); */
        backgroundQueue = dispatch_queue_create("tingxins.SakuraKit.Queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return backgroundQueue;
}

#pragma mark - Custom operation

- (void)tx_generatePathWithInfos:(id<TXSakuraDownloadProtocol>)infos
            downloadFileLocalURL:(NSURL *)location
                  successHandler:(TXSakuraGeneratePathSuccessHandler)successHandler
                    errorHandler:(TXSakuraErrorHandler)errorHandler{

    if (!location) {
        errorHandler([NSError errorWithDomain:@"The parameter of location can not be nil!" code:0 userInfo:nil]);
        return;
    }
    
    NSString *sakuraPath = [TXSakuraManager _getSakuraPathWithInfos:infos];
    [self tx_clearSakuraCacheWithPath:sakuraPath];
    
#ifdef DEBUG
    NSLog(@"locationPath:%@", location.path);
    NSLog(@"sakuraPath:%@", sakuraPath);
#endif
    
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL flag = [fileManager createDirectoryAtPath:sakuraPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!flag) {
        errorHandler([NSError errorWithDomain:@"Fail to createDirectoryAtPath!" code:0 userInfo:nil]);
        return;
    }
    
    error = nil;

    NSString *sakuraName = [TXSakuraManager _getSakuraNameWithInfos:infos];
    NSString *toFilePath = [TXSakuraManager _getSakuraZipFileSandboxPathWithName:sakuraName];
    flag = [fileManager moveItemAtPath:location.path toPath:toFilePath error:&error];
    
    if (error) { }
    
    if (!flag) {
        errorHandler([NSError errorWithDomain:@"Fail to moveItemAtPath!" code:0 userInfo:nil]);
        return;
    }
    
    successHandler(toFilePath, sakuraPath, sakuraName);
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (error) {
        TXSakuraDownloadTaskDelegateWrapper *delegateWrapper = self.sakuraDownloadTaskDelegateWrappersByIdentifier[@(task.taskIdentifier)];
        if (delegateWrapper) {
            [delegateWrapper URLSession:session task:task didCompleteWithError:error];
        }
    }
}

/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    if (!location) return;
    TXSakuraDownloadTaskDelegateWrapper *delegateWrapper = self.sakuraDownloadTaskDelegateWrappersByIdentifier[@(downloadTask.taskIdentifier)];
    if (delegateWrapper) {
        [delegateWrapper URLSession:session downloadTask:downloadTask didFinishDownloadingToURL:location];
    }
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    TXSakuraDownloadTaskDelegateWrapper *delegateWrapper = self.sakuraDownloadTaskDelegateWrappersByIdentifier[@(downloadTask.taskIdentifier)];
    if (delegateWrapper) {
        [delegateWrapper URLSession:session downloadTask:downloadTask didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
}

@end

/************************************************************************************************************/

@implementation TXSakuraDownloadTaskDelegateWrapper

- (instancetype)initWithManager:(TXSakuraManager *)manager delegate:(id<TXSakuraDownloadDelegate>)delegate sakuraDownloadInfos:(id<TXSakuraDownloadProtocol>)sakuraDownloadInfos {
    if (self = [super init]) {
        self.manager = manager;
        self.delegate = delegate;
        self.sakuraDownloadInfos = sakuraDownloadInfos;
    }
    return self;
}

- (instancetype)initWithManager:(TXSakuraManager *)manager
            sakuraDownloadInfos:(id<TXSakuraDownloadProtocol>)sakuraDownloadInfos
                progressHandler:(TXSakuraDownloadProgressHandler)downloadProgressHandler
                   errorHandler:(TXSakuraErrorHandler)errorHandler
           unzipProgressHandler:(TXSakuraUnzipProgressHandler)unzipProgressHandler
               completedHandler:(TXSakuraDownloadCompletedHandler)completedHandler {
    if (self = [super init]) {
        self.manager = manager;
        self.sakuraDownloadInfos = sakuraDownloadInfos;
        self.downloadProgressHandler = downloadProgressHandler;
        self.downloadErrorHandler = errorHandler;
        self.unzipProgressHandler = unzipProgressHandler;
        self.completedHandler = completedHandler;
    }
    return self;
}

+ (instancetype)wrapperWithManager:(TXSakuraManager *)manager delegate:(id<TXSakuraDownloadDelegate>)delegate sakuraDownloadInfos:(id<TXSakuraDownloadProtocol>)sakuraDownloadInfos {
    return [[self alloc] initWithManager:manager delegate:delegate sakuraDownloadInfos:sakuraDownloadInfos];
}

+ (instancetype)wrapperWithManager:(TXSakuraManager *)manager
               sakuraDownloadInfos:(id<TXSakuraDownloadProtocol>)sakuraDownloadInfos
                   progressHandler:(TXSakuraDownloadProgressHandler)downloadProgressHandler
                      errorHandler:(TXSakuraErrorHandler)errorHandler
              unzipProgressHandler:(TXSakuraUnzipProgressHandler)unzipProgressHandler
                  completedHandler:(TXSakuraDownloadCompletedHandler)completedHandler{
    return [[self alloc] initWithManager:manager
                     sakuraDownloadInfos:sakuraDownloadInfos
                         progressHandler:downloadProgressHandler
                            errorHandler:errorHandler
                    unzipProgressHandler:unzipProgressHandler
                        completedHandler:completedHandler];
}

#pragma mark - Delegate download operation(Private)

- (void)_unzipSakuraFileAtPath:(NSString *)toFilePath
                 toDestination:(NSString *)sakuraPath
                  downloadTask:(NSURLSessionDownloadTask *)downloadTask{
    
    dispatch_async(_getSakuraBackgroundQueue(), ^{
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:toFilePath error:nil];
        __block unsigned long long fileSize = [fileAttributes[NSFileSize] unsignedLongLongValue];
        __block unsigned long long currentPosition = 0;
        BOOL isSuccess = [SSZipArchive unzipFileAtPath:toFilePath toDestination:sakuraPath progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
            currentPosition += zipInfo.compressed_size;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(sakuraManagerDownload:downloadTask:progressEvent:total:)]) {
                    [self.delegate sakuraManagerDownload:self.manager
                                       downloadTask:downloadTask
                                      progressEvent:currentPosition
                                              total:fileSize];
                }
            });
        } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(sakuraManagerDownload:downloadTask:progressEvent:total:)]) {
                    [self.delegate sakuraManagerDownload:self.manager
                                       downloadTask:downloadTask
                                      progressEvent:fileSize
                                              total:fileSize];
                }
            });
        }];
        
        if (isSuccess) {
            [TXSakuraManager formatSakuraPath:sakuraPath cleanCachePath:toFilePath];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (isSuccess) {
                NSURL *sakuraPathURL = [NSURL fileURLWithPath:sakuraPath];
                if (sakuraPathURL && [self.delegate respondsToSelector:@selector(sakuraManagerDownload:downloadTask:sakuraInfos:didFinishDownloadingToURL:)]) {
                    [self.delegate sakuraManagerDownload:self.manager
                                            downloadTask:downloadTask
                                             sakuraInfos:self.sakuraDownloadInfos
                               didFinishDownloadingToURL:sakuraPathURL];
                }
            }
            [self.manager tx_cancelSakuraDownloadTask:downloadTask];
        });
    });
    
}

#pragma mark - Block download operation(Private)

- (void)_unzipSakuraFileBlockHandlerAtPath:(NSString *)toFilePath
                             toDestination:(NSString *)sakuraPath
                              downloadTask:(NSURLSessionDownloadTask *)downloadTask{
    dispatch_async(_getSakuraBackgroundQueue(), ^{
        
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:toFilePath error:nil];
        __block unsigned long long fileSize = [fileAttributes[NSFileSize] unsignedLongLongValue];
        __block unsigned long long currentPosition = 0;
        BOOL isSuccess = [SSZipArchive unzipFileAtPath:toFilePath toDestination:sakuraPath progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
            currentPosition += zipInfo.compressed_size;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.unzipProgressHandler) {
                    self.unzipProgressHandler(currentPosition, fileSize);
                }
            });
        } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.unzipProgressHandler) {
                    self.unzipProgressHandler(fileSize, fileSize);
                }
            });
        }];
        
        if (isSuccess) {
            [TXSakuraManager formatSakuraPath:sakuraPath cleanCachePath:toFilePath];
        }
        if (isSuccess) {
            NSURL *sakuraPathURL = [NSURL fileURLWithPath:sakuraPath];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (self.completedHandler) {
                    self.completedHandler(self.sakuraDownloadInfos, sakuraPathURL);
                }
                [self.manager tx_cancelSakuraDownloadTask:downloadTask];
            });
        }
    });
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    
    if (!error) return;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sakuraManagerDownload:sessionTask:didCompleteWithError:)]) {
        [self.delegate sakuraManagerDownload:self.manager sessionTask:task didCompleteWithError:error];
    }else {
        if (self.downloadErrorHandler) {
            self.downloadErrorHandler(error);
        }
        
        NSString *key = task.originalRequest.URL.absoluteString;
        if (key) {
            [self.manager.sakuraDownloadTaskCache removeObjectForKey:key];
        }
        [self.manager _removeSakuraHandlersWithDownloadTask:(NSURLSessionDownloadTask *)task];
    }
}

/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    if (!location) return;

    NSString *sakuraPath = [TXSakuraManager _getSakuraPathWithInfos:self.sakuraDownloadInfos];
    [self.manager tx_clearSakuraCacheWithPath:sakuraPath];
    
#ifdef DEBUG
    NSLog(@"locationPath:%@", location.path);
    NSLog(@"sakuraPath:%@", sakuraPath);
#endif
    
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL flag = [fileManager createDirectoryAtPath:sakuraPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!flag) return;
    
    error = nil;

    NSString *sakuraName = [TXSakuraManager _getSakuraNameWithInfos:self.sakuraDownloadInfos];
    NSString *toFilePath = [TXSakuraManager _getSakuraZipFileSandboxPathWithName:sakuraName];
    flag = [fileManager moveItemAtPath:location.path toPath:toFilePath error:&error];
    
    if (error) { }
    
    if (!flag) return;
    
    if (self.delegate) {
        [self _unzipSakuraFileAtPath:toFilePath toDestination:sakuraPath downloadTask:downloadTask];
    }else {
        [self _unzipSakuraFileBlockHandlerAtPath:toFilePath toDestination:sakuraPath downloadTask:downloadTask];
    }
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sakuraManagerDownload:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)])
    {
        [self.delegate sakuraManagerDownload:self.manager
                           downloadTask:downloadTask
                           didWriteData:bytesWritten
                      totalBytesWritten:totalBytesWritten
              totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }else {
        if (self.downloadProgressHandler) {
            self.downloadProgressHandler(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        }
    }
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sakuraManagerDownload:downloadTask:didResumeAtOffset:expectedTotalBytes:)]) {
        [self.delegate sakuraManagerDownload:self.manager
                           downloadTask:downloadTask
                      didResumeAtOffset:fileOffset
                     expectedTotalBytes:expectedTotalBytes];
    }
}
@end
