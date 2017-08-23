//
//  SakuraModel.h
//  SakuraDemo_OC
//
//  Created by tingxins on 31/07/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TXSakuraKit.h"

@interface SakuraModel : NSObject<TXSakuraDownloadProtocol>

@property (copy, nonatomic) NSString *name;

#pragma mark - 协议属性

@property (copy, nonatomic) TXSakuraName *sakuraName;

@property (copy, nonatomic) NSString *remoteURL;

#pragma mark - 衍生属性

@property (assign, nonatomic) CGFloat progress;

@property (assign, nonatomic) NSInteger status;

@property (copy, nonatomic, readonly) NSString *statusName;

@property (strong, nonatomic, readonly) UIColor *progressColor;

- (instancetype)initWithDict:(NSDictionary *)dict;

- (instancetype)initWithRemoteURL:(NSString *)url sakuraName:(TXSakuraName *)sakuraName;

+ (instancetype)sakuraModelWithDict:(NSDictionary *)dict;

+ (NSArray<SakuraModel *> *)sakuraModelWithDicts:(NSArray *)dicts;

+ (instancetype)sakuraModelWithRemoteURL:(NSString *)url sakuraName:(TXSakuraName *)sakuraName;

@end
//http://rapapi.org/mockjsdata/21815/theme/list

/** [
 {
 "name":
 "\u9634\u9633\u5e08",
 "url":
 "http://image.tingxins.cn/sakura/Onmyoji.zip"
 },
 {
 "name":
 "\u5927\u9c7c\u6d77\u68e0",
 "url":
 "http://image.tingxins.cn/sakura/bigfish.zip"
 },
 {
 "name":
 "\u8349\u8393\u97f3\u4e50\u8282",
 "url":
 "http://image.tingxins.cn/sakura/strawberry.zip"
 }
 ] */
