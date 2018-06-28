//
//  ZXYMenuEntity.h
//  MuMenuView
//
//  Created by zhangxiaoye on 2018/6/27.
//  Copyright © 2018年 zhangxiaoye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXYMenuEntity : NSObject

/** 名字 */
@property (nonatomic, strong) NSString *name;
/** icon */
@property (nonatomic, strong) NSString *iconName;
/** 子层 */
@property (nonatomic, strong) NSArray<ZXYMenuEntity *> *subs;
/** 自身id */
@property (nonatomic, assign) NSInteger code;
/** 父节点 */
@property (nonatomic, assign) NSInteger parent_id;

#pragma mark - < 辅助属性 >

/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;

/** 是否展开 */
@property (nonatomic, assign) BOOL isUnfold;

/** 是否能展开 */
@property (nonatomic, assign) BOOL isCanUnfold;

/** 当前层级 */
@property (nonatomic, assign) NSInteger index;

@end
