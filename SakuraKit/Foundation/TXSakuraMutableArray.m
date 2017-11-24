//
//  TXSakuraMutableArray.m
//  SakuraDemo_OC
//
//  Created by 王续敏 on 2017/11/24.
//  Copyright © 2017年 tingxins. All rights reserved.
//

#import "TXSakuraMutableArray.h"
@implementation TXSakuraMutableArray

- (TXSakuraMutableArrayBlock)array{
    return (TXSakuraMutableArrayBlock)[super tx_sakuraArrayBlockWithName:NSStringFromSelector(_cmd)];
}
@end
TXSakuraCategoryImplementation(NSMutableArray, TXSakuraMutableArray)
