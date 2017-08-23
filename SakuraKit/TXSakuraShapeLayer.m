//
//  TXSakuraShapeLayer.m
//  SakuraDemo_OC
//
//  Created by tingxins on 21/08/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraShapeLayer.h"

@implementation TXSakuraShapeLayer

#pragma mark - Override

- (TXSakuraShapeLayerBlock)backgroundColor {
    return (TXSakuraShapeLayerBlock)[super backgroundColor];
}

- (TXSakuraShapeLayerBlock)borderColor {
    return (TXSakuraShapeLayerBlock)[super borderColor];
}

- (TXSakuraShapeLayerBlock)shadowColor {
    return (TXSakuraShapeLayerBlock)[super shadowColor];
}

- (TXSakuraShapeLayerBlock)borderWidth {
    return (TXSakuraShapeLayerBlock)[super borderWidth];
}

#pragma mark - Owner

- (TXSakuraShapeLayerBlock)fillColor {
    return (TXSakuraShapeLayerBlock)[super tx_sakuraCGColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraShapeLayerBlock)strokeColor {
    return (TXSakuraShapeLayerBlock)[super tx_sakuraCGColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraShapeLayerBlock)lineWidth {
    return (TXSakuraShapeLayerBlock)[super tx_sakuraFloatBlockWithName:NSStringFromSelector(_cmd)];
}

@end


TXSakuraCategoryImplementation(CAShapeLayer, TXSakuraShapeLayer)
