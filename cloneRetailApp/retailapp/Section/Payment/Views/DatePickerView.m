//
//  DatePickerView.m
//  RestApp
//
//  Created by guozhi on 16/8/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "DatePickerView.h"
@interface DatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, assign)NSInteger row;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIView *containerView;
@property(nonatomic, strong)NSMutableArray *years;
@property(nonatomic, strong)NSArray *monthes;
@end

@implementation DatePickerView
- (instancetype)initWithFrame:(CGRect)frame  title:(NSString *)title client:(id<DatePickerViewEvent>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self updateView:frame];
        self.titleLabel.text = title;
        self.delegate = delegate;
    }
    return self;
}

#pragma mark ui界面
-(void)updateView:(CGRect)frame{
    self.minYear = 2016;
     self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0,frame.size.height- 327, frame.size.width, 327)];
    self.containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.containerView];
    
    UIImageView *heardImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,5)];
    heardImg.image = [UIImage imageNamed:@"img_bill_top.png"];
    [self.containerView addSubview:heardImg];
    
    UIView *backgroudView = [[UIView alloc]initWithFrame:CGRectMake(0,5, frame.size.width, 322)];
    backgroudView.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:backgroudView];
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, frame.size.width, 21)];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.titleLabel];
    
    
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, frame.size.width-20, 216)];
    backView.backgroundColor = [UIColor redColor];
    backView.center = CGPointMake(frame.size.width/2,156);
    backView.alpha = 0.3f;
    [self.containerView addSubview:backView];
    
    
    
    UIView *rowView = [[UIView alloc]initWithFrame:CGRectMake(0,0, frame.size.width-20, 36)];
    rowView.backgroundColor = [UIColor redColor];
    rowView.alpha = 0.5f;
    rowView.center = backView.center;
    [self.containerView addSubview:rowView];
    
    
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width-20, 216)];
    self.pickerView.backgroundColor = [UIColor clearColor];
    self.pickerView.center = backView.center;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.containerView addSubview:self.pickerView];
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(frame.size.width-150, 272, 140,44);
    confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
    confirmBtn.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:52.0/255.0 blue:62.0/255.0 alpha:1];
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.layer.masksToBounds = YES;
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:confirmBtn];
    
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(10, 272, 140,44);
    cancleBtn.layer.cornerRadius = 5;
    cancleBtn.layer.masksToBounds = YES;
    cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    cancleBtn.backgroundColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:cancleBtn];
}
#pragma mark 初始化数据
-(void)initDate:(NSUInteger)year month:(NSUInteger)month{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [UIView animateWithDuration:.2 animations:^{
        self.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    }];
    
    [self.pickerView selectRow:[self getDataIndex:self.years number:[NSNumber numberWithUnsignedInteger:year]] inComponent:0 animated:YES];
    [self.pickerView selectRow:[self getDataIndex:self.monthes number:[NSNumber numberWithUnsignedInteger:month]] inComponent:1 animated:YES];
    
}

-(NSInteger)getDataIndex:(NSArray *)datas number:(NSNumber*)number{
    
    for (int i = 0; i < datas.count; i++) {
        if ( [number integerValue] == [datas[i] integerValue]) {
            return i;
        }
        
    }
    return 0;
}

#pragma mark  数据源
-(NSArray *)monthes{
    if (!_monthes) {
        
        _monthes = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12];
    }
    return _monthes;
}
-(NSMutableArray *)years{
    if (!_years) {
        
        NSCalendar* calendar=[NSCalendar currentCalendar];
        NSDateComponents* comps=[calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:[NSDate date]];
        NSInteger maxYear=[comps year];
        _years = [NSMutableArray array];
        for (int i = self.minYear; i <= maxYear; i++) {
            [_years addObject:[NSNumber numberWithInt:i]];
        }
    }
    return _years;
}



#pragma mark pickerView Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        
        return self.years.count;
    }
    return self.monthes.count;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [NSString stringWithFormat:@"%ld年",[self.years[row] integerValue]];
    }
    return [NSString stringWithFormat:@"%ld月",[self.monthes[row] integerValue]];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel *)view;
    if (pickerLabel==nil) {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:component == 0?NSTextAlignmentCenter:NSTextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:21]];
        pickerLabel.adjustsFontSizeToFitWidth=YES;
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if(component == 0){
        return self.pickerView.bounds.size.width/2 +30;
    }
    return self.pickerView.bounds.size.width/2 -30;
}

-(NSUInteger)year{
    NSInteger section = [self.pickerView selectedRowInComponent:0];
    return  [self.years[section] integerValue];
}

-(NSUInteger)month{
    NSInteger row = [self.pickerView selectedRowInComponent:1];
    return [self.monthes[row] integerValue];
}
#pragma mark button
-(void)confirmBtnClick:(UIButton *)button{
    if([self.delegate respondsToSelector:@selector(pickerOption:eventType:)])
    {
        [self.delegate pickerOption:self eventType:self.tag];
    }
    [self dismissFromSuperView];
}



-(void)cancleBtnClick:(UIButton *)button{
    
    [self dismissFromSuperView];
}

-(void)dismissFromSuperView{
     [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(!CGRectContainsPoint(self.containerView.frame, point)){
        [self dismissFromSuperView];
}
}


@end
