//
//  TXSakuraImageView.h
//  SakuraKit
//
//  Created by tingxins on 26/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraView.h"
TXSakuraBlockDeclare(TXSakuraImageView)

@interface TXSakuraImageView : TXSakuraView
//UIView
- (TXSakuraImageViewBlock)backgroundColor;
- (TXSakuraImageViewBlock)alpha;
- (TXSakuraImageViewBlock)tintColor;

// UIImageView
- (TXSakuraImageViewBlock)highlighted;
- (TXSakuraImageViewBlock)image;
- (TXSakuraImageViewBlock)highlightedImage;

@end

TXSakuraCategoryDeclare(UIImageView, TXSakuraImageView)
