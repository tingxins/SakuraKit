//
//  AppDelegate.m
//  SakuraDemo_OC
//
//  Created by tingxins on 04/07/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "AppDelegate.h"
#import "TXSakuraKit.h"
#import "NSObject+TXExeDeallocBlock.h"
#import "SakuraModel.h"

@interface AppDelegate ()<TXSakuraDownloadDelegate>{
    SakuraModel *_sakuraModel;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configsTheme];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 120, 30)];
    label.backgroundColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 15;
    label.layer.masksToBounds = YES;
    label.hidden = YES;
    self.label = label;
    [self.window addSubview:label];
    
    [self sendRequest];
    
    [TXSakuraManager registerLocalSakuraWithNames:@[@"typewriter"]];
    
    NSString *name = [TXSakuraManager getSakuraCurrentName];
    NSInteger type = [TXSakuraManager getSakuraCurrentType];
    [TXSakuraManager shiftSakuraWithName:name type:type];
    return YES;
}

/** Just a Demo for SakuraKit. FYI */
- (void)configsTheme {
    // UIStatusBarStyle
    [UIApplication sharedApplication].sakura
    .statusBarStyle(@"Global.statusBarStyle", YES);
    
    // UITabBar
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    tabBarController.tabBar.items[0].sakura
    .image(@"First.tabImage")
    .selectedImage(@"First.tabSelectImage")
    .title(@"First.title")
    .titleTextAttributes(@"Global.tabTitleAttributeColor",UIControlStateNormal)
    .titleTextAttributes(@"Global.tabTitleAttributeSelectColor",UIControlStateSelected);
    
    tabBarController.tabBar.items[1].sakura
    .image(@"Second.tabImage")
    .selectedImage(@"Second.tabSelectImage")
    .title(@"Second.title")
    .titleTextAttributes(@"Global.tabTitleAttributeColor",UIControlStateNormal)
    .titleTextAttributes(@"Global.tabTitleAttributeSelectColor",UIControlStateSelected);
    
    tabBarController.tabBar.items[2].sakura
    .image(@"Third.tabImage")
    .selectedImage(@"Third.tabSelectImage")
    .title(@"Third.title")
    .titleTextAttributes(@"Global.tabTitleAttributeColor",UIControlStateNormal)
    .titleTextAttributes(@"Global.tabTitleAttributeSelectColor",UIControlStateSelected);
    
    tabBarController.tabBar.items[3].sakura
    .image(@"Fourth.tabImage")
    .selectedImage(@"Fourth.tabSelectImage")
    .title(@"Fourth.title")
    .titleTextAttributes(@"Global.tabTitleAttributeColor",UIControlStateNormal)
    .titleTextAttributes(@"Global.tabTitleAttributeSelectColor",UIControlStateSelected);
    
    
    tabBarController.tabBar.sakura
    .backgroundImage(@"Global.tabBarBackgroundImage")
    .tintColor(@"Global.tabTitleSelectColor");
    
    if (@available(iOS 10.0, *)) {
        tabBarController.tabBar.sakura
        .unselectedItemTintColor(@"Global.tabTitleColor");
    } else {
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - ThemeChange

- (IBAction)downloadSakura:(UIBarButtonItem *)sender {
    NSURLSessionDownloadTask *downloadTask = [[TXSakuraManager manager] tx_sakuraDownloadWithInfos:_sakuraModel delegate:self];
    [downloadTask tx_runBlockAtDealloc:^{
        NSLog(@"download task dealloc!");
    }];
    self.label.hidden = !downloadTask;
}

- (void)sendRequest {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://rapapi.org/mockjs/21815/theme/infos"];
    if (!url) return;
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!data || error) return;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (json) {
            _sakuraModel = [SakuraModel sakuraModelWithDict:json];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self downloadSakura:nil];
            });
        }
    }] resume] ;
}

- (void)changeTheme:(id<TXSakuraDownloadProtocol>)infos {
    [TXSakuraManager shiftSakuraWithName:infos.sakuraName type:TXSakuraTypeSandbox];
}

#pragma mark - Sakura download delegate

- (void)sakuraManagerDownload:(TXSakuraManager *)manager downloadTask:downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    self.label.textColor = [UIColor whiteColor];
    long long current = totalBytesWritten/1024;
    long long total = totalBytesExpectedToWrite/1024;
    self.label.text = [NSString stringWithFormat:@"下载%.2lf%%", (current*1.0/total)*100];
}

- (void)sakuraManagerDownload:(TXSakuraManager *)manager
                 downloadTask:(NSURLSessionDownloadTask * _Nullable)downloadTask
                  sakuraInfos:(id<TXSakuraDownloadProtocol> _Nullable)infos
    didFinishDownloadingToURL:(NSURL * _Nullable)location {
    NSLog(@"%s", __func__);
    [self changeTheme:infos];
    self.label.hidden = YES;
}

- (void)sakuraManagerDownload:(TXSakuraManager *)manager downloadTask:(NSURLSessionDownloadTask * _Nullable)downloadTask progressEvent:(unsigned long long)loaded total:(unsigned long long)total {
    long long current = loaded/1024;
    long long totalB = total/1024;
    self.label.textColor = [UIColor whiteColor];
    self.label.text = [NSString stringWithFormat:@"解压%.1lf%%", (current*1.0/totalB)*100];
}

@end
