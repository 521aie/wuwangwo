//
//  EditItemList.m
//  RestApp
//
//  Created by zxh on 14-4-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemList.h"
#import "SystemUtil.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "IEditItemListEvent.h"

@implementation EditItemList
@synthesize view;

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemList" owner:self options:nil];
    [self addSubview:self.view];
    self.view.ls_width =  [UIScreen mainScreen].bounds.size.width;
    self.lblVal.text = @"";
    self.lblDetail.text = @"";
    self.lblVal1.textColor = [ColorHelper getBlueColor];
    
}

+ (instancetype)editItemList {
    EditItemList *editItemList = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 48)];
    return editItemList;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

#pragma  initHit.
- (void)initHit:(NSString *)hit {
    self.lblDetail.text = nil;
    [self.lblDetail setLs_width:300];
    self.lblDetail.text = hit;
    [self.lblDetail setTextColor:[ColorHelper getTipColor6]];
    if ([NSString isBlank:hit]) {
        [self.lblDetail setLs_height:0];
        [self.line setLs_top:46];
    } else {
        self.lblDetail.ls_top = self.lblName.ls_bottom + 5;
        CGSize size = [NSString sizeWithText:hit maxSize:CGSizeMake(self.lblDetail.ls_width, MAXFLOAT) font:self.lblDetail.font];
        self.lblDetail.ls_size = size;
        self.lblDetail.ls_width = 300;//此代码删除需谨慎 因为会出现右对齐的情况
        if (self.isShowOneLine) {
            self.lblDetail.ls_height = 20;
        }
        [self.line setLs_top:self.lblDetail.ls_bottom+15];
    }
    [self.view setLs_height:[self getHeight]];
    [self setLs_height:[self getHeight]];
}

- (void)initLabel:(NSString *)label withHit:(NSString *)hit delegate:(id<IEditItemListEvent>)delegate {
    [self initLabel:label withHit:hit isrequest:NO delegate:delegate];
}

- (void)initLabel:(NSString *)label withHit:(NSString *)hit isrequest:(BOOL)req delegate:(id<IEditItemListEvent>)delegateTmp {
    
    self.lblName.text = label;
    [self initHit:hit];
    self.delegate = delegateTmp;
    UIColor *color = req?[UIColor redColor]:[ColorHelper getTipColor9];
    NSString *hitStr=req?@"必填":@"可不填";
    
    if ([self.lblVal respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.lblVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:hitStr attributes:@{NSForegroundColorAttributeName:color}];
    } else {
        self.lblVal.placeholder = hitStr;
    }
    
    self.lblVal1.text = hitStr;
    self.lblVal1.textColor = color;
    self.lblVal.textColor = [ColorHelper getBlueColor];
    [self initStretchWidth:label];
}

- (void)initPlaceholder:(NSString *)placeholder {
    
    self.lblVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: [ColorHelper getTipColor9]}];
}

/**
 *  初始化EditItemList 显示数据
 *
 *  @param label    item 标题，左侧显示，单行
 *  @param hit      详细信息，可多行显示
 *  @param delegate 遵守<IEditItemListEvent>协议的对象
 */
- (void)initRightLabel:(NSString*)label withHit:(NSString *)hit delegate:(id<IEditItemListEvent>) delegate {
    
    self.delegate = delegate;
    self.imgMore.image = [UIImage imageNamed:@"iconext"];
    self.lblName.text = label;
    [self initHit:hit];
    
}

- (void)initStretchWidth:(NSString *)label {
    
    NSDictionary *attribute = @{NSFontAttributeName:self.lblName.font};
    CGRect rect = [label boundingRectWithSize:CGSizeMake(320,2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    [self.lblName setLs_width:rect.size.width];
    [self.lblVal setLs_left:(11+rect.size.width+10)];
    [self.lblVal setLs_width:(self.view.ls_width-33-(11+rect.size.width+10))];
}

- (void)initIndent:(NSString *)label withHit:(NSString *)hit isrequest:(BOOL)req delegate:(id<IEditItemListEvent>)delegate {
    
    self.delegate = delegate;
    UIColor *color = req ? [UIColor redColor]:[ColorHelper getTipColor9];
    NSString *hitStr = req ? @"必填":@"可不填";
    self.lblVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:hitStr attributes:@{NSForegroundColorAttributeName: color}];

    self.imgIndent.hidden = NO;
    self.lblName.text = label;
    
    [self.lblName setLs_left:30];
    [self.lblTip setLs_left:30];
    
    NSDictionary *attribute = @{NSFontAttributeName:self.lblName.font};
    CGRect rect = [label boundingRectWithSize:CGSizeMake(320,2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    [self.lblName setLs_width:rect.size.width];
    [self.lblVal setLs_left:(30+rect.size.width+10)];
    [self.lblVal setLs_width:(self.view.ls_width-33-(30+rect.size.width+10))];
    
    self.lblDetail.text = nil;
    self.lblDetail.font = [UIFont systemFontOfSize:12];
    self.lblDetail.frame = CGRectMake(25, 32, 250, 40);

    self.lblDetail.text = hit;
    [self.lblDetail setTextColor:[ColorHelper getTipColor6]];
    if ([NSString isBlank:hit]) {
        [self.lblDetail setLs_height:0];
        [self.line setLs_top:46];
    } else {
        [self.lblDetail sizeToFit];
        [self.line setLs_top:(self.lblDetail.ls_top+self.lblDetail.ls_height+15)];
    }
    self.lblVal.textColor = [ColorHelper getBlueColor];
    [self.view setLs_height:[self getHeight]];
    [self setLs_height:[self getHeight]];
}

- (float)getHeight {
    
    CGFloat height = _line.ls_bottom + 1.0f;
    _btn.frame = CGRectMake(0, 0, self.ls_width, height);
    return height;
}

#pragma mark - initUI
- (void)initLabel:(NSString *)label withDataLabel:(NSString *)dataLabel withVal:(NSString *)data
{
    self.oldVal = ([NSString isBlank:data]) ? @"" :data;;
    [self changeLabel:label withDataLabel:dataLabel withVal:data];
}

- (void)initData:(NSString *)dataLabel withVal:(NSString *)data {
   
    self.oldVal = ([NSString isBlank:data]) ? @"" :data;
    self.lblVal1.text = ([NSString isBlank:dataLabel]) ? @"" :dataLabel;
    self.lblVal.text = ([NSString isBlank:dataLabel]) ? @"" :dataLabel;
    self.lblVal1.textColor = ([NSString isBlank:dataLabel]) ? [ColorHelper getRedColor] :[ColorHelper getBlueColor];
    self.currentVal = ([NSString isBlank:data]) ? @"" :data;
    [self changeStatus];
//    [self changeData:dataLabel withVal:data];
}

- (void)initData:(NSString *)dataLabel withVal:(NSString *)data groupVal:(NSInteger)val {
   
    self.oldVal = ([NSString isBlank:data]) ? @"" :data;
    if (val>0) {
        self.groupSortCode = val;
    }
    [self changeData:dataLabel withVal:data];
    
}
- (void)changeData:(NSString *)dataLabel withVal:(NSString *)data groupVal:(NSInteger)val {
    
    self.lblVal.text = ([NSString isBlank:dataLabel]) ? @"" :dataLabel;
    if (val > 0) {
        self.groupSortCode = val;
    }
    self.currentVal = ([NSString isBlank:data]) ? @"" :data;;
    [self changeStatus];
}

#pragma  mark - change UI display
- (void)changeLabel:(NSString *)label withDataLabel:(NSString *)dataLabel withVal:(NSString *)data
{
    self.lblName.text = ([NSString isBlank:label]) ? @"" :label;
    [self changeData:dataLabel withVal:data];
}

- (void)changeData:(NSString *)dataLabel withVal:(NSString *)data {
   
    self.lblVal.text = ([NSString isBlank:dataLabel]) ? @"" :dataLabel;
    self.lblVal1.text = ([NSString isBlank:dataLabel]) ? @"必填" :dataLabel;
     self.lblVal1.textColor = ([NSString isBlank:dataLabel]) ? [ColorHelper getRedColor] :[ColorHelper getBlueColor];
    self.currentVal = ([NSString isBlank:data]) ? @"" :data;;
    [self changeStatus];
}

#pragma mark - change status
- (void)changeStatus {
    [super isChange];
}

- (IBAction)btnMoreClick:(id)sender {
    [SystemUtil hideKeyboard];
    [self.delegate onItemListClick:self];
}

- (void)clearChange {
    self.oldVal = self.currentVal;
    [self changeStatus];
}

#pragma mark - 得到返回值.
- (NSString *)getStrVal {
    return self.currentVal;
}

- (NSInteger)getGroupVal {
    return self.groupSortCode;
}

- (NSString *)getDataLabel {
    return self.lblVal.text;
}

- (void)editEnable:(BOOL)enable {
    
    self.imgMore.hidden = !enable;
    self.btn.hidden = !enable;
    self.lblVal.ls_right = enable ? 287 :311;
    self.lblVal1.ls_right = enable ? 287 : 311;
    self.lblVal.textColor = enable?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
    self.lblVal1.textColor = enable?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
}

@end
