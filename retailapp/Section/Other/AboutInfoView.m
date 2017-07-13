//
//  AboutInfoView.m
//  retailapp
//
//  Created by hm on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AboutInfoView.h"
#import "DateUtils.h"
#import "XHAnimalUtil.h"

@interface AboutInfoView ()

@property (nonatomic, weak) IBOutlet UILabel *lblVersion;
@property (nonatomic, weak) IBOutlet UILabel *lblDate;
@end

@implementation AboutInfoView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self loadData];
}

- (void)initNavigate
{
    [self configTitle:@"关于" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)loadData
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    self.lblVersion.text = currentVersion;
    self.lblDate.text = @"©2015迪火";
}


@end
