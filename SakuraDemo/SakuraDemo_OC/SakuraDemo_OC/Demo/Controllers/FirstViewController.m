//
//  FirstViewController.m
//  SakuraDemo_OC
//
//  Created by tingxins on 04/07/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "FirstViewController.h"
#import "TXSakuraKit.h"
#import "AppDelegate.h"
@interface FirstViewController ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *avatarImageViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *userNames;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *userIntros;
@property (strong, nonatomic) NSMutableArray *dataSource;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configsTheme];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[UIApplication sharedApplication].keyWindow addSubview:delegate.label];
    self.dataSource = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:TXSakuraSkinChangeNotification object:nil];
}

- (void)change{
    self.dataSource.sakura.array(@"Global.test_array");
    NSLog(@"%@",self.dataSource);
}

- (void)configsTheme {
    self.sakura
    .title(@"First.title");
    
    for (UIImageView *imageView in self.avatarImageViews) {
        imageView.sakura
        .image(@"First.userImage");
    }
    
    for (UILabel *label in self.userNames) {
        label.sakura
        .textColor(@"First.userNameColor");
    }
    
    for (UILabel *label in self.userIntros) {
        label.sakura
        .textColor(@"First.userIntroColor");
    }
    
    self.view.sakura
    .backgroundColor(@"Global.backgroundColor");
    
    self.tableView.sakura
    .separatorColor(@"First.separatorColor");
}

- (void)viewWillAppear:(BOOL)animated{
    
}

@end
