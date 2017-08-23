//
//  TXSakuraView.h
//  SakuraKit
//
//  Created by tingxins on 23/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakura.h"

TXSakuraBlockDeclare(TXSakuraView)
//typedef TXSakuraView *(^TXSakuraViewBlock)(NSString *);


//TXSakuraBlockCustomDeclare(TXSakuraView);
//// Custom
//- (TXSakuraViewCustomBlock)custom;
@interface TXSakuraView : TXSakura
- (TXSakuraViewBlock)backgroundColor;
- (TXSakuraViewBlock)alpha;
- (TXSakuraViewBlock)tintColor;
@end

TXSakuraCategoryDeclare(UIView, TXSakuraView)

