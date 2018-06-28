//
//  ZXYMenuEntity.m
//  MuMenuView
//
//  Created by zhangxiaoye on 2018/6/27.
//  Copyright © 2018年 zhangxiaoye. All rights reserved.
//

#import "ZXYMenuEntity.h"

@implementation ZXYMenuEntity

/**
 指定subs数组中存放LTMenuItem类型对象
 */
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"subs" : [ZXYMenuEntity class]};
}

/**
 判断是否能够展开, 当subs中有数据时才能展开
 */
- (BOOL)isCanUnfold
{
    return self.subs.count > 0;
}


@end
