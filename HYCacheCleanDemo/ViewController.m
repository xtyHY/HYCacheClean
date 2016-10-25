//
//  ViewController.m
//  HYCacheCleanDemo
//
//  Created by 徐天宇 on 2016/10/24.
//  Copyright © 2016年 devhy. All rights reserved.
//

#import "ViewController.h"

#import <UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "HYHomeCell.h"
#import "HYCacheClean.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *arrayDS;

@end

@implementation ViewController

#pragma mark - cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除缓存" style:UIBarButtonItemStylePlain target:self action:@selector(cleanCache)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrayDS.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HYHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYHomeCell"];
    [cell.homeCellImageView sd_setImageWithURL:[NSURL URLWithString:self.arrayDS[indexPath.row]]];
    return cell;
}

#pragma mark - properties
- (NSArray *)arrayDS{
    
    if (!_arrayDS) {
        _arrayDS = @[@"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg01.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg02.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg03.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg04.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg05.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg06.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg07.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg08.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg09.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg10.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg11.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg12.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg13.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg14.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg15.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg16.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg17.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg18.jpg",
                     @"http://oa73hsfk5.bkt.clouddn.com/2016-10-24-HYCacheCleanTestImg19.jpg"];
    }
    
    return _arrayDS;
}

#pragma mark - action
- (void)cleanCache{
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.labelText = @"正在计算缓存";
    [self.view addSubview:hud];
    [hud show:YES];
    
    //比如需要清除的目录是path，把他添加到待删除数组中
    NSString *path1 = [NSString stringWithFormat:@"%@/Document",NSHomeDirectory()];
    NSString *path2 = NSTemporaryDirectory();
    NSArray *needCleanPaths = @[path1, path2];
    
    // 异步计算待清理文件大小
    [HYCacheClean cacheSizeWithPaths:needCleanPaths complete:^(float filesSize) {
        
        // 垃圾文件提示清理阈值，大于1M才弹出清理
        if (filesSize > 1) {
            
            [hud hide:YES];
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"清理缓存" message:[NSString stringWithFormat:@"确定清理缓存数据(%.2lf MB)？",filesSize] preferredStyle:UIAlertControllerStyleAlert];
            
            [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                hud.labelText = @"正在清理";
                [hud show:YES];
                
                //异步进行删除文件（needCleanPaths数组的目录下所有文件，以及SDWebImage的Disk缓存）
                [HYCacheClean cacheCleanWithPaths:needCleanPaths complete:^{
                    //删除完成回调，并且延迟0.5后再显示
                    hud.labelText = @"缓存数据清理完成";
                    [hud hide:YES afterDelay:2.0f];
                }];
            }]];
            
            [self presentViewController:alertC animated:YES completion:nil];
            
            
        } else {
            
            hud.labelText = @"已经很干净了";
            [hud hide:YES afterDelay:2.0f];
        }
        
    }];
}


@end
