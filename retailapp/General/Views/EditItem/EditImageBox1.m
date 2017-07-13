//
//  EditImageBox.m
//  RestApp
//
//  Created by YouQ-MAC on 15/1/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "IImageData.h"
#import "EditImageBox1.h"
#import "UIView+Sizes.h"
#import "SelectImgItem.h"
#import "NSString+Estimate.h"

@implementation EditImageBox1

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditImageBox" owner:self options:nil];
    [self addSubview:self.view];
    [self setAutoresizesSubviews:NO];

    
    SelectImgItem *selectImgItem1 = [[[NSBundle mainBundle] loadNibNamed:@"SelectImgItem" owner:self options:nil] lastObject];
    SelectImgItem *selectImgItem2 = [[[NSBundle mainBundle] loadNibNamed:@"SelectImgItem" owner:self options:nil] lastObject];
    SelectImgItem *selectImgItem3 = [[[NSBundle mainBundle] loadNibNamed:@"SelectImgItem" owner:self options:nil] lastObject];
    SelectImgItem *selectImgItem4 = [[[NSBundle mainBundle] loadNibNamed:@"SelectImgItem" owner:self options:nil] lastObject];
    SelectImgItem *selectImgItem5 = [[[NSBundle mainBundle] loadNibNamed:@"SelectImgItem" owner:self options:nil] lastObject];
    SelectImgItem *selectImgItem6 = [[[NSBundle mainBundle] loadNibNamed:@"SelectImgItem" owner:self options:nil] lastObject];
    SelectImgItem *selectImgItem7 = [[[NSBundle mainBundle] loadNibNamed:@"SelectImgItem" owner:self options:nil] lastObject];
    SelectImgItem *selectImgItem8 = [[[NSBundle mainBundle] loadNibNamed:@"SelectImgItem" owner:self options:nil] lastObject];
    SelectImgItem *selectImgItem9 = [[[NSBundle mainBundle] loadNibNamed:@"SelectImgItem" owner:self options:nil] lastObject];
    SelectImgItem *selectImgItem10 = [[[NSBundle mainBundle] loadNibNamed:@"SelectImgItem" owner:self options:nil] lastObject];
    SelectImgItem *selectImgItem11 = [[[NSBundle mainBundle] loadNibNamed:@"SelectImgItem" owner:self options:nil] lastObject];
    SelectImgItem *selectImgItem12 = [[[NSBundle mainBundle] loadNibNamed:@"SelectImgItem" owner:self options:nil] lastObject];
    [self.view addSubview:selectImgItem1];
    [self.view addSubview:selectImgItem2];
    [self.view addSubview:selectImgItem3];
    [self.view addSubview:selectImgItem4];
    [self.view addSubview:selectImgItem5];
    [self.view addSubview:selectImgItem6];
    [self.view addSubview:selectImgItem7];
    [self.view addSubview:selectImgItem8];
    [self.view addSubview:selectImgItem9];
    [self.view addSubview:selectImgItem10];
    [self.view addSubview:selectImgItem11];
    [self.view addSubview:selectImgItem12];
    
    selectImgItemList = [[NSMutableArray alloc]initWithObjects:selectImgItem1, selectImgItem2, selectImgItem3,
                         selectImgItem4, selectImgItem5,selectImgItem6, selectImgItem7, selectImgItem8,
                         selectImgItem9, selectImgItem10, selectImgItem11, selectImgItem12,nil];
    
    fileImageMap = [[NSMutableDictionary alloc]initWithCapacity:12];
    filePathMap = [[NSMutableDictionary alloc]initWithCapacity:12];
    filePathList = [[NSMutableArray alloc]initWithCapacity:12];
}

- (void)initLabel:(NSString *)label delegate:(id<IEditItemImageEvent>)delegate
{
    self.delegate = delegate;
    self.lblTitle.text = label;
    for (SelectImgItem *selectImgItem in selectImgItemList) {
        [selectImgItem initDelegate:delegate];
        selectImgItem.btnItem.hidden = YES;
    }
}

- (float)getHeight
{
    if (filePathList != nil) {
        if (filePathList.count >= 12) {
            return 210*4+274;
        }else{
            return 210*filePathList.count+274;
        }
    }
    
    return 274;
}

//照片
- (void)initImgList:(NSArray *)menuDetails;
{
    self.Change=NO;
    [self buildImageData:menuDetails];
    [self resetSelectImgItem];
    [self renderSelectImgItem];
    [self renderAddImageItem];
    [self changeStatus];
}

- (void)buildImageData:(NSArray *)imageList
{
    [filePathMap removeAllObjects];
    [filePathList removeAllObjects];
    [fileImageMap removeAllObjects];
    if (imageList != nil && imageList.count>0) {
        for (id<IImageData> imageData in imageList) {
            [filePathMap setValue:imageData forKey:[imageData obtainPath]];
            [filePathList addObject:[imageData obtainPath]];
        }
    }
}

- (void)renderSelectImgItem
{
    for (SelectImgItem *selectImgItem in selectImgItemList) {
        selectImgItem.oldPath = nil;
    }
    if (filePathList != nil && filePathList.count>0) {
        NSUInteger limit = (filePathList.count>12?12:filePathList.count);
        for (NSUInteger i=0;i<limit;++i) {
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
        }
    }
}

- (void)renderAddImageItem
{
    NSUInteger index = filePathList.count;
    if (index<12) {
        SelectImgItem *selectImgItem = [selectImgItemList objectAtIndex:index];
        currentSelectImgItem = selectImgItem;
        selectImgItem.hidden = NO;
        [selectImgItem initView:nil path:nil];
        selectImgItem.ls_top = 210*index+44;
        selectImgItem.ls_left = 10;
        self.view.ls_height = 210*(index)+44;
        self.ls_height = 210*(index)+44;
    } else {
        self.view.ls_height = 210*12+44;
        self.ls_height = 210*12+44;
    }
}

- (void)changeImg:(NSString *)filePath img:(UIImage *)img {
    
    if (img && filePath) {
        self.hidden = NO;
    }
    self.Change = YES;
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
- (void)changeStatus
{
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

- (BOOL)isChange
{
    return self.Change;
}

- (NSMutableArray *)getFilePathList
{
    return filePathList;
}

- (NSMutableArray *)selectImgItemList
{
    return selectImgItemList;
}

- (NSMutableDictionary *)fileImageMap
{
    return fileImageMap;
}
- (NSArray *)getImageItemList {
    return selectImgItemList;
}
-(void)upFilePath:(NSString *)path{
    for (int i=0; i<filePathList.count; i++) {
        if ([filePathList[i] isEqualToString:path]) {
            num=i;
            break;
        }
    }
    SelectImgItem *selectImgItem=[self selectImgItemList][num];
    CGRect frame=selectImgItem.frame;
    SelectImgItem *selectImgItem1=[self selectImgItemList][num-1];
    CGRect frame1=selectImgItem1.frame;
    [filePathList exchangeObjectAtIndex:num withObjectAtIndex:num-1];
    [selectImgItemList exchangeObjectAtIndex:num withObjectAtIndex:num-1];
    if (num==1) {
        selectImgItem.btnUp.hidden=YES;
        selectImgItem.btnDown.hidden=NO;
    }else{
        selectImgItem.btnUp.hidden=NO;
        selectImgItem.btnDown.hidden=NO;
    }
    if (num==[self getFilePathList].count-1) {
        selectImgItem1.btnUp.hidden=NO;
        selectImgItem1.btnDown.hidden=YES;
    }else{
        selectImgItem1.btnUp.hidden=NO;
        selectImgItem1.btnDown.hidden=NO;
    }
   
    self.Change = YES;
    [self changeStatus];

    
    [UIView animateWithDuration:1.0 animations:^{
        [selectImgItem setFrame:frame1];
        [selectImgItem1 setFrame:frame];
    }];
}

-(void)downFilePath:(NSString *)path{
    
    for (int i=0; i<filePathList.count; i++) {
        if ([filePathList[i] isEqualToString:path]) {
            num=i;
            break;
        }
    }
    SelectImgItem *selectImgItem=[self selectImgItemList][num];
    CGRect frame = selectImgItem.frame;
    SelectImgItem *selectImgItem1=[self selectImgItemList][num+1];
    CGRect frame1 = selectImgItem1.frame;
    [filePathList exchangeObjectAtIndex:num withObjectAtIndex:num+1];
    [selectImgItemList exchangeObjectAtIndex:num withObjectAtIndex:num+1];
    if (num==0) {
        selectImgItem1.btnUp.hidden=YES;
        selectImgItem1.btnDown.hidden=NO;
    }else{
        selectImgItem1.btnUp.hidden=NO;
        selectImgItem1.btnDown.hidden=NO;
    }
    if (num==[self getFilePathList].count-2) {
        selectImgItem.btnUp.hidden=NO;
        selectImgItem.btnDown.hidden=YES;
    }else{
        selectImgItem.btnUp.hidden=NO;
        selectImgItem.btnDown.hidden=NO;
    }
    self.Change = YES;
    [self changeStatus];
    [UIView animateWithDuration:1.0 animations:^{
        [selectImgItem setFrame:frame1];
        [selectImgItem1 setFrame:frame];
    }];
    
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
