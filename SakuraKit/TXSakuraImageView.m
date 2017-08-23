//
//  TXSakuraImageView.m
//  SakuraKit
//
//  Created by tingxins on 26/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraImageView.h"

@implementation TXSakuraImageView

#pragma mark - UIView

- (TXSakuraImageViewBlock)backgroundColor {
    return (TXSakuraImageViewBlock)[super backgroundColor];
}

- (TXSakuraImageViewBlock)alpha {
    return (TXSakuraImageViewBlock)[super alpha];
}

- (TXSakuraImageViewBlock)tintColor {
    return (TXSakuraImageViewBlock)[super tintColor];
}

#pragma mark - UIImageView

- (TXSakuraImageViewBlock)highlighted {
    return (TXSakuraImageViewBlock)[super tx_sakuraBoolBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraImageViewBlock)image {
    return (TXSakuraImageViewBlock)[super tx_sakuraImageBlockWithName:NSStringFromSelector(_cmd)];
}
- (TXSakuraImageViewBlock)highlightedImage {
    return (TXSakuraImageViewBlock)[super tx_sakuraImageBlockWithName:NSStringFromSelector(_cmd)];
}


@end

TXSakuraCategoryImplementation(UIImageView, TXSakuraImageView)
