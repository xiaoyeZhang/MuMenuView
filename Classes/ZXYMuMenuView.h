//
//  ZXYMuMenuView.h
//  MuMenuView
//
//  Created by zhangxiaoye on 2018/6/27.
//  Copyright © 2018年 zhangxiaoye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXYMuMenuView : UIView

+ (instancetype)showMuMenuView:(UIView *)view TabArr:(NSArray *)parameters;

/**
 全选中数据
 
 @param selected   YES 全选择。 NO 全取消选中
 */
- (void)AllSelected:(BOOL)selected;

// 获取选中数据
- (void)printSelectedMenuItems;

/**  返回选中数据*/
@property (copy, nonatomic) void(^SelectedBlock)(NSMutableArray *selectedMenuItems);


@end
