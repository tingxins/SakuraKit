//
//  TXSakuraSlider.m
//  SakuraKit
//
//  Created by tingxins on 29/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraSlider.h"

@implementation TXSakuraSlider

#pragma mark - UIView

- (TXSakuraSliderBlock)backgroundColor {
    return (TXSakuraSliderBlock)[super backgroundColor];
}

- (TXSakuraSliderBlock)alpha {
    return (TXSakuraSliderBlock)[super alpha];
}

- (TXSakuraSliderBlock)tintColor {
    return (TXSakuraSliderBlock)[super tintColor];
}

#pragma mark - UISlider

- (TXSakuraSliderBlock)thumbTintColor {
    return (TXSakuraSliderBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraSliderBlock)minimumTrackTintColor {
    return (TXSakuraSliderBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraSliderBlock)maximumTrackTintColor {
    return (TXSakuraSliderBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}
- (TXSakuraSlider2DStateBlock)thumbImage{
    return (TXSakuraSlider2DStateBlock)[super tx_sakuraImageForStateBlockWithName:NSStringFromSelector(_cmd)];
}
- (TXSakuraSlider2DStateBlock)maximumTrackImage{
    return (TXSakuraSlider2DStateBlock)[super tx_sakuraImageForStateBlockWithName:NSStringFromSelector(_cmd)];
}
- (TXSakuraSlider2DStateBlock)minimumTrackImage{
    return (TXSakuraSlider2DStateBlock)[super tx_sakuraImageForStateBlockWithName:NSStringFromSelector(_cmd)];
}
@end

TXSakuraCategoryImplementation(UISlider, TXSakuraSlider)
