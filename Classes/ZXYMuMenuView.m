//
//  ZXYMuMenuView.m
//  MuMenuView
//
//  Created by zhangxiaoye on 2018/6/27.
//  Copyright © 2018年 zhangxiaoye. All rights reserved.
//

#import "ZXYMuMenuView.h"
#import "ZXYMenuEntity.h"
#import "ZXYMenuITableViewCell.h"
#import "UIView+Extension.h"

@interface ZXYMuMenuView()<ZXYMenuITableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *MenuTabView;

/** 菜单项 */
@property (nonatomic, strong) NSMutableArray<ZXYMenuEntity *> *menuItems;

/** 当前需要展示的数据 */
@property (nonatomic, strong) NSMutableArray<ZXYMenuEntity *> *latestShowMenuItems;

/** 以前需要展示的数据 */
@property (nonatomic, strong) NSMutableArray<ZXYMenuEntity *> *oldShowMenuItems;

/** 已经选中的选项, 用于回调 */
@property (nonatomic, strong) NSMutableArray<ZXYMenuEntity *> *selectedMenuItems;

@end

static NSString *ZXYMenuItemId = @"ZXYMenuITableViewCell";
@implementation ZXYMuMenuView


- (instancetype)initWithMuMenuView:(UIView *)view parameterMenu:(NSArray *)parameters{
    
    self = [super init];
    
    if (self) {
        
        self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    
        self.menuItems = [NSMutableArray arrayWithArray:parameters];
        
        // 初始化需要展示的数据
        [self setupRowCount];
        
        [self setupTableView];
        
        [view addSubview:self];
        
    }
    
    return self;
}

+ (instancetype)showMuMenuView:(UIView *)view TabArr:(NSArray *)parameters{
    
    return [[[self class] alloc] initWithMuMenuView:view parameterMenu:parameters];
}

#pragma mark - < 懒加载 >


- (NSMutableArray<ZXYMenuEntity *> *)latestShowMenuItems
{
    if (!_latestShowMenuItems) {
        self.latestShowMenuItems = [[NSMutableArray alloc] init];
    }
    return _latestShowMenuItems;
}

- (NSMutableArray<ZXYMenuEntity *> *)selectedMenuItems
{
    if (!_selectedMenuItems) {
        self.selectedMenuItems = [[NSMutableArray alloc] init];
    }
    return _selectedMenuItems;
}

- (void)setupTableView
{
    self.MenuTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.MenuTabView.delegate = self;
    self.MenuTabView.dataSource = self;
    self.MenuTabView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.MenuTabView.rowHeight = 45;
    [self.MenuTabView registerClass:[ZXYMenuITableViewCell class] forCellReuseIdentifier:ZXYMenuItemId];
    
    [self addSubview:self.MenuTabView];
    
}


/**
 全选中数据
 */
- (void)AllSelected:(BOOL)selected{
    
    [self selected:selected menuItems:self.menuItems];
    
}
/**
 取消或选择, 某一数值中所有的选项, 包括子层级
 
 @param selected 是否选中
 @param menuItems 选项数组
 */
- (void)selected:(BOOL)selected menuItems:(NSArray<ZXYMenuEntity *> *)menuItems
{
    for (int i = 0; i < menuItems.count; i++) {
        ZXYMenuEntity *menuItem = menuItems[i];
        menuItem.isSelected = selected;
        if (menuItem.isCanUnfold) {
            [self selected:selected menuItems:menuItem.subs];
        }
    }
    [self.MenuTabView reloadData];
}

#pragma mark - < 选中数据 >

- (void)printSelectedMenuItems
{
    [self.selectedMenuItems removeAllObjects];
    [self departmentsWithMenuItems:self.menuItems];
    NSLog(@"这里是全部选中数据\n%@", self.selectedMenuItems);
    
    if (self.SelectedBlock) {
        
        self.SelectedBlock(self.selectedMenuItems);
    }
    
}

/**
 获取选中数据
 */
- (void)departmentsWithMenuItems:(NSArray<ZXYMenuEntity *> *)menuItems
{
    for (int i = 0; i < menuItems.count; i++) {
        ZXYMenuEntity *menuItem = menuItems[i];
        if (menuItem.isSelected) {
            [self.selectedMenuItems addObject:menuItem];
        }
        if (menuItem.subs.count) {
            [self departmentsWithMenuItems:menuItem.subs];
        }
    }
}

#pragma mark - < 添加可以展示的选项 >

- (void)setupRowCount
{
    // 清空当前所有展示项
    [self.latestShowMenuItems removeAllObjects];
    
    // 重新添加需要展示项, 并设置层级, 初始化0
    [self setupRouCountWithMenuItems:self.menuItems index:0];
}

/**
 将需要展示的选项添加到latestShowMenuItems中, 此方法使用递归添加所有需要展示的层级到latestShowMenuItems中
 
 @param menuItems 需要添加到latestShowMenuItems中的数据
 @param index 层级, 即当前添加的数据属于第几层
 */
- (void)setupRouCountWithMenuItems:(NSArray<ZXYMenuEntity *> *)menuItems index:(NSInteger)index
{
    for (int i = 0; i < menuItems.count; i++) {
        ZXYMenuEntity *item = menuItems[i];
        // 设置层级
        item.index = index;
        // 将选项添加到数组中
        [self.latestShowMenuItems addObject:item];
        // 判断该选项的是否能展开, 并且已经需要展开
        if (item.isCanUnfold && item.isUnfold) {
            // 当需要展开子集的时候, 添加子集到数组, 并设置子集层级
            [self setupRouCountWithMenuItems:item.subs index:index + 1];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.latestShowMenuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXYMenuITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZXYMenuItemId forIndexPath:indexPath];
    
    cell.width = self.frame.size.width;
    cell.menuItem = self.latestShowMenuItems[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXYMenuEntity *menuItem = self.latestShowMenuItems[indexPath.row];
    if (!menuItem.isCanUnfold) return;
    
    self.oldShowMenuItems = [NSMutableArray arrayWithArray:self.latestShowMenuItems];
    
    // 设置展开闭合
    menuItem.isUnfold = !menuItem.isUnfold;
    // 更新被点击cell的箭头指向
    [self.MenuTabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    
    // 设置需要展开的新数据
    [self setupRowCount];
    
    // 判断老数据和新数据的数量, 来进行展开和闭合动画
    // 定义一个数组, 用于存放需要展开闭合的indexPath
    NSMutableArray<NSIndexPath *> *indexPaths = @[].mutableCopy;
    
    // 如果 老数据 比 新数据 多, 那么就需要进行闭合操作
    if (self.oldShowMenuItems.count > self.latestShowMenuItems.count) {
        // 遍历oldShowMenuItems, 找出多余的老数据对应的indexPath
        for (int i = 0; i < self.oldShowMenuItems.count; i++) {
            // 当新数据中 没有对应的item时
            if (![self.latestShowMenuItems containsObject:self.oldShowMenuItems[i]]) {
                NSIndexPath *subIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                [indexPaths addObject:subIndexPath];
            }
        }
        // 移除找到的多余indexPath
        [self.MenuTabView deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationTop)];
    }else {
        // 此时 新数据 比 老数据 多, 进行展开操作
        // 遍历 latestShowMenuItems, 找出 oldShowMenuItems 中没有的选项, 就是需要新增的indexPath
        for (int i = 0; i < self.latestShowMenuItems.count; i++) {
            if (![self.oldShowMenuItems containsObject:self.latestShowMenuItems[i]]) {
                NSIndexPath *subIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                [indexPaths addObject:subIndexPath];
            }
        }
        // 插入找到新添加的indexPath
        [self.MenuTabView insertRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationTop)];
    }
}

#pragma mark - < LTMenuItemCellDelegate >

- (void)cell:(ZXYMenuITableViewCell *)cell didSelectedBtn:(UIButton *)sender
{
    
    NSLog(@"%ld",(long)cell.menuItem.code);
    cell.menuItem.isSelected = !cell.menuItem.isSelected;
    
    NSArray *selectMenuItem = [self MenuItems:self.menuItems code:cell.menuItem.code selected:cell.menuItem.isSelected];
    
    [self selected:cell.menuItem.isSelected menuItems:selectMenuItem];
    
    // 修改按钮状态
    //    self.allBtn.selected = NO;
    
    [self printSelectedMenuItems];
    
    [self.MenuTabView reloadData];
}

- (NSArray *)MenuItems:(NSArray<ZXYMenuEntity *> *)menuItems code:(NSInteger)code selected:(BOOL)selected
{
    NSArray *selectMenuItem;
    
    for (int i = 0; i < menuItems.count; i++) {
        ZXYMenuEntity *item = menuItems[i];
        // 将选项添加到数组中
        
        if (item.code == code) {
            selectMenuItem = item.subs;
            
            [self selected:selected menuItems:selectMenuItem];
            
            break;
            
        }
        if (selectMenuItem) {
            break;
        }else{
            // 判断该选项的是否能展开, 并且已经需要展开
            if (item.isCanUnfold) {
                // 当需要展开子集的时候, 添加子集到数组, 并设置子集层级
                [self MenuItems:item.subs code:code selected:selected];
            }
        }
        
    }
    
    return selectMenuItem;
}

@end
