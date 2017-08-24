//
//  PushViewController.m
//  SakuraDemo_OC
//
//  Created by tingxins on 05/07/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//  开发者自定义下载方式示例

#import "PushViewController.h"
#import "TXSakuraKit.h"
#import "NSObject+TXExeDeallocBlock.h"
#import <SSZipArchive/ZipArchive.h>
#import "SakuraModel.h"

@interface PushViewController ()<NSURLSessionDownloadDelegate, SSZipArchiveDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pushImageView;

@end

@implementation PushViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pushImageView.sakura
    .image(@"Fourth.tabSelectImage");
    
//    [self sendCustomDownloadRequest];
}

- (void)sendCustomDemoDownloadRequest {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *sesssion = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:@"http://image.tingxins.cn/sakura/weibo.zip"];
    if (!url) return;
    NSURLSessionDownloadTask *downloadTask0 = [sesssion downloadTaskWithURL:url];
    [downloadTask0 resume];
    [downloadTask0 tx_runBlockAtDealloc:^{
        NSLog(@"downloadTask0 push dealloc!");
    }];
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"%lld--%lld--%lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"download did finish:%@---%@",downloadTask, location);
    
    SakuraModel *sakuraModel = [SakuraModel sakuraModelWithRemoteURL:downloadTask.originalRequest.URL.absoluteString sakuraName:@"weibo"];
    [[TXSakuraManager manager] tx_generatePathWithInfos:sakuraModel downloadFileLocalURL:location successHandler:^(NSString * _Nullable toFilePath, NSString * _Nullable sakuraPath, TXSakuraName *_Nullable sakuraName) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL isSuccess = [SSZipArchive unzipFileAtPath:toFilePath toDestination:sakuraPath delegate:self];
            NSLog(@"%@", self);
            // Sakura 路径格式化！Required！
            [TXSakuraManager formatSakuraPath:sakuraPath cleanCachePath:toFilePath];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (isSuccess) {
                    [TXSakuraManager shiftSakuraWithName:sakuraName type:TXSakuraTypeSandbox];
                }
            });
        });
    } errorHandler:^(NSError * _Nullable error) {
        NSLog(@"errorDescription:%@",error);
    }];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"error%@", error);
}

- (void)zipArchiveProgressEvent:(unsigned long long)loaded total:(unsigned long long)total {
    NSLog(@"zipArchiveProgressEvent:%lld--%lld", loaded, total);
}

@end
