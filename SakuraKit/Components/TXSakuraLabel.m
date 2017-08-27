//
//  TXSakuraLabel.m
//  SakuraKit
//
//  Created by tingxins on 23/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraLabel.h"

@interface TXSakuraLabel()

@end

@implementation TXSakuraLabel

#pragma mark - UIView

- (TXSakuraLabelBlock)backgroundColor {
    return (TXSakuraLabelBlock)[super backgroundColor];
}

- (TXSakuraLabelBlock)alpha {
    return (TXSakuraLabelBlock)[super alpha];
}

- (TXSakuraLabelBlock)tintColor {
    return (TXSakuraLabelBlock)[super tintColor];
}

#pragma mark - UILabel

- (TXSakuraLabelBlock)highlighted {
    return (TXSakuraLabelBlock)[super tx_sakuraBoolBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraLabelBlock)highlightedTextColor {
    return (TXSakuraLabelBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraLabelBlock)shadowColor {
    return (TXSakuraLabelBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraLabelBlock)textColor {
    return (TXSakuraLabelBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraLabelBlock)font {
    return (TXSakuraLabelBlock)[super tx_sakuraFontBlockWithName:NSStringFromSelector(_cmd)];
}

@end

TXSakuraCategoryImplementation(UILabel, TXSakuraLabel)
