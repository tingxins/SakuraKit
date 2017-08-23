//
//  TXExeDeallocBlock.m
//  SakuraKit
//
//  Created by tingxins on 22/02/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXExeDeallocBlock.h"


@implementation TXExeDeallocBlock{
    TXDeallocBlock _block;
}

- (instancetype)initWithBlock:(TXDeallocBlock)block {
    if (self = [super init]) {
        _block = [block copy];
    }
    return self;
}

- (void)dealloc {
    
    _block ? _block() : nil;
}

@end
