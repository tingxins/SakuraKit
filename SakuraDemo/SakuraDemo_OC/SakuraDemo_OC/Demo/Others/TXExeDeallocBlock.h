//
//  TXExeDeallocBlock.h
//  SakuraKit
//
//  Created by tingxins on 22/02/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//  http://blog.slaunchaman.com/2011/04/11/fun-with-the-objective-c-runtime-run-code-at-deallocation-of-any-object/

typedef void(^TXDeallocBlock)(void);

#import <Foundation/Foundation.h>

@interface TXExeDeallocBlock : NSObject

- (instancetype)initWithBlock:(TXDeallocBlock)block;

@end
