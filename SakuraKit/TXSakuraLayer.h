//
//  TXSakuraLayer.h
//  SakuraDemo_OC
//
//  Created by tingxins on 21/08/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakura.h"

TXSakuraBlockDeclare(TXSakuraLayer)

@interface TXSakuraLayer : TXSakura

- (TXSakuraLayerBlock)backgroundColor;
- (TXSakuraLayerBlock)borderColor;
- (TXSakuraLayerBlock)shadowColor;
- (TXSakuraLayerBlock)borderWidth;

@end

TXSakuraCategoryDeclare(CALayer, TXSakuraLayer)
