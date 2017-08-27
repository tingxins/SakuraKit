//
//  TXSakuraPageControl.h
//  SakuraKit
//
//  Created by tingxins on 29/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraView.h"

TXSakuraBlockDeclare(TXSakuraPageControl)

@interface TXSakuraPageControl : TXSakuraView
// UIView
- (TXSakuraPageControlBlock)backgroundColor;
- (TXSakuraPageControlBlock)alpha;
- (TXSakuraPageControlBlock)tintColor;

// UIPageControl
- (TXSakuraPageControlBlock)pageIndicatorTintColor;
- (TXSakuraPageControlBlock)currentPageIndicatorTintColor;


@end

TXSakuraCategoryDeclare(UIPageControl, TXSakuraPageControl)
