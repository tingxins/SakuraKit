//
//  TXSakuraTrash.h
//  SakuraKit
//
//  Created by tingxins on 28/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//  针对不支持的 Sakura 类型进行响应，如：UIAppearance 等类。

#import "TXSakura.h"

typedef void(^TXSakuraTrashBlock)(id);

@interface TXSakuraTrash : TXSakura
- (TXSakuraTrashBlock)barTintColor;
- (TXSakuraTrashBlock)tintColor;
- (TXSakuraTrashBlock)titleTextAttributes;
@end
