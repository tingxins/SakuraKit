//
//  NSObject+TXExeDeallocBlock.m
//  SakuraKit
//
//  Created by tingxins on 22/02/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "NSObject+TXExeDeallocBlock.h"
#import "TXExeDeallocBlock.h"
#import <objc/runtime.h>

@implementation NSObject (TXExeDeallocBlock)

- (void)tx_runBlockAtDealloc:(void (^)(void))block {
    if (block) {
        TXExeDeallocBlock *executor = [[TXExeDeallocBlock alloc] initWithBlock:block];
        objc_setAssociatedObject(self, (__bridge const void *)(executor), executor, OBJC_ASSOCIATION_RETAIN);
    }
}

@end
