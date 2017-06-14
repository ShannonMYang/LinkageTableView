## LinkageTableView

```
左、右两个TableView 的联动效果。
之前见到饿了么的选购列表，是这样，觉得有些意思，就写了这么个极简单的Demo。
```

#### Objective-C 实现左、右TableView的联动效果

> 实现TableView 的联动效果，其实，就是两种情况：

- 点击左侧 TableView 的某 `row` の cell，让右侧 tableView 滚到对应的某 `section`
- 滑动右侧 tableView 到某 `section` ，让左侧 tableView 滚到对应的某 `row`

---

> 那么，一步步来，实现联动效果

```
由于，这个效果，实现起来还是蛮简单的。
所以，此处将代码写在了同一个Controller里。
有需要的看官，可以自行分离TableView。
```
##### 1. 点击左侧 TableView 的某 `row` の cell，让右侧 tableView 滚到对应的某 `section`

```Objective-C
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
```
*左侧 TableView 点击cell の 联动，自此，实现。*

---

##### 2. 滑动右侧 tableView 到某 `section` ，让左侧 tableView 滚到对应的某 `row`


```
// 返回 所有显示在界面的 cell 的 indexPath
[self.rightTableView indexPathsForVisibleRows]
```
```Objective-C
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
```
*右侧 TableView 滑动，左侧 TableView 的联动，自此，实现。嗯，就是这样，就这么简单。*

---

##### 建议：
> 在简书上看到别人通过这两个方法判断。不建议使用。
因为，这样会导致 tableView 的联动不准确。


```Objective-C
#pragma mark - UITableViewDelegate // UITableView の 代理方法
//- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
//    这两个方法都不准确
//}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    这两个方法都不准确
//}
```
---
