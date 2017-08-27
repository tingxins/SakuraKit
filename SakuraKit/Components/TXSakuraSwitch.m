//
//  TXSakuraSwitch.m
//  SakuraKit
//
//  Created by tingxins on 29/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraSwitch.h"

@implementation TXSakuraSwitch

#pragma mark - UIView

- (TXSakuraSwitchBlock)backgroundColor {
    return (TXSakuraSwitchBlock)[super backgroundColor];
}

- (TXSakuraSwitchBlock)alpha {
    return (TXSakuraSwitchBlock)[super alpha];
}

- (TXSakuraSwitchBlock)tintColor {
    return (TXSakuraSwitchBlock)[super tintColor];
}

#pragma mark - UISwitch

- (TXSakuraSwitchBlock)onTintColor {
    return (TXSakuraSwitchBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraSwitchBlock)thumbTintColor {
    return (TXSakuraSwitchBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

@end

TXSakuraCategoryImplementation(UISwitch, TXSakuraSwitch)
