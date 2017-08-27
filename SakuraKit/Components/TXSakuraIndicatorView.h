//
//  TXSakuraIndicatorView.h
//  SakuraKit
//
//  Created by tingxins on 29/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakura.h"

TXSakuraBlockDeclare(TXSakuraIndicatorView)

@interface TXSakuraIndicatorView : TXSakura

- (TXSakuraIndicatorViewBlock)activityIndicatorViewStyle;
- (TXSakuraIndicatorViewBlock)color;

@end

TXSakuraCategoryDeclare(UIActivityIndicatorView, TXSakuraIndicatorView)
