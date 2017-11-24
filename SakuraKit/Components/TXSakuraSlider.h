//
//  TXSakuraSlider.h
//  SakuraKit
//
//  Created by tingxins on 29/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraView.h"

TXSakuraBlockDeclare(TXSakuraSlider)
TXSakura2DStateBlockDeclare(TXSakuraSlider)
@interface TXSakuraSlider : TXSakuraView

// UIView
- (TXSakuraSliderBlock)backgroundColor;
- (TXSakuraSliderBlock)alpha;
- (TXSakuraSliderBlock)tintColor;

//UISlider
- (TXSakuraSliderBlock)thumbTintColor;
- (TXSakuraSliderBlock)maximumTrackTintColor;
- (TXSakuraSliderBlock)minimumTrackTintColor;
- (TXSakuraSlider2DStateBlock)thumbImage;
- (TXSakuraSlider2DStateBlock)maximumTrackImage;
- (TXSakuraSlider2DStateBlock)minimumTrackImage;
@end

TXSakuraCategoryDeclare(UISlider, TXSakuraSlider)
