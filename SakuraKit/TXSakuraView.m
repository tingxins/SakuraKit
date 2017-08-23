//
//  TXSakuraView.m
//  SakuraKit
//
//  Created by tingxins on 23/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraView.h"

@interface TXSakuraView()

@end

@implementation TXSakuraView

- (TXSakuraViewBlock)backgroundColor {
    return (TXSakuraViewBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraViewBlock)alpha {
    return (TXSakuraViewBlock)[super tx_sakuraFloatBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraViewBlock)tintColor {
    return (TXSakuraViewBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

@end

TXSakuraCategoryImplementation(UIView, TXSakuraView)
