//
//  TXSakura.m
//  SakuraKit
//
//  Created by tingxins on 23/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//


#import "TXSakura.h"
#import <objc/message.h>
#import "TXSakuraManager.h"
#import "TXSakuraTrash.h"

#pragma mark - FORMAT OF SEL

char *const kTXSakuraSELHeader = "set";
char *const kTXSakuraSELCon = ":";
NSString *const kTXSakura2DStateSELTail = @"forState:";
NSString *const kTXSakura2DAnimatedSELTail = @"animated:";

#pragma mark - Config TYPE OF ARG

NSString *const kTXSakuraArgCustomInt = @"com.tingxins.sakura.arg.custom.int";

#pragma mark - Config TYPE OF ARG

NSString *const kTXSakuraArgBool = @"com.tingxins.sakura.arg.bool";
NSString *const kTXSakuraArgFloat = @"com.tingxins.sakura.arg.float";
NSString *const kTXSakuraArgInt = @"com.tingxins.sakura.arg.int";
NSString *const kTXSakuraArgColor = @"com.tingxins.sakura.arg.color";
NSString *const kTXSakuraArgCGColor = @"com.tingxins.sakura.arg.cgColor";
NSString *const kTXSakuraArgFont = @"com.tingxins.sakura.arg.font";
NSString *const kTXSakuraArgImage = @"com.tingxins.sakura.arg.image";
NSString *const kTXSakuraArgTextAttributes = @"com.tingxins.sakura.arg.textAttributes";
NSString *const kTXSakuraArgStatusBarStyle = @"com.tingxins.sakura.arg.statusBarStyle";
NSString *const kTXSakuraArgBarStyle = @"com.tingxins.sakura.arg.barStyle";
NSString *const kTXSakuraArgTitle = @"com.tingxins.sakura.arg.title";
NSString *const kTXSakuraArgKeyboardAppearance = @"com.tingxins.sakura.arg.keyboardAppearance";
NSString *const kTXSakuraActivityIndicatorViewStyle = @"com.tingxins.sakura.arg.activityIndicatorViewStyle";


#pragma mark - FUNC VAR

NSString *const TXSakuraSkinChangeNotification = @"com.tingxins.sakura.notification.skinChange";
NSTimeInterval const TXSakuraSkinChangeDuration = 0.25;

@interface TXSakura ()

@property (assign, nonatomic) UIImageRenderingMode imageRenderingMode;
// single arg
@property (strong, nonatomic) NSDictionary *innerSkins1D;
// double args
@property (strong, nonatomic) NSDictionary *innerSkins2D;

@end

@implementation TXSakura

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXSakuraSkinChangeNotification object:nil];
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Please use +sakuraWithOwner: method instead." userInfo:nil];
}

- (NSDictionary *)innerSkins1D {
    if (_innerSkins1D) return _innerSkins1D;
    return _innerSkins1D = [NSMutableDictionary dictionary];
}

- (NSDictionary *)innerSkins2D {
    if (_innerSkins2D) return _innerSkins2D;
    return _innerSkins2D = [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)getSkins1D {
    return (NSMutableDictionary *)self.innerSkins1D;
}

- (NSMutableDictionary *)getSkins2D {
    return (NSMutableDictionary *)self.innerSkins2D;
}

- (NSDictionary *)skins1D {
    return [NSDictionary dictionaryWithDictionary:self.innerSkins1D];
}

- (NSDictionary *)skins2D {
    return [NSDictionary dictionaryWithDictionary:self.innerSkins2D];
}

- (instancetype)initWithOwner:(id)owner {
    if (self = [super init]) {
        _owner = owner;
        _imageRenderingMode = UIImageRenderingModeAlwaysOriginal;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSakuraSkins) name:TXSakuraSkinChangeNotification object:nil];
    }
    return self;
}

+ (instancetype)sakuraWithOwner:(id)owner {
    return [[self alloc] initWithOwner:owner];
}

- (void)setImageRenderingMode:(UIImageRenderingMode)renderingMode {
    _imageRenderingMode = renderingMode;
    
}

/** Update skins */
- (void)updateSakuraSkins {
    // 一维参数
    [self updateSakuraWith1DSkins:self.skins1D];
    // 二维参数
    [self updateSakuraWith2DSkins:self.skins2D];
    
}

#pragma mark - Test Refactor

- (id)getObjVectorWithSakuraArgType:(NSString *)argType path:(NSString *)path exist:(BOOL *)flag {
    NSString *selStr = [[TXSakuraManager tx_getObjVectorOperationKV] objectForKey:argType];
    if (selStr.length && path.length) {
        *flag = YES;
        SEL sel = NSSelectorFromString(selStr);
        id(*msg)(id, SEL, id) = (id(*)(id, SEL, id))objc_msgSend;
        id vector = msg(TXSakuraManager.class, sel, path);
        if ([vector isKindOfClass:[UIImage class]]) {
            vector = [(UIImage *)vector imageWithRenderingMode:_imageRenderingMode];
        }
        return vector;
    }
    *flag = NO;
    return nil;
}

- (NSInteger)getIntVectorWithSakuraArgType:(NSString *)argType path:(NSString *)path exist:(BOOL *)flag {
    
    NSString *selStr = [[TXSakuraManager tx_getIntVectorOperationKV] objectForKey:argType];
    if (selStr.length && path.length) {
        *flag = YES;
        SEL sel = NSSelectorFromString(selStr);
        NSInteger(*msg)(id, SEL, id) = (NSInteger(*)(id, SEL, id))objc_msgSend;
        NSInteger vector = msg(TXSakuraManager.class, sel, path);
        return vector;
    }
    *flag = NO;
    return 0;
}

- (CGFloat)getFloatVectorWithSakuraArgType:(NSString *)argType path:(NSString *)path exist:(BOOL *)flag {
    
    NSString *selStr = [[TXSakuraManager tx_getFloatVectorOperationKV] objectForKey:argType];
    if (selStr.length && path.length) {
        *flag = YES;
        SEL sel = NSSelectorFromString(selStr);
        CGFloat(*msg)(id, SEL, id) = (CGFloat(*)(id, SEL, id))objc_msgSend;
        CGFloat vector = msg(TXSakuraManager.class, sel, path);
        return vector;
    }
    *flag = NO;
    return 0;
}

#pragma mark - 1D Update Methods

- (void)updateSakuraWith1DSkins:(NSDictionary *)sakuraSkins1D {

    [sakuraSkins1D enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        SEL sel = NSSelectorFromString((NSString *)key);
        if (![obj isKindOfClass:[NSDictionary class]]) return;
        NSDictionary *valueDict = (NSDictionary *)obj;
        NSArray *allKeys = valueDict.allKeys;
        
        NSString *skinKey = allKeys.firstObject;
        NSString *skinValue = valueDict[skinKey];
        
        BOOL flag = false;
        
        id firstObject = [self getObjVectorWithSakuraArgType:skinKey path:skinValue exist:&flag];
        
        if (flag) {
            [self send1DMsgWithSEL:sel objValue:firstObject];
            return;
        }
        
        NSInteger intValue = [self getIntVectorWithSakuraArgType:skinKey path:skinValue exist:&flag];
        if (flag) {
            [self send1DMsgWithSEL:sel intValue:intValue];
            return;
        }
        
        CGFloat floatValue = [self getFloatVectorWithSakuraArgType:skinKey path:skinValue exist:&flag];
        if (flag) {
            [self send1DMsgWithSEL:sel floatValue:floatValue];
            return;
        }
    }];
}

#pragma mark - 2D Update Methods

- (void)updateSakuraWith2DSkins:(NSDictionary *)sakuraSkins2D {

    [sakuraSkins2D enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        SEL sel = NSSelectorFromString((NSString *)key);
        if (![obj isKindOfClass:[NSDictionary class]]) return;
        NSDictionary *valueDict = (NSDictionary *)obj;
        
        NSNumber *numValue = valueDict[kTXSakuraArgCustomInt];
        NSMutableDictionary *tempValueDict = [NSMutableDictionary dictionaryWithDictionary:valueDict];
        [tempValueDict removeObjectForKey:kTXSakuraArgCustomInt];
        
        NSString *skinKey = tempValueDict.allKeys.firstObject;
        NSString *skinValue = tempValueDict[skinKey];
        
        BOOL flag = false;
        id firstObject = [self getObjVectorWithSakuraArgType:skinKey path:skinValue exist:&flag];
        if (flag) {
            [self enumObjectTypeMsg2DSendWithSEL:sel object:firstObject numValue:numValue];
            return;
        }
        
        NSInteger intValue = [self getIntVectorWithSakuraArgType:skinKey path:skinValue exist:&flag];
        if (flag) {
            [self enumValueTypeMsg2DSendWithSEL:sel intValue:intValue numValue:numValue];
            return;
        }
    }];
}

// obj + number
- (void)enumObjectTypeMsg2DSendWithSEL:(SEL)sel
                                object:(NSObject *)object
                              numValue:(NSNumber *)numValue {
    if (object) {//状态
        NSInteger value = [numValue integerValue];
        NSString *selStr = NSStringFromSelector(sel);
        NSString *occurrencesStr = [NSString stringWithFormat:@"%ld",(long)value];
        selStr = [selStr stringByReplacingOccurrencesOfString:occurrencesStr withString:@""];
        SEL realSel = NSSelectorFromString(selStr);
        [self send2DMsgWithSEL:realSel object:object intValue:value];
    }
}

// int + number
- (void)enumValueTypeMsg2DSendWithSEL:(SEL)sel
                             intValue:(NSInteger)intValue
                             numValue:(NSNumber *)numValue {
    NSInteger value = [numValue integerValue];
    NSString *selStr = NSStringFromSelector(sel);
    NSString *occurrencesStr = [NSString stringWithFormat:@"%ld",(long)value];
    selStr = [selStr stringByReplacingOccurrencesOfString:occurrencesStr withString:@""];
    SEL realSel = NSSelectorFromString(selStr);
    [self send2DMsgWithSEL:realSel intValue:intValue intValue:value];
}

#pragma mark - Message Methods


#pragma mark - 1D

- (instancetype)send1DMsgEnumWithName:(NSString *)name
                              keyPath:(NSString *)keyPath
                                  arg:(NSString *)arg
                           valueBlock:(NSInteger (^)(NSString *))valueBlock {
    return [self send1DMsgIntWithName:name keyPath:keyPath arg:arg valueBlock:valueBlock];
}

- (instancetype)send1DMsgObjectWithName:(NSString *)name
                                keyPath:(NSString *)keyPath
                                    arg:(NSString *)arg
                             valueBlock:(id(^)(NSString *))valueBlock {
    // Cache
    SEL sel = [self prepareForSkin1DWithName:name keyPath:keyPath argKey:arg];
    
    // MsgSend
    if (!valueBlock) return [TXSakuraTrash sakuraWithOwner:self];
    NSObject *obj = valueBlock(keyPath);
    //    valueBlock = nil;
    [self send1DMsgWithSEL:sel objValue:obj];
    return self;
}

- (instancetype)send1DMsgStructWithName:(NSString *)name
                                keyPath:(NSString *)keyPath
                                    arg:(NSString *)arg
                             valueBlock:(id (^)(NSString *))valueBlock {
    // Cache
    SEL sel = [self prepareForSkin1DWithName:name keyPath:keyPath argKey:arg];
    
    // MsgSend
    if (!valueBlock) return [TXSakuraTrash sakuraWithOwner:self];
    id obj = valueBlock(keyPath);
    //    valueBlock = nil;
    [self send1DMsgWithSEL:sel structValue:obj];
    return self;
}

- (instancetype)send1DMsgIntWithName:(NSString *)name
                             keyPath:(NSString *)keyPath
                                 arg:(NSString *)arg
                          valueBlock:(NSInteger (^)(NSString *))valueBlock {
    // Cache
    SEL sel = [self prepareForSkin1DWithName:name keyPath:keyPath argKey:arg];
    
    // MsgSend
    if (!valueBlock) return [TXSakuraTrash sakuraWithOwner:self];
    NSInteger value = valueBlock(keyPath);
    //    valueBlock = nil;
    [self send1DMsgWithSEL:sel intValue:value];
    return self;
}

- (instancetype)send1DMsgFloatWithName:(NSString *)name
                               keyPath:(NSString *)keyPath
                                   arg:(NSString *)arg
                            valueBlock:(CGFloat (^)(NSString *))valueBlock {// Cache
    SEL sel = [self prepareForSkin1DWithName:name keyPath:keyPath argKey:arg];
    
    // MsgSend
    if (!valueBlock) return [TXSakuraTrash sakuraWithOwner:self];
    CGFloat value = valueBlock(keyPath);
    //    valueBlock = nil;
    [self send1DMsgWithSEL:sel floatValue:value];
    return self;
}

- (SEL)prepareForSkin1DWithName:(NSString *)name
                        keyPath:(NSString *)keyPath
                         argKey:(NSString *)argKey {
    const char *charName = name.UTF8String;
    SEL sel = getSelectorWithPattern(kTXSakuraSELHeader, charName, kTXSakuraSELCon);
    
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    [attrDict setObject:keyPath forKey:argKey];
    [[self getSkins1D] setObject:attrDict forKey:NSStringFromSelector(sel)];
    return sel;
}

#pragma mark - 1D MsgSend

// 浮点
- (void)send1DMsgWithSEL:(SEL)sel
              floatValue:(CGFloat)value {
    if ([self.owner respondsToSelector:sel]) {
        void(*msg)(id, SEL, CGFloat) = (void(*)(id, SEL, CGFloat))objc_msgSend;
        msg(self.owner, sel, value);
    }
}

- (BOOL)send1DMsgWithSEL:(SEL)sel
             structValue:(id)obj {
    if (!obj ||
        ![self.owner respondsToSelector:sel]) return NO;
    void(*msg)(id, SEL, id) = (void(*)(id, SEL, id))objc_msgSend;
    if ([obj isKindOfClass:[UIColor class]]) {
        [UIView animateWithDuration:TXSakuraSkinChangeDuration animations:^{
            msg(self.owner, sel, obj);
        }];
    }else {
        msg(self.owner, sel, obj);
    }
    return YES;
}

// 对象
- (BOOL)send1DMsgWithSEL:(SEL)sel
                objValue:(id)obj {
    if (!obj ||
        ![self.owner respondsToSelector:sel]) return NO;
    void(*msg)(id, SEL, id) = (void(*)(id, SEL, id))objc_msgSend;
    if ([obj isKindOfClass:[UIColor class]]) {
        [UIView animateWithDuration:TXSakuraSkinChangeDuration animations:^{
            msg(self.owner, sel, obj);
        }];
    }else {
        msg(self.owner, sel, obj);
    }
    return YES;
}

// 整型
- (void)send1DMsgWithSEL:(SEL)sel
                intValue:(NSInteger)value {
    if ([self.owner respondsToSelector:sel]) {
        void(*msg)(id, SEL, NSInteger) = (void(*)(id, SEL, NSInteger))objc_msgSend;
        msg(self.owner, sel, value);
    }
}

#pragma mark - 2

- (instancetype)send2DMsgIntAndIntWithName:(NSString *)name
                                   keyPath:(NSString *)keyPath
                                     integ:(NSInteger)integ
                                   selTail:(NSString *)selTail
                                   argType:(NSString *)arg
                                valueBlock:(NSInteger (^)(NSString *))valueBlock {
    
    SEL sel = [self prepareForSkin2DWithName:name keyPath:keyPath integ:integ argType:arg selTail:selTail];
    // MsgSend
    if (!valueBlock) return [TXSakuraTrash sakuraWithOwner:self];
    NSInteger value = valueBlock(keyPath);
    //    valueBlock = nil;
    [self send2DMsgWithSEL:sel intValue:value intValue:integ];
    return self;
}

- (instancetype)send2DMsgObjectAndIntWithName:(NSString *)name
                                      keyPath:(NSString *)keyPath
                                        integ:(NSInteger)integ
                                      selTail:(NSString *)selTail
                                      argType:(NSString *)arg
                                   valueBlock:(NSObject *(^)(NSString *))valueBlock {
    
    SEL sel = [self prepareForSkin2DWithName:name keyPath:keyPath integ:integ argType:arg selTail:selTail];
    // MsgSend
    if (!valueBlock) return [TXSakuraTrash sakuraWithOwner:self];
    NSObject *obj = valueBlock(keyPath);
    //    valueBlock = nil;
    [self send2DMsgWithSEL:sel object:obj intValue:integ];
    return self;
}

- (SEL)prepareForSkin2DWithName:(NSString *)name
                        keyPath:(NSString *)keyPath
                          integ:(NSInteger)integ
                        argType:(NSString *)argKey
                        selTail:(NSString *)selTail {
    const char *charName = name.UTF8String;
    SEL sel = getSelectorWithPattern(kTXSakuraSELHeader, charName, kTXSakuraSELCon);
    
    NSString *selStr = [NSStringFromSelector(sel) stringByAppendingString:selTail];
    NSString *selStrAppend = [selStr stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)integ]];
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    [attrDict setObject:keyPath forKey:argKey];
    [attrDict setObject:@(integ) forKey:kTXSakuraArgCustomInt];
    [[self getSkins2D] setObject:attrDict forKey:selStrAppend];
    return NSSelectorFromString(selStr);
}

#pragma mark - 2 MsgSend

- (void)send2DMsgWithSEL:(SEL)sel
                  object:(NSObject *)obj
                intValue:(NSInteger)value {
    if (obj && [self.owner respondsToSelector:sel]) {
        void(*msg)(id, SEL, id, NSInteger) = (void(*)(id, SEL, id, NSInteger))objc_msgSend;
        msg(self.owner, sel, obj, value);
    }
}

- (void)send2DMsgWithSEL:(SEL)sel
                intValue:(NSInteger)value1
                intValue:(NSInteger)value2 {
    if ([self.owner respondsToSelector:sel]) {
        void(*msg)(id, SEL, NSInteger, NSInteger) = (void(*)(id, SEL, NSInteger, NSInteger))objc_msgSend;
        msg(self.owner, sel, value1, value2);
    }
}


@end

@implementation TXSakura(TXBlocker)

#pragma mark - 1D Block

- (TXSakuraBlock)tx_sakuraFloatBlockWithName:(NSString *)name {
    return ^TXSakura *(NSString *path){
        return [self send1DMsgFloatWithName:name keyPath:path arg:kTXSakuraArgFloat valueBlock:^CGFloat(NSString *keyPath) {
            return [TXSakuraManager tx_floatWithPath:keyPath];
        }];
    };
}

- (TXSakuraBlock)tx_sakuraColorBlockWithName:(NSString *)name {
    return ^TXSakura *(NSString *path){
        return [self send1DMsgObjectWithName:name keyPath:path arg:kTXSakuraArgColor valueBlock:^NSObject *(NSString *keyPath) {
            return [TXSakuraManager tx_colorWithPath:keyPath];
        }];
    };
}

- (TXSakuraBlock)tx_sakuraCGColorBlockWithName:(NSString *)name {
    return ^TXSakura *(NSString *path){
        return [self send1DMsgStructWithName:name keyPath:path arg:kTXSakuraArgCGColor valueBlock:^id (NSString *keyPath) {
            return (id)[TXSakuraManager tx_cgColorWithPath:keyPath];
        }];
    };
}

- (TXSakuraBlock)tx_sakuraTitleBlockWithName:(NSString *)name {
    return ^TXSakura *(NSString *path){
        return [self send1DMsgObjectWithName:name keyPath:path arg:kTXSakuraArgTitle valueBlock:^NSObject *(NSString *kayPath) {
            return [TXSakuraManager tx_stringWithPath:kayPath];
        }];
    };
}

- (TXSakuraBlock)tx_sakuraFontBlockWithName:(NSString *)name {
    return ^TXSakura *(NSString *path){
        return [self send1DMsgObjectWithName:name keyPath:path arg:kTXSakuraArgFont valueBlock:^NSObject *(NSString *keyPath) {
            return [TXSakuraManager tx_fontWithPath:keyPath];
        }];
    };
}

- (TXSakuraBlock)tx_sakuraKeyboardAppearanceBlockWithName:(NSString *)name {
    return ^TXSakura *(NSString *path){
        return [self send1DMsgEnumWithName:name keyPath:path arg:kTXSakuraArgKeyboardAppearance valueBlock:^NSInteger(NSString *keyPath) {
            return [TXSakuraManager tx_keyboardAppearanceWithPath:keyPath];
        }];
    };
}

- (TXSakuraBlock)tx_sakuraTitleTextAttributesBlockWithName:(NSString *)name {
    return ^TXSakura *(NSString *path){
        return [self send1DMsgObjectWithName:name keyPath:path arg:kTXSakuraArgTextAttributes valueBlock:^NSObject *(NSString *keyPath) {
            return [TXSakuraManager tx_titleTextAttributesDictionaryWithPath:keyPath];
        }];
    };
}

- (TXSakuraBlock)tx_sakuraBoolBlockWithName:(NSString *)name {
    return ^TXSakura *(NSString *path){
        return [self send1DMsgIntWithName:name keyPath:path arg:kTXSakuraArgBool valueBlock:^NSInteger(NSString *keyPath) {
            return [TXSakuraManager tx_boolWithPath:keyPath];
        }];
    };
}

- (TXSakuraBlock)tx_sakuraImageBlockWithName:(NSString *)name {
    return ^TXSakura *(NSString *path){
        return [self send1DMsgObjectWithName:name keyPath:path arg:kTXSakuraArgImage valueBlock:^NSObject *(NSString *keyPath) {
            return [TXSakuraManager tx_imageWithPath:keyPath];
        }];
    };
}

- (TXSakuraBlock)tx_sakuraIndicatorViewStyleBlockWithName:(NSString *)name {
    return ^TXSakura *(NSString *path){
        return [self send1DMsgEnumWithName:name keyPath:path arg:kTXSakuraActivityIndicatorViewStyle valueBlock:^NSInteger(NSString *keyPath) {
            return [TXSakuraManager tx_activityIndicatorStyleWithPath:keyPath];
        }];
    };
}

- (TXSakuraBlock)tx_sakuraBarStyleBlockWithName:(NSString *)name {
    return ^TXSakura *(NSString *path){
        return [self send1DMsgEnumWithName:name keyPath:path arg:kTXSakuraArgBarStyle valueBlock:^NSInteger(NSString *keyPath) {
            return [TXSakuraManager tx_barStyleWithPath:keyPath];
        }];
    };
}

#pragma mark - 2D Block

- (TXSakura2DUIntBlock)tx_sakuraTitleColorForStateBlockWithName:(NSString *)name {
    return ^TXSakura *(NSString *path, UIControlState state){
        return [self send2DMsgObjectAndIntWithName:name keyPath:path integ:state selTail:kTXSakura2DStateSELTail argType:kTXSakuraArgColor valueBlock:^NSObject *(NSString *keyPath) {
            return [TXSakuraManager tx_colorWithPath:keyPath];
        }];
    };
}

- (TXSakura2DUIntBlock)tx_sakuraImageForStateBlockWithName:(NSString *)name {
    return ^TXSakura *(NSString *path, UIControlState state){
        return [self send2DMsgObjectAndIntWithName:name keyPath:path integ:state selTail:kTXSakura2DStateSELTail argType:kTXSakuraArgImage valueBlock:^NSObject *(NSString *keyPath) {
            return [TXSakuraManager tx_imageWithPath:keyPath];
        }];
    };
}

- (TXSakura2DUIntBlock)tx_sakuraTitleTextAttributesForStateBlockWithName:(NSString *)name {
    return ^TXSakura *(NSString *path, UIControlState state){
        return [self send2DMsgObjectAndIntWithName:name keyPath:path integ:state selTail:kTXSakura2DStateSELTail argType:kTXSakuraArgTextAttributes valueBlock:^NSObject *(NSString *keyPath) {
            return [TXSakuraManager tx_titleTextAttributesDictionaryWithPath:keyPath];
        }];
    };
}

- (TXSakura2DBoolBlock)tx_sakuraApplicationForStyleBlockWithName:(NSString *)name {
    return ^TXSakura *(NSString *path, BOOL animated){
        return [self send2DMsgIntAndIntWithName:name keyPath:path integ:animated selTail:kTXSakura2DAnimatedSELTail argType:kTXSakuraArgStatusBarStyle valueBlock:^NSInteger(NSString *keyPath) {
            return [TXSakuraManager tx_statusBarStyleWithPath:path];
        }];
    };
}

@end

#pragma mark - NSObject + TX

void const *kTXSakuraKey = &kTXSakuraKey;

@implementation NSObject(TX)

@dynamic sakura;

- (TXSakura *)sakura {
//    if ([self isKindOfClass:NSClassFromString(@"_UIAppearance")]) {
//#ifdef DEBUG
//        NSLog(@"SakuraKit do not support for UIAppearance in Objective-C now!");
//#endif
//        return [TXSakuraTrash sakuraWithOwner:self];
//    }
    TXSakura *obj = objc_getAssociatedObject(self, kTXSakuraKey);
    if (!obj) {
        obj = [TXSakura sakuraWithOwner:self];
        objc_setAssociatedObject(self, kTXSakuraKey, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}
@end

