//
//  TimePickerBox.h
//  RestApp
//
//  Created by zxh on 14-4-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "PopupBoxViewController.h"
//#import "AppController.h"
#import "PopupBoxViewController.h"

@interface ImageBox : PopupBoxViewController

@property (nonatomic, retain) IBOutlet UIImageView *imageView;

//+ (void)initImageBox:(AppController *)appController;

+ (void)show:(UIImage *)image;

+ (void)hide;

- (IBAction)cancelBtnClick:(id)sender;


@end
