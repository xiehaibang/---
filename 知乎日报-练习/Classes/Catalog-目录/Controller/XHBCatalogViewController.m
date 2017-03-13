//
//  XHBCatalogViewController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/6.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBCatalogViewController.h"
#import "XHBCatalogTableViewCell.h"

@interface XHBCatalogViewController () <UITableViewDelegate, UITableViewDataSource>
/* 目录表格 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

/* 将catalogCell的标识符设为常量 */
static NSString * const XHBCatalogId = @"catalog";

@implementation XHBCatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 为队列里的cell注册类 */
    NSString *className = NSStringFromClass([XHBCatalogTableViewCell class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:XHBCatalogId];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource 协议
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHBCatalogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XHBCatalogId forIndexPath:indexPath];

    return cell;
}

#pragma mark - UITableViewDelegate 协议
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
