//
//  TXSakuraManager.h
//  SakuraKit
//
//  Created by tingxins on 23/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * _Nonnull const kTXSakuraDefault;

typedef NSString TXSakuraName;

SEL _Nullable getSelectorWithPattern(const char * _Nullable prefix, const char * _Nullable key, const char * _Nullable suffix);

typedef NS_ENUM(NSInteger, TXSakuraType) {
    TXSakuraTypeMainBundle,
    TXSakuraTypeSandbox
};

/** Download task status. */
typedef NS_ENUM(NSInteger, TXSakuraDownloadTaskStatus) {
    TXSakuraDownloadTaskStatusNew = 1, // New task
    TXSakuraDownloadTaskStatusAlreadyExist, // Alreading exist task
    TXSakuraDownloadTaskStatusDownloading, // Downloading task
    TXSakuraDownloadTaskStatusSuspending // Suspending task
};

@class TXSakuraManager;

@protocol TXSakuraDownloadProtocol <NSObject>

@property (copy, nonatomic, nonnull) NSString * remoteURL;

@property (copy, nonatomic, nullable) TXSakuraName * sakuraName;

@end

@protocol TXSakuraDownloadDelegate <NSObject>

@optional

- (void)sakuraManagerDownload:(TXSakuraManager *_Nullable)manager
                 downloadTask:(NSURLSessionDownloadTask *_Nullable)downloadTask
                       status:(TXSakuraDownloadTaskStatus)status;

/** Download completed callback */
- (void)sakuraManagerDownload:(TXSakuraManager *_Nullable)manager
                 downloadTask:(NSURLSessionDownloadTask *_Nullable)downloadTask
                  sakuraInfos:(id<TXSakuraDownloadProtocol>_Nullable)infos
   didFinishDownloadingToURL:(NSURL *_Nullable)location;

/** Download progress callback */
- (void)sakuraManagerDownload:(TXSakuraManager *_Nullable)manager
                downloadTask:(NSURLSessionDownloadTask *_Nullable)downloadTask
                didWriteData:(int64_t)bytesWritten
           totalBytesWritten:(int64_t)totalBytesWritten
   totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

/** Reserved for future use */
- (void)sakuraManagerDownload:(TXSakuraManager *_Nullable)manager
                downloadTask:(NSURLSessionDownloadTask *_Nullable)downloadTask
           didResumeAtOffset:(int64_t)fileOffset
          expectedTotalBytes:(int64_t)expectedTotalBytes;

/** Download error completed handler */
- (void)sakuraManagerDownload:(TXSakuraManager *_Nullable)manager
                 sessionTask:(NSURLSessionTask *_Nullable)downloadTask
        didCompleteWithError:(nullable NSError *)error;

/** unzip progress handler */
- (void)sakuraManagerDownload:(TXSakuraManager *_Nullable)manager
                 downloadTask:(NSURLSessionDownloadTask *_Nullable)downloadTask
                progressEvent:(unsigned long long)loaded
                        total:(unsigned long long)total;
@end

@interface TXSakuraManager : NSObject

#pragma mark - Share

+ (instancetype _Nullable )manager;

#pragma mark - Operation

+ (void)formatSakuraPath:(NSString *_Nullable)sakuraPath cleanCachePath:(NSString *_Nullable)cachePath;

+ (BOOL)shiftSakuraWithName:(TXSakuraName *_Nullable)name type:(TXSakuraType)type;

+ (TXSakuraType)getSakuraCurrentType;

+ (TXSakuraName *_Nullable)getSakuraCurrentName;

#pragma mark - Manual Sakura

+ (NSArray<TXSakuraName *> *_Nullable)getLocalSakuraNames;

+ (void)registerLocalSakuraWithNames:(NSArray<TXSakuraName *> *_Nullable)names;

//+ (void)addRemoteSakuraWithName:(TXSakuraName *_Nullable)name resourceURL:(NSURL *_Nullable)url;

@end

#pragma mark - TXSerialization

@interface TXSakuraManager(TXSerialization)
/** Fetch object sakura vector key value */
+ (NSDictionary *_Nullable)tx_getObjVectorOperationKV;

/** Fetch int sakura vector key value */
+ (NSDictionary *_Nullable)tx_getIntVectorOperationKV;

/** Fetch float sakura vector key value */
+ (NSDictionary *_Nullable)tx_getFloatVectorOperationKV;
/**
 Manager serialization
 @param path Pass a KeyPath
 @return Color value
 */
+ (UIColor *_Nullable)tx_colorWithPath:(NSString *_Nullable)path;
+ (CGColorRef _Nullable )tx_cgColorWithPath:(NSString *_Nullable)path;
/**
 @return Float value
 */
+ (CGFloat)tx_floatWithPath:(NSString *_Nullable)path;
/**
 @return Bool value
 */
+ (BOOL)tx_boolWithPath:(NSString *_Nullable)path;
/**
 @return String value
 */
+ (NSString *_Nullable)tx_stringWithPath:(NSString *_Nullable)path;
/**
 @return Image value
 */
+ (UIImage *_Nullable)tx_imageWithPath:(NSString *_Nullable)path;
/**
 @return Font value
 */
+ (UIFont *_Nullable)tx_fontWithPath:(NSString *_Nullable)path;

/** Original data */
+ (NSDictionary *_Nullable)tx_origDictionaryWithPath:(NSString *_Nullable)path;

/**
 For navigationBar
 @return Attributes
 */
+ (NSDictionary *_Nullable)tx_titleTextAttributesDictionaryWithPath:(NSString *_Nullable)path;

/**
 For enum
 @param path KeyPath
 @return A Integer Value
 */
+ (NSInteger)tx_integerWithPath:(NSString *_Nullable)path;

+ (UIStatusBarStyle)tx_statusBarStyleWithPath:(NSString *_Nullable)path;

+ (UIBarStyle)tx_barStyleWithPath:(NSString *_Nullable)path;

+ (UIKeyboardAppearance)tx_keyboardAppearanceWithPath:(NSString *_Nullable)path;

+ (UIActivityIndicatorViewStyle)tx_activityIndicatorStyleWithPath:(NSString *_Nullable)path;

@end

#pragma mark - TXTool

@interface TXSakuraManager(TXTool)
/** Inspired by DKNightVersion */
+ (UIColor *_Nullable)tx_colorFromString:(NSString *_Nullable)hexStr;

@end

#pragma mark - TXDownload

/** Downloading progress block handler */
typedef void(^TXSakuraDownloadProgressHandler)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
/** Download completed block handler */
typedef void(^TXSakuraErrorHandler)(NSError * _Nullable error);
/** Unzip download file progress block handler */
typedef void(^TXSakuraUnzipProgressHandler)(unsigned long long loaded, unsigned long long total);
/** Unzip download file completed handler */
typedef void(^TXSakuraDownloadCompletedHandler)(id<TXSakuraDownloadProtocol>_Nullable infos, NSURL * _Nullable location);
/** Custom download operation block handler */
typedef void(^TXSakuraGeneratePathSuccessHandler)(NSString *_Nullable toFilePath, NSString *_Nullable sakuraPath, TXSakuraName *_Nullable sakuraName);

@interface TXSakuraManager(TXDownload)<NSURLSessionDownloadDelegate>

/** return list of all sakura that you have downloaded. */
+ (NSArray<TXSakuraName *> *_Nullable)tx_getSakurasList;

#pragma mark - Clear operation

/** Notice! This operation will remove all sakuras that you have downloaded! */
+ (BOOL)tx_clearSakuraAllCaches;

/** Remove a special sakura if you want. */
+ (BOOL)tx_clearSakuraCacheWithName:(NSString *_Nullable)sakuraName;

/** Remove a special sakura with it path that you want to. */
+ (BOOL)tx_clearSakuraCacheWithPath:(NSString *_Nullable)path;

#pragma mark - Sakura operation

/** Path: Sakura */
+ (NSString *_Nullable)tx_getSakurasDirectoryPath;

// Sakura/[folderName]
+ (NSString *_Nullable)tx_getSakuraSandboxPathWithName:(NSString *_Nullable)name;

/** Path: Sakura/[folderName] */
+ (NSString *_Nullable)tx_getSakuraResourceSandboxPathWithName:(NSString *_Nullable)sakuraName;

/** Path: Sakura/[folderName]/[configsFileName][json/plist] */
+ (NSString *_Nullable)tx_tryGetSakuraConfigsFileSandboxPathWithName:(NSString *_Nullable)sakuraName;

/** Bundle path */
+ (NSString *_Nullable)tx_getSakuraConfigsFileBundlePathWithName:(NSString *_Nullable)sakuraName;

#pragma mark - Dowload operation

- (NSURLSessionDownloadTask *_Nullable)tx_sakuraDownloadWithInfos:(id<TXSakuraDownloadProtocol> _Nullable)infos
                                                          delegate:(id<TXSakuraDownloadDelegate> _Nullable)delegate;

- (NSURLSessionDownloadTask *_Nullable)tx_sakuraDownloadWithInfos:(id<TXSakuraDownloadProtocol> _Nullable)infos
                                           downloadProgressHandler:(TXSakuraDownloadProgressHandler _Nullable )downloadProgressHandler
                                              downloadErrorHandler:(TXSakuraErrorHandler _Nullable)downloadErrorHandler
                                              unzipProgressHandler:(TXSakuraUnzipProgressHandler _Nullable)unzipProgressHandler
                                                  completedHandler:(TXSakuraDownloadCompletedHandler _Nullable)completedHandler;

- (void)tx_cancelSakuraDownloadTaskWithURLStr:(NSString *_Nullable)URLStr;

- (void)tx_cancelSakuraDownloadTask:(NSURLSessionDownloadTask *_Nullable)downloadTask;

- (void)tx_cancelSakuraAllDownloadTask;

#pragma mark - Custom operation
/**
 if you are custom your own download or unzip operation without using "-tx_sakuraDownloadWithInfos:delegate" or  "-tx_sakuraDownloadWithInfos:downloadProgressHandler:downloadErrorHandler:unzipProgressHandler:completedHandler".
 you may need to use this method to generate some paths that make SakuraKit can control it.
 
 @param infos Fetch sakura name with URL that need.
 @param location Did finish downloading to URL of local file.
 @param successHandler If generate successed, this handler will callback.
 @param errorHandler If some errors, this handler will callback.
 */
- (void)tx_generatePathWithInfos:(id<TXSakuraDownloadProtocol>_Nullable)infos
            downloadFileLocalURL:(NSURL *_Nullable)location
                  successHandler:(TXSakuraGeneratePathSuccessHandler _Nullable)successHandler
                    errorHandler:(TXSakuraErrorHandler _Nullable)errorHandler;

@end
