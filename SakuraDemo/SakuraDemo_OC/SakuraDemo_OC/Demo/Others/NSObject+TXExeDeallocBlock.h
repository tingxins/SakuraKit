//
//  NSObject+TXExeDeallocBlock.h
//  SakuraKit
//
//  Created by tingxins on 22/02/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TXExeDeallocBlock)

- (void)tx_runBlockAtDealloc:(void(^)(void))block;

@end
