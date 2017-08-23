//
//  TXSakuraShapeLayer.h
//  SakuraDemo_OC
//
//  Created by tingxins on 21/08/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraLayer.h"

TXSakuraBlockDeclare(TXSakuraShapeLayer)

@interface TXSakuraShapeLayer : TXSakuraLayer

#pragma mark - Override
- (TXSakuraShapeLayerBlock)backgroundColor;
- (TXSakuraShapeLayerBlock)borderColor;
- (TXSakuraShapeLayerBlock)shadowColor;
- (TXSakuraShapeLayerBlock)borderWidth;

#pragma mark - Owner
- (TXSakuraShapeLayerBlock)fillColor;
- (TXSakuraShapeLayerBlock)strokeColor;
- (TXSakuraShapeLayerBlock)lineWidth;

@end

TXSakuraCategoryDeclare(CAShapeLayer, TXSakuraShapeLayer)
