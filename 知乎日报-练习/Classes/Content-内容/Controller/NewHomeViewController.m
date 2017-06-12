//
//  NewHomeViewController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/5/28.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "NewHomeViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <MJExtension/MJExtension.h>
#import "XHBDayNews.h"
#import "UIImageView+WebCache.h"
#import "XHBDayNewsTableViewCell.h"

static NSString * const XHBDayNewsCell = @"dayNewsCell";

@interface NewHomeViewController ()<UITableViewDelegate, UITableViewDataSource>{
    AFHTTPSessionManager *_manager;
    
    NSMutableArray *_dayNews;
    NSArray *_topNews;
    
    UITableView *_contentTableview;


}

@end

@implementation NewHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_manager) {
        _manager = [[AFHTTPSessionManager alloc] init];
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_showCategoryData:) name:@"test" object:nil];
    
    _dayNews = [[NSMutableArray alloc] init];

    _contentTableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _contentTableview.delegate = self;
    _contentTableview.dataSource = self;
    [self.view addSubview:_contentTableview];
    
    /* 为tableView队列中的cell注册类 */
    NSString *className = NSStringFromClass([XHBDayNewsTableViewCell class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    [_contentTableview registerNib:nib forCellReuseIdentifier:XHBDayNewsCell];

    
    [self p_getNewsData];
    [self P_getTopNewsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//#pragma mark-
//- (void) p_showCategoryData:(NSNotification *)notify{
//    NSInteger *categoryID = [[notify.userInfo objectForKey:@"categoryID"] integerValue];
//    
//}

#pragma mark- Get data Method
- (void) p_getNewsData{
    /* 发送网络请求 */
    [_manager GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /* 请求成功，隐藏指示器 */
//        [SVProgressHUD dismiss];
        
  
        [_dayNews addObjectsFromArray:[XHBDayNews mj_objectArrayWithKeyValuesArray:responseObject[@"stories"]]];
        
        /* 刷新表格 */
        [_contentTableview reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        /* 加载失败 */
//        [SVProgressHUD showErrorWithStatus:@"数据加载失败！"];
        
    }];

}

//加载今天的新闻
- (void) P_getTopNewsData{
    /* 发送无参数网络请求 */
    [_manager GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        /* 请求成功，隐藏指示器 */
//        [SVProgressHUD dismiss];
        
        /* 转换数据模型 */
        _topNews = [XHBDayNews mj_objectArrayWithKeyValuesArray:responseObject[@"top_stories"]];
        
//        NSLog(@"block 块中的 topNews 对象为：%@", _topNews);
        
//        for (int i = 0; i < self.pageControl.numberOfPages; i++) {
//            
//            /* 获取顶部新闻信息 */
//            XHBDayNews *topNews = self.topNews[i];
//            
//            /* 获取图片 */
//            self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, self.scrollView.frame.size.height)];
//            [self.imageView sd_setImageWithURL:[NSURL URLWithString:topNews.image]];
//            
//            /* 添加新闻标题 */
//            UILabel *topNewsLabel = [[UILabel alloc] init];
//            topNewsLabel.text = topNews.title;
//            topNewsLabel.textColor = [UIColor whiteColor];
//            topNewsLabel.frame = CGRectMake(10, 150, screenWidth - 20, 80);
//            
//            //设置标签显示行数，0为显示多行
//            topNewsLabel.numberOfLines = 0;
//            
//            //设置topNewsLabel根据字数自适应高度
//            topNewsLabel.lineBreakMode = NSLineBreakByWordWrapping;
//            
//            //设置topNewsLabel的文字对齐方式
//            topNewsLabel.textAlignment = NSTextAlignmentLeft;
//            
//            /* 将新闻标题添加到新闻图片上 */
//            [self.imageView addSubview:topNewsLabel];
//            
//            /* 添加图片到ScrollView */
//            [self.scrollView addSubview:self.imageView];
//            
//        }
        
        /* 刷新表格 */
        [_contentTableview reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        /* 提示加载失败信息 */
//        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];

}

#pragma mark- UITableView Delegate Method
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
//    NSLog(@"代理方法中的 topNews 为:%@", _topNews);
    
    if (_topNews) {
        return 2;
    }
    else{
        return 1;
    }
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_topNews) {
        if (section == 0) {
            return 0;
        }
        else{
            return _dayNews.count;
        }
    }
    else{
        return _dayNews.count;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_topNews && section == 0) {
        return 220;
    }
    else{
        return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
    scrollView.pagingEnabled = YES;
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width*_topNews.count, scrollView.frame.size.height)];
    for (int i=0; i<_topNews.count; ++i) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(scrollView.frame.size.width*i, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        XHBDayNews *topNew = [_topNews objectAtIndex:i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:topNew.image]];
        [scrollView addSubview:imageView];
    }
    
    return scrollView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XHBDayNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XHBDayNewsCell forIndexPath:indexPath];
    cell.dayNewsItem = _dayNews[indexPath.row];
    
    return cell;
}

@end
