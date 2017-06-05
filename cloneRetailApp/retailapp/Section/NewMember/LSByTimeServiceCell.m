//
//  LSByTimeServiceCell.m
//  retailapp
//
//  Created by taihangju on 2017/4/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSByTimeServiceCell.h"
#import "LSByTimeServiceVo.h"
#import "DateUtils.h"
#import "ColorHelper.h"

@interface LSByTimeGoodView : UIView

@property (nonatomic, strong) UILabel *goodName;/**<商品名称>*/
@property (nonatomic, strong) UILabel *goodId;/**<商品标识码>*/
@property (nonatomic, strong) UILabel *goodCount;/**<商品计数信息>*/
@property (nonatomic, strong) UIView *bottomLine;/**<分割线>*/
@end

@implementation LSByTimeGoodView

+ (instancetype)byTimeGoodViewWith:(LSByTimeGoodVo *)goodVo frame:(CGRect)frame {
    
    LSByTimeGoodView *byTimeGoodView = [[LSByTimeGoodView alloc] initWithFrame:frame];
    byTimeGoodView.translatesAutoresizingMaskIntoConstraints = NO;
    byTimeGoodView.backgroundColor = [ColorHelper getBackgroundColorf2];
    
    UILabel *lblName = [[UILabel alloc] init];
    lblName.textColor = [ColorHelper getTipColor3];
    lblName.font = [UIFont systemFontOfSize:15.0f];
    lblName.text = goodVo.goodsName;
    lblName.numberOfLines = 0;
    [byTimeGoodView addSubview:lblName];
    byTimeGoodView.goodName = lblName;
    
    UILabel *lblCode = [[UILabel alloc] init];
    lblCode.textColor = [ColorHelper getTipColor6];
    lblCode.font = [UIFont systemFontOfSize:13.0f];
    lblCode.text = goodVo.barCode;
    [byTimeGoodView addSubview:lblCode];
    byTimeGoodView.goodId = lblCode;
    
    UILabel *lblTime = [[UILabel alloc] init];
    lblTime.textAlignment = NSTextAlignmentRight;
    lblTime.textColor = [ColorHelper getTipColor6];
    lblTime.font = [UIFont systemFontOfSize:13.0f];
    
    lblTime.text = [NSString stringWithFormat:@"次数: %@/%@" ,goodVo.consumeResidueTime,goodVo.consumeTime];
    [byTimeGoodView addSubview:lblTime];
    byTimeGoodView.goodId = lblTime;
    
    CGFloat lineHeight = 1.0/[UIScreen mainScreen].scale;
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [byTimeGoodView addSubview:line];
    byTimeGoodView.bottomLine = line;
    

    [lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@16);
        make.left.equalTo(@14);
        make.right.lessThanOrEqualTo(byTimeGoodView.mas_right).with.offset(-9);
    }];
    
    [lblCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblName.mas_left);
        make.top.equalTo(lblName.mas_bottom).offset(8);
        make.height.equalTo(@13);
        make.bottom.equalTo(byTimeGoodView.mas_bottom).offset(-18);
    }];
    
    [lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(byTimeGoodView.mas_right).offset(-9);
        make.top.equalTo(lblCode.mas_top);
        make.height.equalTo(lblCode.mas_height);
        make.bottom.equalTo(lblCode.mas_bottom);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(byTimeGoodView.mas_left).offset(10.0f);
        make.right.equalTo(byTimeGoodView.mas_right).offset(-10.0f);
        make.bottom.equalTo(byTimeGoodView.mas_bottom);
        make.height.equalTo(lineHeight);
    }];
    
    return byTimeGoodView;
}

@end


@interface LSByTimeServiceCell ()

@property (weak, nonatomic) IBOutlet UIView *wrapperView; // 内容承载view，位于cell.contentView上
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *expired; // 过期提示
@property (weak, nonatomic) IBOutlet UIView *goodsWrapperView; // 计次商品承载view，位于wrapperView之上
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTrailConstraint; // name 距离父view右侧距离
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsWrapperViewHeightContraint;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn; // 点击展开或收起“详情”
@property (nonatomic, copy) void (^callBackBlock)();/**<回调block>*/
@property (nonatomic, strong) LSByTimeServiceVo *byTimeServiceVo;/**<>*/
@end

@implementation LSByTimeServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _wrapperView.layer.masksToBounds = YES;
    _wrapperView.layer.cornerRadius = 5.0f;
    [_expired ls_addCornerWithRadii:10.0 roundRect:_expired.bounds];
}

- (void)prepareForReuse {
    [_goodsWrapperView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _detailBtn.imageView.transform = CGAffineTransformIdentity;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

// 点击查看“
- (IBAction)checkDetailAction:(UIButton *)sender {
    
    // 展开或者隐藏“计次商品列表”
    _byTimeServiceVo.isExpand = !_byTimeServiceVo.isExpand;

    // 回调通知控制器进行界面的更新
    if (_callBackBlock) {
        _callBackBlock();
    }
}


// 数据填充，生成计次商品展示
- (void)fillCellData:(LSByTimeServiceVo *)vo expired:(BOOL)isExpiry callBackBlock:(void (^)())block {
    
    self.byTimeServiceVo = vo;
    self.callBackBlock = block;
    _name.text = vo.accountCardName;
    NSString *string = [NSString stringWithFormat:@"计次商品%@项",[vo goodNumberString]];
    NSMutableAttributedString *atttributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0],NSForegroundColorAttributeName:[ColorHelper getTipColor3]}];
    [atttributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[ColorHelper getOrangeColor]} range:[string rangeOfString:[vo goodNumberString]]];
    _count.attributedText = atttributedString;
//    NSString *startTime = [DateUtils formateTime2:vo.startDate.longLongValue];
//    NSString *endTime = [DateUtils formateTime2:vo.endDate.longLongValue];
//    _time.text = [NSString stringWithFormat:@"有效期: %@至%@" ,startTime ,endTime];
    _time.text = [vo validTimeString];
    
    // 针对“已过期”，“已用完”，“已退款”等非可用状态的计次卡，调整计次服务名称的布局
    if (isExpiry) {
        _expired.hidden = NO;
        _expired.text = [vo statusString];
        [_nameTrailConstraint setConstant:72.0f];
    }
    
    // 生成展示计次商品信息的view
    if (vo.isExpand && vo.goodsArray) {
        _detailBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        [self generateByTimeGoodsDisplayView];
    }
    [self layoutIfNeeded];
}


// 生成计次商品展示view
- (void)generateByTimeGoodsDisplayView {
    
    if (self.goodsWrapperView.subviews.count > 0) {
        [self.goodsWrapperView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    __weak typeof(self) wself = self;
    __block UIView *view = nil;   // 引用
    [_byTimeServiceVo.goodsArray enumerateObjectsUsingBlock:^(LSByTimeGoodVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {

        LSByTimeGoodView *goodView = [LSByTimeGoodView byTimeGoodViewWith:obj frame:CGRectZero];
        [_goodsWrapperView addSubview:goodView];
        
        [goodView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(wself.goodsWrapperView.mas_left);
            make.right.equalTo(wself.goodsWrapperView.mas_right);
            if (idx == 0) {
                make.top.equalTo(wself.goodsWrapperView.mas_top);
            } else {
                make.top.equalTo(view.mas_bottom);
            }
            if (idx == wself.byTimeServiceVo.goodsArray.count-1) {
                make.bottom.equalTo(wself.goodsWrapperView.mas_bottom);
            }
        }];
        
        view = goodView;
    }];
}


//- (void)dealloc {
//    NSLog(@"%@：cell 被释放了\n",self);
//}
@end


