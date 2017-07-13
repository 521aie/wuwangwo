
#import "MonthPicker.h"
#import "ColorHelper.h"
#define MONTH_ROW_MULTIPLIER 340
#define DEFAULT_MINIMUM_YEAR 1900
#define DEFAULT_MAXIMUM_YEAR 2200
#define DATE_COMPONENT_FLAGS NSCalendarUnitMonth | NSCalendarUnitYear

@interface MonthPicker()

@property (nonatomic) int monthComponent;
@property (nonatomic) int yearComponent;
@property (nonatomic, readonly) NSArray *monthStrings;

-(NSInteger)yearFromRow:(NSInteger)row;
-(NSInteger)rowFromYear:(NSInteger)year;

@end

@implementation MonthPicker

@synthesize date = _date;
@synthesize monthStrings = _monthStrings;
@synthesize enableColourRow = _enableColourRow;
@synthesize monthPickerDelegate = _monthPickerDelegate;

-(id)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        [self prepare];
        [self setDate:date];
        self.showsSelectionIndicator = YES;
    }
    
    return self;
}

- (id)init {
    self = [self initWithDate:[NSDate date]];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self prepare];
        if (!_date)
            [self setDate:[NSDate date]];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self prepare];
        if (!_date)
            [self setDate:[NSDate date]];
    }
    return self;
}

- (void)prepare {
    self.dataSource = self;
    self.delegate = self;
    
    _enableColourRow = YES;
    _wrapMonths = YES;
}

- (id<UIPickerViewDelegate>)delegate {
    return self;
}

- (void)setDelegate:(id<UIPickerViewDelegate>)delegate {
    if ([delegate isEqual:self])
        [super setDelegate:delegate];
}

- (id<UIPickerViewDataSource>)dataSource {
    return self;
}

-(void)setDataSource:(id<UIPickerViewDataSource>)dataSource {
    if ([dataSource isEqual:self])
        [super setDataSource:dataSource];
}

- (int)monthComponent {
    return self.yearComponent ^ 1;
}

- (int)yearComponent {
    return !self.yearFirst;
}

- (NSArray *)monthStrings {
    
    if (!_monthStrings) {
        _monthStrings = [NSArray arrayWithObjects:@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",
                         @"7月",@"8月",@"9月",@"10月",@"11月",@"12月",nil];
    }
    return _monthStrings;
}

-(void)setYearFirst:(BOOL)yearFirst
{
    _yearFirst = yearFirst;
    NSDate* date = self.date;
    [self reloadAllComponents];
    [self setNeedsLayout];
    [self setDate:date];
}

-(void)setMinimumYear:(NSNumber *)minimumYear
{
    NSDate* currentDate = self.date;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:DATE_COMPONENT_FLAGS fromDate:currentDate];
    components.timeZone = [NSTimeZone defaultTimeZone];
    
    if (minimumYear && components.year < minimumYear.integerValue)
        components.year = minimumYear.integerValue;
    
    _minimumYear = minimumYear;
    [self reloadAllComponents];
    [self setDate:[[NSCalendar currentCalendar] dateFromComponents:components]];
}

-(void)setMaximumYear:(NSNumber *)maximumYear
{
    NSDate* currentDate = self.date;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:DATE_COMPONENT_FLAGS fromDate:currentDate];
    components.timeZone = [NSTimeZone defaultTimeZone];
    
    if (maximumYear && components.year > maximumYear.integerValue)
        components.year = maximumYear.integerValue;
    
    _maximumYear = maximumYear;
    [self reloadAllComponents];
    [self setDate:[[NSCalendar currentCalendar] dateFromComponents:components]];
}

-(void)setMinimumDate:(NSDate *)minimumDate {
    
    NSDateComponents *componentsByDate = [[NSCalendar currentCalendar] components:DATE_COMPONENT_FLAGS fromDate:minimumDate];
    NSNumber *minimumYear = [NSNumber numberWithInteger:componentsByDate.year];
    
    NSDate* currentDate = self.date;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:DATE_COMPONENT_FLAGS fromDate:currentDate];
    components.timeZone = [NSTimeZone defaultTimeZone];
    
    if (minimumYear && components.year < minimumYear.integerValue)
        components.year = minimumYear.integerValue;
    
    _minimumYear = minimumYear;
    [self reloadAllComponents];
    [self setDate:[[NSCalendar currentCalendar] dateFromComponents:components]];
}


-(void)setWrapMonths:(BOOL)wrapMonths
{
    _wrapMonths = wrapMonths;
    [self reloadAllComponents];
}

-(NSInteger)yearFromRow:(NSInteger)row
{
    NSInteger minYear = DEFAULT_MINIMUM_YEAR;
    
    if (self.minimumYear)
        minYear = self.minimumYear.integerValue;
    
    return row + minYear;
}

-(NSInteger)rowFromYear:(NSInteger)year
{
    NSInteger minYear = DEFAULT_MINIMUM_YEAR;
    
    if (self.minimumYear)
        minYear = self.minimumYear.integerValue;
    
    return year - minYear;
}

-(void)setDate:(NSDate *)date
{
    NSDateComponents* components = [[NSCalendar currentCalendar] components:DATE_COMPONENT_FLAGS fromDate:date];
    components.timeZone = [NSTimeZone defaultTimeZone];
    
    if (self.minimumYear && components.year < self.minimumYear.integerValue)
        components.year = self.minimumYear.integerValue;
    else if (self.maximumYear && components.year > self.maximumYear.integerValue)
        components.year = self.maximumYear.integerValue;
    
    if(self.wrapMonths){
        NSInteger monthMidpoint = (NSInteger)self.monthStrings.count * (MONTH_ROW_MULTIPLIER / 2);
        
        [self selectRow:(components.month - 1 + monthMidpoint) inComponent:self.monthComponent animated:NO];
    }
    else {
        [self selectRow:(components.month - 1) inComponent:self.monthComponent animated:NO];
    }
    [self selectRow:[self rowFromYear:components.year] inComponent:self.yearComponent animated:NO];
    
    _date = [[NSCalendar currentCalendar] dateFromComponents:components];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.month = 1 + ([self selectedRowInComponent:self.monthComponent] % self.monthStrings.count);
    components.year = [self yearFromRow:[self selectedRowInComponent:self.yearComponent]];
    
    [self willChangeValueForKey:@"date"];
    if ([self.monthPickerDelegate respondsToSelector:@selector(monthPickerWillChangeDate:)])
        [self.monthPickerDelegate monthPickerWillChangeDate:self];
    
    _date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    if ([self.monthPickerDelegate respondsToSelector:@selector(monthPickerDidChangeDate:)])
        [self.monthPickerDelegate monthPickerDidChangeDate:self];
    [self didChangeValueForKey:@"date"];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == self.monthComponent && !self.wrapMonths)
        return self.monthStrings.count;
    else if(component == self.monthComponent)
        return MONTH_ROW_MULTIPLIER * self.monthStrings.count;
    
    NSInteger maxYear = DEFAULT_MAXIMUM_YEAR;
    if (self.maximumYear)
        maxYear = self.maximumYear.integerValue;
    
    return [self rowFromYear:maxYear] + 1;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == self.monthComponent)
        return 120.0f;
    else
        return 110.0f;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGFloat width = [self pickerView:self widthForComponent:component];
    CGRect frame = CGRectMake(0.0f, 0.0f, width, 45.0f);
    
    if (component == self.monthComponent)
    {
        const CGFloat padding = 9.0f;
        if (component) {
            frame.origin.x += padding;
            frame.size.width -= padding;
        }
        
        frame.size.width -= padding;
    }
    
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //yyyy年MM月
    if (component == self.monthComponent) {
        label.text = [self.monthStrings objectAtIndex:(row % self.monthStrings.count)];
        formatter.dateFormat = @"MMMM";
        label.textAlignment = NSTextAlignmentCenter;
    } else {
        label.text = [NSString stringWithFormat:@"%ld年", (long)[self yearFromRow:row]];
        label.textAlignment = NSTextAlignmentCenter;
        formatter.dateFormat = @"y";
    }
    
//    if (_enableColourRow && [[formatter stringFromDate:[NSDate date]] isEqualToString:label.text])
//        label.textColor = [UIColor colorWithRed:0.0f green:0.35f blue:0.91f alpha:1.0f];
    
    label.font = [UIFont systemFontOfSize:23.0f];
    label.textColor = [ColorHelper getBlackColor];
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0.0f, 0.1f);
    label.shadowColor = [UIColor whiteColor];
    
    return label;
}



@end
