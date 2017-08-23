//
//  SakuraModel.m
//  SakuraDemo_OC
//
//  Created by tingxins on 31/07/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "SakuraModel.h"
#import "TXSakuraKit.h"

@implementation SakuraModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _name = [dict[@"name"] copy];
        _remoteURL = [dict[@"url"] copy];
        _sakuraName = [dict[@"sakuraName"] copy];
        if (_sakuraName && [TXSakuraManager tx_tryGetSakuraConfigsFileSandboxPathWithName:_sakuraName]) {
            _status = 3;
        }
    }
    return self;
}

- (instancetype)initWithRemoteURL:(NSString *)url sakuraName:(TXSakuraName *)sakuraName {
    if (self = [super init]) {
        self.remoteURL = url;
        self.sakuraName = sakuraName;
    }
    return self;
}

+ (instancetype)sakuraModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

+ (NSArray<SakuraModel *> *)sakuraModelWithDicts:(NSArray *)dicts {
    if (!dicts.count) return nil;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in dicts) {
        SakuraModel *model = [SakuraModel sakuraModelWithDict:dict];
        if (model) {
            [tempArray addObject:model];
        }
    }
    return tempArray;
}

+ (instancetype)sakuraModelWithRemoteURL:(NSString *)url sakuraName:(TXSakuraName *)sakuraName {
    return [[self alloc] initWithRemoteURL:url sakuraName:sakuraName];
}

// 1 下载；2 解压；3 使用
- (NSString *)statusName {
    NSString *text = @"下载";
    switch (_status) {
        case 1:
            text = [@"下载中" stringByAppendingString:[NSString stringWithFormat:@"%.1lf%%", _progress * 100]];
            break;
        case 2:
            text = [@"解压中" stringByAppendingString:[NSString stringWithFormat:@"%.1lf%%", _progress * 100]];
            break;
        case 3:
            text = @"点击使用";
            break;
            
        default:
            break;
    }
    return  text;
}

- (UIColor *)progressColor {
    switch (_status) {
        case 1:
            return [UIColor blueColor];
            break;
        case 2:
            return [UIColor yellowColor];
            break;
        case 3:
            return [UIColor lightGrayColor];
            break;
            
        default:
            return [UIColor whiteColor];
            break;
    }
}

@end
