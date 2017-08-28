//
//  DownloadSakuraController.m
//  SakuraDemo_OC
//
//  Created by tingxins on 31/07/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//  多种主题同时下载示例（Block回调）

#import "DownloadSakuraController.h"
#import "TXSakuraKit.h"
#import "SakuraModel.h"
#import "SakuraCell.h"
#import "NSObject+TXExeDeallocBlock.h"

@interface DownloadSakuraController ()<SakuraCellDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) NSURLSessionDataTask *listDataTask;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation DownloadSakuraController

- (NSMutableArray *)dataSource {
    if (_dataSource) return _dataSource;
    return _dataSource = [NSMutableArray array];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *identifier = NSStringFromClass([SakuraCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    [self.indicatorView startAnimating];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://rapapi.org/mockjsdata/21815/theme/list"];
    if (!url) return;
    self.listDataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!data || error) return;
        NSArray *jsons = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([jsons isKindOfClass:[NSArray class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *array = [SakuraModel sakuraModelWithDicts:jsons];
                [self.dataSource addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.indicatorView stopAnimating];
            });
        }
        [self.indicatorView stopAnimating];
    }];
    [self.listDataTask resume];
    [self.listDataTask tx_runBlockAtDealloc:^{
        NSLog(@"ListDataTask dealloc!");
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.listDataTask cancel];
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
    SakuraCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SakuraCell class]) forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.sakuraModel = self.dataSource[indexPath.row];
    return cell;
}

- (void)sakuraCell:(SakuraCell *)sakuraCell
  didClickDownload:(SakuraModel *)sakuraModel
       atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Click operation!");
    if (!sakuraModel.remoteURL.length) return;
    
    if (sakuraModel.status == 3) {
        NSLog(@"Start using %@ sakura!", sakuraModel.name);
        [TXSakuraManager shiftSakuraWithName:sakuraModel.sakuraName type:TXSakuraTypeSandbox];
    }if (sakuraModel.status == 0)  {
        NSLog(@"Start downloading sakura：%@",sakuraModel.name);
        NSURLSessionDownloadTask *downloadTask = [[TXSakuraManager manager] tx_sakuraDownloadWithInfos:sakuraModel downloadProgressHandler:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            
            long long current = totalBytesWritten/1024;
            long long total = totalBytesExpectedToWrite/1024;
            sakuraModel.progress = current*1.0/total;
            sakuraModel.status = 1;
            
            [self updateCellAtIndexPath:indexPath];
        } downloadErrorHandler:^(NSError * _Nullable error) {
            NSLog(@"error:%@", error);
        } unzipProgressHandler:^(unsigned long long loaded, unsigned long long total) {
            long long current = loaded/1024;
            long long totalB = total/1024;;
            sakuraModel.progress = current*1.0/totalB;
            sakuraModel.status = 2;
            [self updateCellAtIndexPath:indexPath];
        } completedHandler:^(id<TXSakuraDownloadProtocol> _Nullable infos, NSURL * _Nullable location) {
            NSLog(@"Location:%@--info:%@", location, infos);
            sakuraModel.status = 3;
            [self updateCellAtIndexPath:indexPath];
        } ];
        
        [downloadTask tx_runBlockAtDealloc:^{
            NSLog(@"DownloadTask dealloc!");
        }];
    }
    
}

- (void)updateCellAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
