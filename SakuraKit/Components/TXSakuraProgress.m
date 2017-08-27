//
//  TXSakuraProgress.m
//  SakuraKit
//
//  Created by tingxins on 29/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraProgress.h"

@implementation TXSakuraProgress

#pragma mark - UIView

- (TXSakuraProgressBlock)backgroundColor {
    return (TXSakuraProgressBlock)[super backgroundColor];
}

- (TXSakuraProgressBlock)alpha {
    return (TXSakuraProgressBlock)[super alpha];
}

- (TXSakuraProgressBlock)tintColor {
    return (TXSakuraProgressBlock)[super tintColor];
}

#pragma mark - UIProgressView

- (TXSakuraProgressBlock)trackTintColor {
    return (TXSakuraProgressBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraProgressBlock)progressTintColor {
    return (TXSakuraProgressBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

@end

TXSakuraCategoryImplementation(UIProgressView, TXSakuraProgress)
