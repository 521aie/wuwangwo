//
//  LSEditShopInfoBox.m
//  retailapp
//
//  Created by guozhi on 2017/4/14.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define kHeight 48 //第一行的高度
#import "LSEditShopInfoBox.h"
#import "SelectImgItem.h"
#import "IImageData.h"
@interface LSEditShopInfoBox(){
    NSArray *selectImgItemList;
    
    SelectImgItem *currentSelectImgItem;
    
    NSMutableArray *filePathList;
    
    NSMutableDictionary *filePathMap;
    
    NSMutableDictionary *fileImageMap;
}

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblVal;
@property (nonatomic, weak) id<IEditItemImageEvent> delegate;
@property (nonatomic) BOOL Change;

@end

@implementation LSEditShopInfoBox
+ (instancetype)editShopInfpBox {
    LSEditShopInfoBox *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
    view.backgroundColor = [UIColor clearColor];
    view.ls_width = SCREEN_W;
    [view configViews];
    return view;
}

- (void)configViews {
    SelectImgItem *selectImgItem1 = [SelectImgItem selectImgItem];
    SelectImgItem *selectImgItem2 = [SelectImgItem selectImgItem];
    SelectImgItem *selectImgItem3 = [SelectImgItem selectImgItem];
    SelectImgItem *selectImgItem4 = [SelectImgItem selectImgItem];
    SelectImgItem *selectImgItem5 = [SelectImgItem selectImgItem];
    
    [self addSubview:selectImgItem1];
    [self addSubview:selectImgItem2];
    [self addSubview:selectImgItem3];
    [self addSubview:selectImgItem4];
    [self addSubview:selectImgItem5];
    selectImgItemList = @[selectImgItem1, selectImgItem2, selectImgItem3, selectImgItem4, selectImgItem5];
    
    fileImageMap = [NSMutableDictionary dictionary];
    filePathMap = [NSMutableDictionary dictionary];
    filePathList = [NSMutableArray array];

}

- (void)initLabel:(NSString *)label delegate:(id<IEditItemImageEvent>)delegate {
    self.delegate = delegate;
    self.lblName.text = label;
    for (SelectImgItem *selectImgItem in selectImgItemList) {
        [selectImgItem initDelegate:delegate];
    }
}

//照片
- (void)initImgList:(NSArray *)menuDetails {
    
    self.Change = NO;
    [self buildImageData:menuDetails];
    [self resetSelectImgItem];
    [self renderSelectImgItem];
    [self renderAddImageItem];
    [self changeStatus];
    [self configPlaceHolderShow];
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
            selectImgItem.ls_top = 210 * i + kHeight;
            
            self.ls_height = selectImgItem.ls_top + 210 + kHeight;
        }
    }
}

- (void)renderAddImageItem {
    
    NSUInteger index = filePathList.count;
    if (index < 5) {
        SelectImgItem *selectImgItem = [selectImgItemList objectAtIndex:index];
        currentSelectImgItem = selectImgItem;
        selectImgItem.hidden = NO;
        [selectImgItem initView:nil path:nil];
        selectImgItem.ls_top = 210 * index + kHeight;
        selectImgItem.ls_left = 10;
        self.ls_height = 210 * (index + 1) + kHeight;
    } else {
        self.ls_height = 210 * 5 + kHeight;
    }
}

- (void)changeImg:(NSString *)filePath img:(UIImage*)img {
    
    self.Change=YES;
    [currentSelectImgItem initWithImage:img path:filePath];
    [filePathList addObject:filePath];
    [fileImageMap setValue:img forKey:filePath];
    [self renderAddImageItem];
    [self changeStatus];
    [self configPlaceHolderShow];
}

- (void)resetSelectImgItem {
    
    for (SelectImgItem *selectImgItem in selectImgItemList) {
        selectImgItem.hidden = YES;
        selectImgItem.ls_top = 0;
    }
}

//右侧提示文字是否显示
- (void)configPlaceHolderShow {
    self.lblVal.hidden = filePathList.count > 0;
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
     [self configPlaceHolderShow];
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
