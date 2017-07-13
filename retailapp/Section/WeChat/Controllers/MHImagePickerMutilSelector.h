//
//  MHMutilImagePickerViewController.h
//  doujiazi
//
//  Created by Shine.Yuan on 12-8-7.
//  Copyright (c) 2012年 mooho.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHImagePickerMutilSelectorDelegate <NSObject>

@optional
-(void)imagePickerMutilSelectorDidGetImages:(NSArray*)imageArray;
@end

@interface MHImagePickerMutilSelector : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIView* selectedPan;
    UILabel* textlabel;
    UIImagePickerController*    imagePicker;
    NSMutableArray* pics;
    NSMutableArray* picsinfo;
    UITableView*    tbv;
    UIImage *goodsImage;
    id<MHImagePickerMutilSelectorDelegate>  delegate;
}

@property (nonatomic,retain)UIImagePickerController*    imagePicker;
@property(nonatomic,retain)id<MHImagePickerMutilSelectorDelegate>   delegate;
@property (nonatomic, strong) NSMutableArray*imageNumArr;
+(id)standardSelector;

@end
