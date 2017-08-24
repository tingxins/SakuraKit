//
//  EditProfileController.m
//  SakuraDemo_OC
//
//  Created by tingxins on 06/07/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "EditProfileController.h"
#import "TXSakuraKit.h"

@interface EditProfileController ()

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation EditProfileController

- (NSMutableArray *)dataSource {
    if (_dataSource) return _dataSource;
    return _dataSource = [[TXSakuraManager tx_getSakurasList] mutableCopy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"本地主题/皮肤";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *name = self.dataSource[indexPath.row];
    BOOL flag = YES;
    if ([name isEqualToString:kTXSakuraDefault] || [[TXSakuraManager getLocalSakuraNames] containsObject:name]) {
        flag = [TXSakuraManager shiftSakuraWithName:name type:TXSakuraTypeMainBundle];
    }else {
        flag = [TXSakuraManager shiftSakuraWithName:name type:TXSakuraTypeSandbox];
    }
    if (flag) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
