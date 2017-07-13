//
//  LSEditItemList.m
//  retailapp
//
//  Created by guozhi on 2017/3/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import "LSEditItemList.h"
#define kHeight 48
@interface LSEditItemList()


@end

@implementation LSEditItemList
+ (instancetype)editItemList {
    LSEditItemList *view = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, kHeight)];
    [view configViews];
    [view configConstraints];
    [view addGestureRecognizer];
   
    return view;
}

- (void)configViews {
    //未保存标志
    self.lblTip = [[UILabel alloc] init];
    self.lblTip.hidden = YES;
    self.lblTip.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.lblTip];
    //左侧名称
    self.lblName = [[UILabel alloc] init];
    self.lblName.font = [UIFont systemFontOfSize:15];
    self.lblName.textColor = [UIColor blackColor];
    [self addSubview:self.lblName];
    //右侧名称
    self.lblVal = [[UITextField alloc] init];
    self.lblVal.font = [UIFont systemFontOfSize:15];
    self.lblVal.textAlignment = NSTextAlignmentRight;
    self.lblVal.enabled = NO;
    self.lblVal.textColor = [ColorHelper getBlueColor];
    [self addSubview:self.lblVal];
    //右侧名称默认不显示
    self.lblVal1 = [[UILabel alloc] init];
    self.lblVal1.font = [UIFont systemFontOfSize:15];
    self.lblVal1.hidden = YES;
    self.lblVal1.numberOfLines = 0;
    self.lblVal1.textColor = [ColorHelper getBlueColor];
    [self addSubview:self.lblVal1];
    //右侧图标
    self.imgMore = [[UIImageView alloc] init];
    self.imgMore.image = [UIImage imageNamed:@"ico_next_down"];
    [self addSubview:self.imgMore];
    //详情内容
    self.lblDetail = [[UILabel alloc] init];
    self.lblDetail.numberOfLines = 0;
    self.lblDetail.textColor = [ColorHelper getTipColor6];
    self.lblDetail.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.lblDetail];
    //分割线
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self addSubview:self.line];
}
- (void)configConstraints {
    CGFloat margin = 10;//内容距离左右的间距是10
    //未保存标志
    __weak typeof(self) wself = self;
    [self.lblTip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(margin);
        make.top.equalTo(wself.top);
        make.size.equalTo(CGSizeMake(32, 12));
    }];
    //左侧名称
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(margin);
        make.centerY.equalTo(wself.top).offset(kHeight/2);
    }];
    //左侧内容优先显示
    [self.lblName setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    //右侧图片
    [self.imgMore makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.lblName);
        make.right.equalTo(wself.right).offset(-margin);
        make.size.equalTo(22);
    }];
    //右侧内容
    [self.lblVal makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.imgMore.left);
        make.centerY.equalTo(wself.lblName);
        make.left.greaterThanOrEqualTo(wself.lblName.right).offset(margin);
        make.height.equalTo(21);
        
    }];
    [self.lblVal1 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.imgMore.left);
        make.top.equalTo(wself.top);
        make.left.greaterThanOrEqualTo(wself.lblName.right).offset(margin);
        make.height.equalTo(kHeight);
        
    }];
    //详情内容
    [self.lblDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(margin);
        make.right.equalTo(wself.right).offset(-margin);
        make.top.equalTo(wself.top).offset(43);
    }];
    //分割线
    [self.line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(margin);
        make.right.equalTo(wself.right).offset(-margin);
        make.top.equalTo(wself.lblDetail.bottom).offset(margin);
        make.height.equalTo(1);
    }];
    [self layoutIfNeeded];
    self.ls_height = self.line.ls_bottom;
}

- (void)addGestureRecognizer {
     [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
}

- (void)tapClick:(UITapGestureRecognizer *)tagGes {
     [SystemUtil hideKeyboard];
    if ([self.delegate respondsToSelector:@selector(onItemListClick:)]) {
        [self.delegate onItemListClick:self];
    }
}

- (void)initHit:(NSString *)hit {
    self.lblDetail.text = hit;
    __weak typeof(self) wself = self;
    if ([NSString isBlank:hit]) {//如果没有详情
        [self.line remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(wself.top).offset(kHeight);
            make.left.equalTo(wself.left).offset(10);
            make.right.equalTo(wself.right).offset(-10);
            make.height.equalTo(1);
        }];
    } else {//如果有详情
        self.lblDetail.hidden = NO;
        [self.line remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wself.lblDetail.bottom).offset(10);
            make.left.equalTo(wself.left).offset(10);
            make.right.equalTo(wself.right).offset(-10);
            make.height.equalTo(1);
            
        }];
    }
    [self layoutIfNeeded];
    self.ls_height = self.line.ls_bottom;
}

- (void)initLabel:(NSString *)label withHit:(NSString *)hit delegate:(id<IEditItemListEvent>)delegate {
    [self initLabel:label withHit:hit isrequest:NO delegate:delegate];
}

- (void)initLabel:(NSString *)label withHit:(NSString *)hit isrequest:(BOOL)req delegate:(id<IEditItemListEvent>)delegateTmp {
    
    self.lblName.text = label;
    [self initHit:hit];
    self.delegate = delegateTmp;
    UIColor *color = req ? [UIColor redColor]:RGBA(153, 153, 153, 1);
    NSString *hitStr=req?@"必填":@"可不填";
    self.lblVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:hitStr attributes:@{NSForegroundColorAttributeName:color}];
    self.lblVal1.text = hitStr;
    self.lblVal1.textColor = color;
}

- (void)initData:(NSString *)dataLabel withVal:(NSString *)data {
    
    self.oldVal = ([NSString isBlank:data]) ? @"" :data;
    self.currentVal = ([NSString isBlank:data]) ? @"" :data;
    
    self.lblVal1.text = ([NSString isBlank:dataLabel]) ? @"" :dataLabel;
    self.lblVal.text = ([NSString isBlank:dataLabel]) ? @"" :dataLabel;
    self.lblVal1.textColor = ([NSString isBlank:dataLabel]) ? [ColorHelper getRedColor] :[ColorHelper getBlueColor];
    [self changeStatus];
}
- (void)changeData:(NSString *)dataLabel withVal:(NSString *)data {
    self.currentVal = ([NSString isBlank:data]) ? @"" :data;
    self.lblVal.text = ([NSString isBlank:dataLabel]) ? @"" :dataLabel;
    self.lblVal1.text = ([NSString isBlank:dataLabel]) ? @"必填" :dataLabel;
    self.lblVal1.textColor = ([NSString isBlank:dataLabel]) ? [ColorHelper getRedColor] :[ColorHelper getBlueColor];
    [self changeStatus];
}

- (NSString *)getStrVal {
    return self.currentVal;
}

- (NSString *)getDataLabel {
    return self.lblVal.text;
}

- (void)editEnable:(BOOL)enable {
    self.imgMore.hidden = !enable;
    self.userInteractionEnabled = enable;
    [self.imgMore updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(enable ? 22 : 0);
    }];
    self.lblVal.textColor = enable?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
    self.lblVal1.textColor = enable?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
}

- (void)changeStatus {
    [super isChange];
}

- (float)getHeight {
    [self layoutIfNeeded];
    return self.line.ls_bottom;
    
}

-(BOOL)getStatueNosave
{
    return self.lblTip.hidden;
}

@end
