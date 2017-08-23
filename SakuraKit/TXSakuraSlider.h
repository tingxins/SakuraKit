//
//  TXSakuraSlider.h
//  SakuraKit
//
//  Created by tingxins on 29/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraView.h"

TXSakuraBlockDeclare(TXSakuraSlider)

@interface TXSakuraSlider : TXSakuraView

// UIView
- (TXSakuraSliderBlock)backgroundColor;
- (TXSakuraSliderBlock)alpha;
- (TXSakuraSliderBlock)tintColor;

//UISlider
- (TXSakuraSliderBlock)thumbTintColor;
- (TXSakuraSliderBlock)maximumTrackTintColor;
- (TXSakuraSliderBlock)minimumTrackTintColor;

@end

TXSakuraCategoryDeclare(UISlider, TXSakuraSlider)
