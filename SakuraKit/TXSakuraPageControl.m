//
//  TXSakuraPageControl.m
//  SakuraKit
//
//  Created by tingxins on 29/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraPageControl.h"

@implementation TXSakuraPageControl

#pragma mark - UIView

- (TXSakuraPageControlBlock)backgroundColor {
    return (TXSakuraPageControlBlock)[super backgroundColor];
}

- (TXSakuraPageControlBlock)alpha {
    return (TXSakuraPageControlBlock)[super alpha];
}

- (TXSakuraPageControlBlock)tintColor {
    return (TXSakuraPageControlBlock)[super tintColor];
}

#pragma mark - UIPageControl

- (TXSakuraPageControlBlock)pageIndicatorTintColor {
    return (TXSakuraPageControlBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraPageControlBlock)currentPageIndicatorTintColor {
    return (TXSakuraPageControlBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

@end

TXSakuraCategoryImplementation(UIPageControl, TXSakuraPageControl)
