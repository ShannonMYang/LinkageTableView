//
//  ViewController.m
//  LinkageTableView
//
//  Created by ShannonMuY on 2017/6/14.
//  Copyright © 2017年 MYang Shannon. All rights reserved.
//

#import "ViewController.h"

#define leftTableWidth  [UIScreen mainScreen].bounds.size.width * 0.3
#define rightTableWidth [UIScreen mainScreen].bounds.size.width * 0.7
#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height

#define leftCellIdentifier  @"leftCellIdentifier"
#define rightCellIdentifier @"rightCellIdentifier"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *leftTableView;
@property (nonatomic, weak) UITableView *rightTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
}

#pragma mark - 懒加载 tableView
// MARK: - 左边的 tableView
- (UITableView *)leftTableView {
    
    if (!_leftTableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, leftTableWidth, ScreenHeight - 20)];
        
        [self.view addSubview:tableView];
        
        _leftTableView = tableView;
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        // --- 如果需要定制Cell，则建议采用别的注册Cell方式
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:leftCellIdentifier];
        tableView.backgroundColor = [UIColor redColor];
        //tableView.tableFooterView = [[UIView alloc] init];
    }
    return _leftTableView;
}

// MARK: - 右边的 tableView
- (UITableView *)rightTableView {
    
    if (!_rightTableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(leftTableWidth, 20, rightTableWidth, ScreenHeight - 20)];
        
        [self.view addSubview:tableView];
        
        _rightTableView = tableView;
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        // --- 如果需要定制Cell，则建议采用别的注册Cell方式
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:rightCellIdentifier];
        tableView.backgroundColor = [UIColor blueColor];
        //tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _rightTableView;
}


#pragma mark - UITableViewDataSource // --- tableView の 数据源代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.leftTableView) {
        return 19;
    }
    return 13;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.leftTableView) {
        return 1;
    }
    return 19;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    
    if (tableView == self.leftTableView) {// 左边的 view
        
        cell = [tableView dequeueReusableCellWithIdentifier:leftCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld组", indexPath.row];
    }
    else {// 右边的 view
        
        cell = [tableView dequeueReusableCellWithIdentifier:rightCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld组-第%ld行", indexPath.section, indexPath.row];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.rightTableView) {
        return [NSString stringWithFormat:@"第 %ld 组", section];
    }
    return nil;
}


#pragma mark - UITableViewDelegate // UITableView の 代理方法
//- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
//
//    这两个方法都不准确
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//
//    这两个方法都不准确
//}

//MARK: - 重点之一·在此
//MARK: 一个方法就能搞定 右边滑动时跟左边的联动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 如果是 左侧的 tableView 直接return
    if (scrollView == self.leftTableView) {
        return;
    }
    
    // 取出显示在 视图 且最靠上 的 cell 的 indexPath
    NSIndexPath *topHeaderViewIndexpath = [[self.rightTableView indexPathsForVisibleRows] firstObject];
    
    // 左侧 talbelView 移动的 indexPath
    NSIndexPath *moveToIndexpath = [NSIndexPath indexPathForRow:topHeaderViewIndexpath.section
                                                      inSection:0];
    // 移动 左侧 tableView 到 指定 indexPath 居中显示
    [self.leftTableView selectRowAtIndexPath:moveToIndexpath
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionMiddle];
}

//MARK: - 重点之二·在此
//MARK: 点击 cell 的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 选中 左侧 的 tableView
    if (tableView == self.leftTableView) {
        // 右侧 TableView 跳转到的 Section
        NSIndexPath *moveToIndexPath = [NSIndexPath indexPathForRow:0
                                                          inSection:indexPath.row];
        // 将右侧 tableView 移动到指定位置
        [self.rightTableView selectRowAtIndexPath:moveToIndexPath
                                         animated:YES
                                   scrollPosition:UITableViewScrollPositionTop];
        // 取消选中效果
        [self.rightTableView deselectRowAtIndexPath:moveToIndexPath
                                           animated:NO];
    }
}

@end
