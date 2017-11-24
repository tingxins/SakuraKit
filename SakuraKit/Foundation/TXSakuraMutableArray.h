//
//  TXSakuraMutableArray.h
//  SakuraDemo_OC
//
//  Created by 王续敏 on 2017/11/24.
//  Copyright © 2017年 tingxins. All rights reserved.
//

#import "TXSakura.h"
TXSakuraBlockDeclare(TXSakuraMutableArray)
@interface TXSakuraMutableArray : TXSakura
- (TXSakuraMutableArrayBlock)array;
@end
TXSakuraCategoryDeclare(NSMutableArray, TXSakuraMutableArray)
