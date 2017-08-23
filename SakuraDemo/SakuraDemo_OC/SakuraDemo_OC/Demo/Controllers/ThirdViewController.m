//
//  ThirdViewController.m
//  SakuraDemo_OC
//
//  Created by tingxins on 04/07/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "ThirdViewController.h"
#import "TXSakuraKit.h"

@interface ThirdViewController ()<TXSakuraDownloadDelegate>{
    NSString *_downloadUrl;
}
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) CALayer *customLayer;
@property (weak, nonatomic) CAShapeLayer *customShapeLayer;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer *customLayer = [[CALayer alloc] init];
    customLayer.frame = CGRectMake(100, 64, 100, 100);
    self.customLayer = customLayer;
    [self.view.layer addSublayer:customLayer];
    
    CAShapeLayer *customShapeLayer = [[CAShapeLayer alloc] init];
    customShapeLayer.frame = CGRectMake(100, CGRectGetMaxY(customLayer.frame) + 10, 100, 60);
    self.customShapeLayer = customShapeLayer;
    [self.view.layer addSublayer:customShapeLayer];
    
    
    [self configsTheme];
}

- (void)configsTheme {
    self.sakura
    .title(@"Third.title");
    
    self.bgImageView.sakura
    .image(@"Fourth.backgroundImage");

    self.customLayer.sakura
    .backgroundColor(@"Global.barTintColor")
    .borderColor(@"Fourth.logoutBackgroundColor")
    .borderWidth(@"Global.font");
    
    self.customShapeLayer.sakura
    .borderColor(@"Global.barTintColor")
    .backgroundColor(@"Fourth.logoutBackgroundColor")
    .borderWidth(@"Global.font");
}

@end
