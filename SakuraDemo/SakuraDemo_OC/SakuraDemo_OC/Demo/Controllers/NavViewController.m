//
//  NavViewController.m
//  SakuraDemo_OC
//
//  Created by tingxins on 05/07/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "NavViewController.h"
#import "TXSakuraKit.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configsTheme];
}

- (void)configsTheme {
    self.navigationBar.sakura
    .barTintColor(@"Global.barTintColor")
    .tintColor(@"Global.tintColor")
    .titleTextAttributes(@"Global.navBarTitleColor");
    
}

@end
