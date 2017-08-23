//
//  TXSakuraButton.m
//  SakuraKit
//
//  Created by tingxins on 26/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraButton.h"

@implementation TXSakuraButton

#pragma mark - UIView

- (TXSakuraButtonBlock)backgroundColor {
    return (TXSakuraButtonBlock)[super backgroundColor];
}

- (TXSakuraButtonBlock)alpha {
    return (TXSakuraButtonBlock)[super alpha];
}

- (TXSakuraButtonBlock)tintColor {
    return (TXSakuraButtonBlock)[super tintColor];
}

#pragma mark - UIButton

- (TXSakuraButton2DStateBlock)titleColor {
    return (TXSakuraButton2DStateBlock)[super tx_sakuraTitleColorForStateBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraButton2DStateBlock)image {
    return (TXSakuraButton2DStateBlock)[super tx_sakuraImageForStateBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraButton2DStateBlock)backgroundImage {
    return (TXSakuraButton2DStateBlock)[super tx_sakuraImageForStateBlockWithName:NSStringFromSelector(_cmd)];
}

@end

TXSakuraCategoryImplementation(UIButton, TXSakuraButton)
