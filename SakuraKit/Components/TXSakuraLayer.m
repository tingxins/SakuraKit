//
//  TXSakuraLayer.m
//  SakuraDemo_OC
//
//  Created by tingxins on 21/08/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraLayer.h"

@implementation TXSakuraLayer

- (TXSakuraLayerBlock)backgroundColor {
    return (TXSakuraLayerBlock)[super tx_sakuraCGColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraLayerBlock)borderColor {
    return (TXSakuraLayerBlock)[super tx_sakuraCGColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraLayerBlock)shadowColor {
    return (TXSakuraLayerBlock)[super tx_sakuraCGColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraLayerBlock)borderWidth {
    return (TXSakuraLayerBlock)[super tx_sakuraFloatBlockWithName:NSStringFromSelector(_cmd)];
}

@end

TXSakuraCategoryImplementation(CALayer, TXSakuraLayer)
