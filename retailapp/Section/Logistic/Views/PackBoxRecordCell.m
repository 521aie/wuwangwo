//
//  PackBoxRecordCell.m
//  retailapp
//
//  Created by hm on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PackBoxRecordCell.h"
#import "XBStepper.h"
#import "ColorHelper.h"
#import "GoodsPackRecordVo.h"

@implementation PackBoxRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize
{
    _stepper = [[XBStepper alloc] initWithFrame:CGRectMake(145, 40, 155, 35) color:[ColorHelper getTipColor6]];
    _stepper.backgroundColor = [UIColor clearColor];
    _stepper.ls_right = SCREEN_W - 10;
    _stepper.myBlock = nil;
    [self addSubview:_stepper];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataWithItem:(GoodsPackRecordVo *)obj isEdit:(BOOL)isEdit
{
    self.lblCount.hidden = isEdit;
    self.stepper.hidden = !isEdit;
    self.item = obj;
    if (isEdit) {
        __weak typeof(self) weakSelf = self;
        [self.stepper startMode:PaperGoodsCellTypeCount isEdit:isEdit isFloat:NO isSymbol:NO withBlock:^(double *nowValue ,double dValue ,BOOL isReplace) {
            
            if (isReplace) {
                *nowValue = dValue;
            }
            else
            {
                *nowValue += dValue;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:XBStepperNotificationKey object:nil];
            weakSelf.item.realSum = [NSNumber numberWithDouble:*nowValue];
            if (*nowValue == 0) {
                [weakSelf.delegate delObj:weakSelf.item.returnGoodsDetailId];
            }
            [weakSelf changeVal];
        }];
        [self.stepper setMaxValue:999999 min:0 count:[obj.realSum intValue] price:0];
    }
    else
    {
        self.lblCount.text = [NSString stringWithFormat:@"%d",[obj.realSum intValue]];
    }
}

- (void)changeVal
{
    self.item.changeFlag = [self.item.oldSum isEqualToNumber:self.item.realSum]?0:1;
    self.item.operateType = (self.item.changeFlag==1)?@"edit":@"";
    [self showTip:self.item.changeFlag];
    [self.delegate changeNavigateUI];
}

-(void)showTip:(BOOL)show
{
    _lblTip.hidden = !show;
    _lblTip.layer.backgroundColor=[UIColor redColor].CGColor;
    _lblTip.textColor=[UIColor whiteColor];
    _lblTip.text=@"未保存";
    _lblTip.layer.cornerRadius = 2;
}

@end
