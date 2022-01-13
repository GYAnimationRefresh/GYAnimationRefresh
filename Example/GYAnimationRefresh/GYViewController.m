//
//  GYViewController.m
//  GYAnimationRefresh
//
//  Created by 3125825529@qq.com on 01/13/2022.
//  Copyright (c) 2022 3125825529@qq.com. All rights reserved.
//

#import "GYViewController.h"
#import "GYAnimationRefresh.h"
@interface GYViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,weak) GYAnimationRefresh *gyanimationRefresh;

@end

@implementation GYViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    GYAnimationRefresh *gyanimationRefresh = [GYAnimationRefresh GYAnimationRefreshWithScrollView:self.tableView mainView:self.view];
    gyanimationRefresh.animationNamedJson = @"data.json";
    gyanimationRefresh.gyanimationRefreshBackgroundColor = [UIColor orangeColor];
//    gyanimationRefresh.refreshH = 50;
    self.gyanimationRefresh = gyanimationRefresh;
    gyanimationRefresh.block = ^{
        [self.gyanimationRefresh endRefresh];
    };
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.gyanimationRefresh scrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.gyanimationRefresh scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}
- (UITableView *)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor blackColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:indentify];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

static NSString *indentify = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:indentify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

@end
