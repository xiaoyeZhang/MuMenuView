//
//  ZXYMenuITableViewCell.h
//  MuMenuView
//
//  Created by zhangxiaoye on 2018/6/27.
//  Copyright © 2018年 zhangxiaoye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXYMenuEntity.h"

@class ZXYMenuEntity;
@class ZXYMenuITableViewCell;

@protocol ZXYMenuITableViewCellDelegate <NSObject>

- (void)cell:(ZXYMenuITableViewCell *)cell didSelectedBtn:(UIButton *)sender;


@end

@interface ZXYMenuITableViewCell : UITableViewCell

/** 菜单项模型 */
@property (nonatomic, strong) ZXYMenuEntity *menuItem;

/** cell 宽度 */
@property (nonatomic, assign) CGFloat CellWidth;

/** 代理 */
@property (nonatomic, weak) id<ZXYMenuITableViewCellDelegate> delegate;


@end
