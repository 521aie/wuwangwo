//
//  TDFFilterMoel.m
//  TDFConditionFilter
//
//  Created by taihangju on 2017/2/16.
//  Copyright © 2017年 2dfire. All rights reserved.
//

#import "TDFFilterMoel.h"

@interface TDFFilterMoel () {
    BOOL resetHideStatus;
}

@end

@implementation TDFFilterMoel

- (instancetype)initWithOptionName:(NSString *)optionName hideStatus:(BOOL)status {
    
    self = [super init];
    if (self) {
        self.optionName = optionName;
        self.currentHideStatus = status;
        resetHideStatus = status;
    }
    return self;
}

- (void)resetSelf {
    self.currentHideStatus = resetHideStatus;
}

@end


@implementation TDFFilterItem

+ (instancetype)filterItem:(NSString *)itemName itemValue:(id)value {
    
    TDFFilterItem *item = [[TDFFilterItem alloc] init];
    item.itemName = itemName;
    item.itemValue = value;
    return item;
}

+ (NSInteger)indexInArray:(NSArray<TDFFilterItem *> *)array withItemName:(NSString *)itemName {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemName=%@",itemName];
    NSArray *fits = [array filteredArrayUsingPredicate:predicate];
    if (fits.count == 1) {
        return [array indexOfObject:fits.firstObject];
    }
    return 0;
}


@end

@implementation TDFInterValCellModel

- (instancetype)initWithOptionName:(NSString *)optionName hideStatus:(BOOL)status {
    self = [super initWithOptionName:optionName hideStatus:status];
    if (self) {
        self.currentAction = TDF_Action_None;
        self.type = TDF_IntervalFilterCell;
    }
    return self;
}

- (void)resetSelf {
    [super resetSelf];
    self.lowRange = nil;
    self.highRange = nil;
    self.currentAction = TDF_Action_None;
}

- (NSString *)noticeTitle {
    
    if (_currentAction == TDF_Action_EditLowRange) {
        return _lowPlaceholder;
    } else if (_currentAction == TDF_Action_EditHighRange) {
        return _highPlaceholder;
    }
    return self.optionName;
}

- (NSString *)currentNumberString {
    if (_currentAction == TDF_Action_EditLowRange) {
        return _lowRange;
    } else if (_currentAction == TDF_Action_EditHighRange) {
        return _highRange;
    }
    return @"";
}


- (void)setHighRange:(NSString *)highRange {
    
    if (highRange.length > 0 && _lowRange.length > 0 && highRange.integerValue < _lowRange.integerValue) {
        _highRange = _lowRange;
        _lowRange = highRange;
    } else {
        _highRange = highRange;
    }
}

- (void)setLowRange:(NSString *)lowRange {
    
    if (lowRange.length > 0 && _highRange.length > 0 && _highRange.integerValue < lowRange.integerValue) {
        _lowRange = _highRange;
        _highRange = lowRange;
    } else {
        _lowRange = lowRange;
    }
}


@end

@implementation TDFRegularCellModel

- (instancetype)initWithOptionName:(NSString *)optionName hideStatus:(BOOL)status {
    self = [super initWithOptionName:optionName hideStatus:status];
    if (self) {
        self.type = TDF_RegularFilterCell;
        self.updateOption = NO;
    }
    return self;
}



- (void)resetSelf {
    [super resetSelf];
    self.selectItemIndex = self.resetItemIndex;
}

- (void)setResetItemIndex:(NSInteger)resetItemIndex {
    _resetItemIndex = resetItemIndex;
    _selectItemIndex = resetItemIndex;
}

- (TDFFilterItem *)currentValue {

    return _optionItems[_selectItemIndex].itemValue;
}

@end

@implementation TDFTwiceCellModel

- (instancetype)initWithType:(TDFFilterCellType)type optionName:(NSString *)optionName hideStatus:(BOOL)status {
    self = [super initWithOptionName:optionName hideStatus:status];
    if (self) {
        self.type = type;
    }
    return self;
}

- (NSString *)currentName {
    if (!_currentName) {
        return _restName;
    }
    return _currentName;
}

- (id)currentValue {
    if (!_currentValue) {
        return _restValue;
    }
    return _currentValue;
}

- (void)resetSelf {
    [super resetSelf];
    self.currentName = nil;
    self.currentValue = nil;
}

@end
