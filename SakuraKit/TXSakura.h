//
//  TXSakura.h
//  SakuraKit
//
//  Created by tingxins on 23/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//
/** Category declare */
#define TXSakuraCategoryDeclare(ClassName, PropertyClassName)\
@interface ClassName (TX)\
@property (strong, nonatomic) PropertyClassName *sakura;\
@end

#define TXSakuraCategoryImplementation(ClassName, PropertyClassName)\
extern void *kTXSakuraKey;\
@implementation ClassName(TX)\
@dynamic sakura;\
- (PropertyClassName *)sakura {\
    PropertyClassName *obj = objc_getAssociatedObject(self, kTXSakuraKey);\
    if (!obj) {\
        obj = [PropertyClassName sakuraWithOwner:self];\
        objc_setAssociatedObject(self, kTXSakuraKey, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
    }\
    return obj;\
}\
@end

/** Sakura Block declare */
#define TXSakuraBlockDeclare(Class)\
@class Class;\
typedef Class *(^Class##Block)(NSString *);

#define TXSakura2DStateBlockDeclare(Class)\
typedef Class *(^Class##2DStateBlock)(NSString *, UIControlState);

#define TXSakura2DBoolBlockDeclare(Class)\
typedef Class *(^Class##2DBoolBlock)(NSString *, BOOL);

#define TXSakura2DUIntBlockDeclare(Class)\
typedef Class *(^Class##2DUIntBlock)(NSString *, NSUInteger);

#define TXSakuraBlockCustomDeclare(Class)\
typedef Class *(^Class##CustomBlock)(NSString *propertyName, NSString *keyPath);


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

TXSakuraBlockDeclare(TXSakura)
TXSakura2DUIntBlockDeclare(TXSakura)
TXSakura2DBoolBlockDeclare(TXSakura)

UIKIT_EXTERN NSString *const TXSakuraSkinChangeNotification;

@interface TXSakura : NSObject

/** Just get all 1D skin objs which under sakura control. */
@property (strong, nonatomic, readonly) NSDictionary *skins1D;

/** Just get all 2D skin objs which under sakura control. */
@property (strong, nonatomic, readonly) NSDictionary *skins2D;

/** Get ower of current sakura. */
@property (weak, nonatomic, readonly) id owner;

+ (instancetype)sakuraWithOwner:(id)owner;

- (instancetype)initWithOwner:(id)owner;

/** Set rendering mode of UIImage.(UIImageRenderingModeAlwaysOriginal default.) */
- (void)setImageRenderingMode:(UIImageRenderingMode)renderingMode;

@end

@interface TXSakura(TXBlocker)

#pragma mark - 1D Block

/** Change and Cache skin to sakura. */
- (TXSakuraBlock)tx_sakuraFloatBlockWithName:(NSString *)name;

- (TXSakuraBlock)tx_sakuraColorBlockWithName:(NSString *)name;

- (TXSakuraBlock)tx_sakuraCGColorBlockWithName:(NSString *)name;

- (TXSakuraBlock)tx_sakuraTitleBlockWithName:(NSString *)name;

- (TXSakuraBlock)tx_sakuraFontBlockWithName:(NSString *)name;

- (TXSakuraBlock)tx_sakuraKeyboardAppearanceBlockWithName:(NSString *)name;

- (TXSakuraBlock)tx_sakuraTitleTextAttributesBlockWithName:(NSString *)name;

- (TXSakuraBlock)tx_sakuraBoolBlockWithName:(NSString *)name;

- (TXSakuraBlock)tx_sakuraImageBlockWithName:(NSString *)name;

- (TXSakuraBlock)tx_sakuraIndicatorViewStyleBlockWithName:(NSString *)name;

- (TXSakuraBlock)tx_sakuraBarStyleBlockWithName:(NSString *)name;

#pragma mark - 2D Block

- (TXSakura2DUIntBlock)tx_sakuraTitleColorForStateBlockWithName:(NSString *)name;

- (TXSakura2DUIntBlock)tx_sakuraImageForStateBlockWithName:(NSString *)name;

- (TXSakura2DUIntBlock)tx_sakuraTitleTextAttributesForStateBlockWithName:(NSString *)name;

- (TXSakura2DBoolBlock)tx_sakuraApplicationForStyleBlockWithName:(NSString *)name;

@end

TXSakuraCategoryDeclare(NSObject, TXSakura)

