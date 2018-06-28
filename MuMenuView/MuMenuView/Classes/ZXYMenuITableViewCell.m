//
//  ZXYMenuITableViewCell.m
//  MuMenuView
//
//  Created by zhangxiaoye on 2018/6/27.
//  Copyright © 2018年 zhangxiaoye. All rights reserved.
//

#import "ZXYMenuITableViewCell.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"

#define kScreen_Width                       [UIScreen mainScreen].bounds.size.width
#define kScreen_Height                      [UIScreen mainScreen].bounds.size.height

@interface ZXYMenuITableViewCell ()

/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;

/** 复选框 */
@property (nonatomic, strong) UIButton *selectBtn;

/** 横线 */
@property (nonatomic, strong) UIView *lineView;

/** 图标 */
@property (nonatomic, strong) UIImageView *iconImageView;

/** 下拉上拉图标 */
@property (nonatomic, strong) UIImageView *downUPImageView;

/** 按钮 */
@property (nonatomic, strong) UIButton *btn;

@end

@implementation ZXYMenuITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.selectBtn];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.downUPImageView];
        [self.contentView addSubview:self.btn];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIButton *)selectBtn
{
    if (!_selectBtn) {
        self.selectBtn = [[UIButton alloc] init];
        _selectBtn.size = CGSizeMake(18.5, 18.5);
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"options_none_icon"] forState:(UIControlStateNormal)];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"options_selected_icon"] forState:(UIControlStateSelected)];
        _selectBtn.x = 13;
    }
    return _selectBtn;
}

- (UIImageView *)iconImageView{
    
    if (!_iconImageView) {
        
        CGFloat x = self.selectBtn.right + 10;
        self.iconImageView = [[UIImageView alloc]init];
        
        _iconImageView.size = CGSizeMake(18.5, 18.5);
        _iconImageView.x = x;
    }
    
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        CGFloat x = self.iconImageView.right + 15;
        CGFloat width = kScreen_Width - x - self.iconImageView.x;

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.right + 15, 0, width, 45)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, kScreen_Width - 12, 0.5)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UIImageView *)downUPImageView
{
    if (!_downUPImageView) {
        self.downUPImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_down_icon"]];
        _downUPImageView.size = CGSizeMake(11, 11);
        _downUPImageView.right = kScreen_Width - 14;
    }
    return _downUPImageView;
}

- (UIButton *)btn
{
    if (!_btn) {
        self.btn = [[UIButton alloc] init];
        [_btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _btn.backgroundColor = [UIColor clearColor];
    }
    return _btn;
}

#pragma mark - < 布局子控件 >

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _selectBtn.centerY = self.height * 0.5;
    _titleLabel.height = self.height;
    _titleLabel.width = self.CellWidth - self.iconImageView.right + 15 - self.iconImageView.x;
    _iconImageView.centerY = self.height * 0.5;
    _iconImageView.size = CGSizeMake(20, 20);
    _downUPImageView.right = self.CellWidth - 14;
    self.lineView.bottom = self.height;
    self.lineView.width = self.CellWidth - 12;
    _downUPImageView.centerY = self.height * 0.5;
    self.btn.frame = CGRectMake(0, 0, self.CellWidth * 0.5, self.height);
    
}

#pragma mark - < 点击事件 >

- (void)selectBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(cell:didSelectedBtn:)]) {
        [self.delegate cell:self didSelectedBtn:sender];
    }
}

#pragma mark - < set >

- (void)setWidth:(CGFloat)width{

    self.CellWidth = width;
}

- (void)setMenuItem:(ZXYMenuEntity *)menuItem
{
    _menuItem = menuItem;
    
    self.titleLabel.text = menuItem.name;
    
    self.selectBtn.selected = menuItem.isSelected;
    
    self.downUPImageView.hidden = !menuItem.isCanUnfold;
    
    self.downUPImageView.image = menuItem.isUnfold ? [UIImage imageNamed:@"select_top_icon"] : [UIImage imageNamed:@"select_down_icon"];
    
    if ([menuItem.iconName hasPrefix:@"http://"] || [menuItem.iconName hasPrefix:@"https://"]) {
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:menuItem.iconName] placeholderImage:[UIImage imageNamed:@""]];
        
    }else{
        
        self.iconImageView.image = [UIImage imageNamed:menuItem.iconName];
        
    }
    
    // 每一即错开距离
    CGFloat marin = 15;
    
    CGFloat x = 13 + menuItem.index * marin;
    
    self.selectBtn.x = x;
    self.iconImageView.x = self.selectBtn.right + 10;
    
    if (menuItem.iconName.length > 0) {
        
         self.titleLabel.x = self.iconImageView.right + 15;
    
    }else{
     
        self.titleLabel.x = self.selectBtn.right + 10;
    }
   
    self.titleLabel.width = _downUPImageView.x - 10 - self.titleLabel.x;
    self.lineView.x = x - 1;
    self.lineView.width = kScreen_Width - self.lineView.x - 12;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
