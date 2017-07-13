//
//  EditImageBox.m
//  RestApp
//
//  Created by YouQ-MAC on 15/1/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "IImageData.h"
#import "EditImageBox.h"
#import "UIView+Sizes.h"
#import "SelectImgItem.h"
#import "NSString+Estimate.h"

@implementation EditImageBox

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditImageBox" owner:self options:nil];
    self.view.ls_width = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.frame = self.view.frame;
    [self addSubview:self.view];
    [self setAutoresizesSubviews:NO];
    
    SelectImgItem *selectImgItem1 = [SelectImgItem selectImgItem];
    SelectImgItem *selectImgItem2 = [SelectImgItem selectImgItem];
    SelectImgItem *selectImgItem3 = [SelectImgItem selectImgItem];
    SelectImgItem *selectImgItem4 = [SelectImgItem selectImgItem];
    SelectImgItem *selectImgItem5 = [SelectImgItem selectImgItem];
    
    [self.view addSubview:selectImgItem1];
    [self.view addSubview:selectImgItem2];
    [self.view addSubview:selectImgItem3];
    [self.view addSubview:selectImgItem4];
    [self.view addSubview:selectImgItem5];
    
    selectImgItemList = [[NSArray alloc]initWithObjects:selectImgItem1, selectImgItem2, selectImgItem3,
    selectImgItem4, selectImgItem5, nil];
    
    fileImageMap = [[NSMutableDictionary alloc]initWithCapacity:5];
    filePathMap = [[NSMutableDictionary alloc]initWithCapacity:5];
    filePathList = [[NSMutableArray alloc]initWithCapacity:5];
}

+ (instancetype)editItemBox {
    EditImageBox *view = [[EditImageBox alloc] init];
    [view awakeFromNib];
    return view;
    
}

- (void)initLabel:(NSString *)label delegate:(id<IEditItemImageEvent>)delegate
{
    self.delegate = delegate;
    self.lblTitle.text = label;
    for (SelectImgItem *selectImgItem in selectImgItemList) {
        [selectImgItem initDelegate:delegate];
    }
}

- (float)getHeight
{
    if (filePathList != nil) {
        if (filePathList.count >= 5) {
            return 210*4+274;
        }else{
            return 210*filePathList.count+274;
        }
    }
    
    return 274;
}


//照片
- (void)initImgList:(NSArray *)menuDetails {
    
    self.Change = NO;
    [self buildImageData:menuDetails];
    [self resetSelectImgItem];
    [self renderSelectImgItem];
    [self renderAddImageItem];
    [self changeStatus];
}

- (void)buildImageData:(NSArray *)imageList {
    
    [filePathMap removeAllObjects];
    [filePathList removeAllObjects];
    [fileImageMap removeAllObjects];
    if (imageList != nil && imageList.count > 0) {
        for (id<IImageData> imageData in imageList) {
            [filePathMap setValue:imageData forKey:[imageData obtainPath]];
            [filePathList addObject:[imageData obtainPath]];
        }
    }
}

- (void)renderSelectImgItem {
    
    for (SelectImgItem *selectImgItem in selectImgItemList) {
        selectImgItem.oldPath = nil;
    }
    
    if (filePathList != nil && filePathList.count > 0) {
        NSUInteger limit = (filePathList.count>5?5:filePathList.count);
        for (NSUInteger i = 0; i < limit; ++i) {
            SelectImgItem *selectImgItem = [selectImgItemList objectAtIndex:i];
            NSString *path = [filePathList objectAtIndex:i];
            if ([filePathMap objectForKey:path]!=nil) {
                id<IImageData> imageData = [filePathMap objectForKey:path];
                
                selectImgItem.oldPath = path;
                [selectImgItem initView:[imageData obtainFilePath] path:path];
            } else if ([fileImageMap objectForKey:path]!=nil) {
                UIImage *image = [fileImageMap objectForKey:path];
                [selectImgItem initWithImage:image path:path];
            }
            
            selectImgItem.hidden = NO;
            selectImgItem.ls_left = 10;
            selectImgItem.ls_top = 210*i+44;
            
            self.view.ls_height = selectImgItem.ls_top + 210+44;
            self.ls_height = selectImgItem.ls_top+210+44;
        }
    }
//    [self.delegate updateViewSize];
}

- (void)renderAddImageItem {
    
    NSUInteger index = filePathList.count;
    if (index < 5) {
        SelectImgItem *selectImgItem = [selectImgItemList objectAtIndex:index];
        currentSelectImgItem = selectImgItem;
        selectImgItem.hidden = NO;
        [selectImgItem initView:nil path:nil];
        selectImgItem.ls_top = 210*index+44;
        selectImgItem.ls_left = 10;
        self.view.ls_height = 210*(index+1)+44;
        self.ls_height = 210*(index+1)+44;
    } else {
        self.view.ls_height = 210*5+44;
        self.ls_height = 210*5+44;
    }
}

- (void)changeImg:(NSString *)filePath img:(UIImage*)img {
    
    self.Change=YES;
    [currentSelectImgItem initWithImage:img path:filePath];
    [filePathList addObject:filePath];
    [fileImageMap setValue:img forKey:filePath];
    [self renderAddImageItem];
    [self changeStatus];
}

- (void)resetSelectImgItem {
    
    for (SelectImgItem *selectImgItem in selectImgItemList) {
        selectImgItem.hidden = YES;
        selectImgItem.ls_top = 0;
    }
}

#pragma change status
- (void)changeStatus {
    
    BOOL flag=[self isChange];
    self.lblTip.layer.backgroundColor=[UIColor redColor].CGColor;
    self.lblTip.textColor=[UIColor whiteColor];
    self.lblTip.text=@"未保存";
    self.lblTip.layer.cornerRadius = 2;
    [self.lblTip setLs_width:32];
    [self.lblTip setLs_height:12];
    [self.lblTip setHidden:!flag];
    self.baseChangeStatus=flag;
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationType object:self] ;
}

- (BOOL)isChange {

    return self.Change;
}

- (NSMutableArray *)getFilePathList {
    
    return filePathList;
}

- (NSMutableDictionary *)getFileImageMap{
    return fileImageMap;
}
- (NSMutableDictionary *)getfilePathMap{
    return filePathMap;
}

- (NSMutableDictionary *)fileImageMap
{
    return fileImageMap;
}
- (NSArray *)getImageItemList {
    return selectImgItemList;
}
- (void)removeFilePath:(NSString *)path
{
    if (filePathList != nil && [filePathList containsObject:path]) {
        [filePathList removeObject:path];
        [filePathMap removeObjectForKey:path];
        [fileImageMap removeObjectForKey:path];
        self.Change = YES;
        [self resetSelectImgItem];
        [self renderSelectImgItem];
        [self renderAddImageItem];
        [self changeStatus];
        [self.delegate updateViewSize];
    }
}

// 编辑设置
- (void)imageBoxUneditable {
    
    for (SelectImgItem *item in selectImgItemList) {
        item.btnDel.hidden = YES;
        item.btnDown.hidden = YES;
        item.btnUp.hidden = YES;
        item.imgDel.hidden = YES;
    }
    self.userInteractionEnabled = NO;
}


@end
