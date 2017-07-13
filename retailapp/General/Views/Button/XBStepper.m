//
//  XBStepper.m
//  retailapp
//
//  Created by hm on 15/7/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "XBStepper.h"
#import "SymbolNumberInputBox.h"
#import "ColorHelper.h"
#import "AlertBox.h"
#import "LSMemberMeterDetailCell.h"

@interface XBStepper ()<SymbolNumberInputClient>

@property (nonatomic) BOOL isSymbol;
@end
@implementation XBStepper

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color
{
    self = [super initWithFrame:frame];
    
    if (self) {
       
        _myColor = color;
        _valueMax = 999999.99;
        _valueMin = 0;
        _valueNow = 0.00;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = _myColor.CGColor;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        [self AddUIs];
//        [self reloadStepper];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadStepper) name:XBStepperNotificationKey object:nil];
    }
    return self;
}

/**
 *  创建按钮
 */
- (void)AddUIs {
    
    CGFloat btnWidth = 30.0f;
    
    _btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_btnEdit addTarget:self action:@selector(btnActionEdit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnEdit];
    
    _lblCount = [[UILabel alloc] initWithFrame:
                 CGRectMake(btnWidth+1, 1, self.frame.size.width - btnWidth*2-1, self.frame.size.height-2)];
    _lblCount.textColor = _myColor;
    _lblCount.font = [UIFont systemFontOfSize:13];
    _lblCount.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_lblCount];
    
    _btnDecrease = [self tempButton:
                    CGRectMake(0, 0, btnWidth, self.frame.size.height) title:@"-"];
    [_btnDecrease addTarget:self action:@selector(btnActionDecease) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnDecrease];
    
    _btnIncrease = [self tempButton:
                    CGRectMake(self.frame.size.width - btnWidth, 0, btnWidth, self.frame.size.height) title:@"+"];
    [_btnIncrease addTarget:self action:@selector(btnActionIncease) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnIncrease];
    
//    _lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, self.frame.size.width-22, self.frame.size.height-2)];
    _lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, self.frame.size.width-22, self.frame.size.height-13)];
    _lblPrice.font = [UIFont systemFontOfSize:13];
    _lblPrice.textAlignment = NSTextAlignmentRight;
    _lblPrice.hidden  =YES;
    [self addSubview:_lblPrice];
    
    _nextPic = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-22, (self.frame.size.height-22)/2.0, 22, 22)];
    _nextPic.ls_centerY = _lblPrice.ls_centerY;
    _nextPic.image = [UIImage imageNamed:@"ico_next_down"];
    _nextPic.hidden = YES;
    [self addSubview:_nextPic];
    
    _lblCount.textColor = [ColorHelper getBlueColor];
    _lblPrice.textColor = [ColorHelper getBlueColor];
    [_btnDecrease setTitleColor:_myColor forState:UIControlStateNormal];
    [_btnIncrease setTitleColor:_myColor forState:UIControlStateNormal];
}

/**
 *  UIButton初始化
 */
- (UIButton*)tempButton:(CGRect)frame title:(NSString*)title {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.frame = btn.frame;

    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    [btn.titleLabel setFont:[UIFont systemFontOfSize:25]];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:_myColor forState:UIControlStateNormal];
    
    CALayer *line = [CALayer layer];
    line.backgroundColor = _myColor.CGColor;
    CGFloat originX = frame.origin.x > 10 ? 0 : CGRectGetWidth(frame) - 0.5;
    line.frame = CGRectMake(originX, 0, 0.8, 34.0f);
    [btn.layer addSublayer:line];
    return btn;
}

/**
 *  修改这个方法应特别注意：结合OrderPaperEditView 和 PurchasePaperEditView 中的代理方法needChangeValue
 *  编辑时候最大支持200项，大于200项给予提示
 *
 */
- (BOOL)canChangeValue {
    
    BOOL needChangeValue = YES;
    if (self.stepperDelegate && [self.stepperDelegate respondsToSelector:@selector(needChangeValue:)]) {
        needChangeValue = [self.stepperDelegate needChangeValue:(PaperGoodsCell *)self.superview];
    }
    return needChangeValue;
}

#pragma mark - 加减事件
- (void)btnActionDecease {
    
    if ([self canChangeValue]) {
        
        if (_myBlock) {
            _myBlock(&_valueNow ,-1 ,NO);
        }
    }
}

- (void)btnActionIncease {
   
    if ([self canChangeValue]) {
       
        if (_myBlock) {
            _myBlock(&_valueNow ,1 ,NO);
        }
    }
}

- (void)btnActionEdit
{
    if (_mode == PaperGoodsCellTypeCount)
    {
        [SymbolNumberInputBox initData:_lblCount.text];
        [SymbolNumberInputBox show:@"数量" client:self isFloat:_isFloat isSymbol:_isSymbol event:100];
        if (self.isStockAdjust) {
             [SymbolNumberInputBox limitInputNumber:6 digitLimit:3];
        } else {
             [SymbolNumberInputBox limitInputNumber:4 digitLimit:3];
        }
       
    }
    else
    {
        NSString *title = nil;
        if (_mode == PaperGoodsCellTypePrice) {
            if (self.paperType == ORDER_PAPER_TYPE || self.paperType == CLIENT_ORDER_PAPER_TYPE) {//采购单 客户采货单
                title = @"采购价";
            } else if (self.paperType == PURCHASE_PAPER_TYPE) {//收货入库单
                title = @"进货价";
            } else if (self.paperType == RETURN_PAPER_TYPE || self.paperType == CLIENT_RETURN_PAPER_TYPE) {//退货出库单  客户退货单
                title = @"退货价";
            } else {
                title = @"价格";
            }
        } else {
            title = @"金额";
        }
        [SymbolNumberInputBox initData:_lblPrice.text];
        [SymbolNumberInputBox show:title client:self isFloat:YES isSymbol:NO event:101];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    }
}

- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
//    _valueNow = [val doubleValue];
//    [self reloadStepper];
    double dValue = [val doubleValue];
    if (_myBlock) {
        _myBlock(&_valueNow ,dValue ,YES);
    }
}


/**
 *  新值改变后，更新UI
 */
- (void)reloadStepper {
    
    [_btnIncrease setTitleColor:_myColor forState:UIControlStateNormal];
    [_btnDecrease setTitleColor:_myColor forState:UIControlStateNormal];
    
    if (_valueNow >= _valueMax) {
       
        _valueNow = _valueMax;
        [_btnIncrease setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else if (_valueNow <= _valueMin) {
       
        _valueNow = _valueMin;
        [_btnDecrease setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    _lblCount.text = _isFloat ? [NSString stringWithFormat:@"%.3f",_valueNow]:[NSString stringWithFormat:@"%.0f",_valueNow];
    _lblPrice.text = [NSString stringWithFormat:@"%.2f",_valueNow];
}


- (void)setMaxValue:(double)max min:(double)min count:(double)count price:(double)price; {
  
    _valueMax = max;
    _valueMin = min;
    _valueNow = (_mode == 0) ? count : price;
    self.lblCount.text = _isFloat?[NSString stringWithFormat:@"%.3f",count]:[NSString stringWithFormat:@"%.0f",count];
    self.lblPrice.text = [NSString stringWithFormat:@"%.2f",price];
}

- (void)setMaxValue:(double)max min:(double)min mode:(PaperGoodsCellType)model count:(double)count price:(double)price amount:(double)amount {
    
    _valueMax = max;
    _valueMin = min;
    _valueNow = (_mode == 0) ? count : price;
    self.lblCount.text = _isFloat?[NSString stringWithFormat:@"%.3f",count]:[NSString stringWithFormat:@"%.0f",count];
    if (model == PaperGoodsCellTypePrice) {
        self.lblPrice.text = [NSString stringWithFormat:@"%.2f",price];
    } else if (model == PaperGoodsCellTypeAmount) {
        self.lblPrice.text = [NSString stringWithFormat:@"%.2f",amount];
    }
    
}

- (void)startMode:(PaperGoodsCellType)mode isEdit:(BOOL)isEdit isFloat:(BOOL)isFloat isSymbol:(BOOL)isSymbol withBlock:(XBStepperCallback)block
{
    _myBlock = block;
    _isFloat = isFloat;
    _isSymbol = isSymbol;
    [self changeMode:mode isEdit:isEdit];
}

- (void)changeMode:(PaperGoodsCellType)mode isEdit:(BOOL)isEdit
{
    _mode = mode;
    _btnDecrease.hidden = !isEdit||!(mode==PaperGoodsCellTypeCount);
    _btnIncrease.hidden = !isEdit||!(mode==PaperGoodsCellTypeCount);
    _lblCount.hidden = !(mode==PaperGoodsCellTypeCount);
    _lblPrice.hidden = (mode==PaperGoodsCellTypeCount);
    _nextPic.hidden = (mode==PaperGoodsCellTypeCount);
    _btnEdit.hidden = !isEdit;
    _lblCount.textColor = isEdit?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
    _lblPrice.textColor = isEdit?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
    self.layer.borderWidth = isEdit&&(mode==PaperGoodsCellTypeCount)?0.5:0;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XBStepperNotificationKey object:nil];
}

@end
