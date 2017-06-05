//
//  LSPictureAdvertisingView.m
//  retailapp
//
//  Created by guozhi on 2016/11/15.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSPictureAdvertisingView.h"
#import "IImageData.h"
#import "LSPictureAdvertisingVo.h"
@implementation LSPictureAdvertisingView

+ (instancetype)pictureAdvertisingView:(int)maxNum {
    LSPictureAdvertisingView *view = [[LSPictureAdvertisingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_H, 100)];
    view.maxNum = maxNum;
    [view configViews];
    return view;
}

- (void)configViews {
    self.filePathMap = [NSMutableDictionary dictionary];
    self.fileImageMap = [NSMutableDictionary dictionary];
    self.filePathList = [NSMutableArray array];
    self.selectImgItemList = [NSMutableArray array];
    for (int i = 0; i < self.maxNum; i++) {
        SelectImgItem3 *selectImgItem = [[[NSBundle mainBundle] loadNibNamed:@"SelectImgItem3" owner:self options:nil] lastObject];
        selectImgItem.ls_width = SCREEN_W - 20;
        [self addSubview:selectImgItem];
        [self.selectImgItemList addObject:selectImgItem];
    }
}
- (void)initDelegate:(id<IEditItemImageEvent>)delegate {
    self.delegate = delegate;
    for (SelectImgItem3 *selectImgItem in self.selectImgItemList) {
        [selectImgItem initDelegate:delegate];
    }
}
//照片
- (void)initImgList:(NSArray *)menuDetails;{
    self.isChange = NO;
    [self buildImageData:menuDetails];
    [self resetSelectImgItem];
    [self renderSelectImgItem];
    [self renderAddImageItem];
}
- (void)buildImageData:(NSArray *)imageList
{
    [self.filePathMap removeAllObjects];
    [self.filePathList removeAllObjects];
    [self.fileImageMap removeAllObjects];
    if (imageList != nil && imageList.count>0) {
        for (id<IImageData> imageData in imageList) {
            [self.filePathMap setValue:imageData forKey:[imageData obtainPath]];
            if (self.filePathList.count < self.maxNum) {
                [self.filePathList addObject:[imageData obtainPath]];
            }
        }
    }
}

- (void)resetSelectImgItem {
    for (SelectImgItem3 *selectImgItem in self.selectImgItemList) {
        selectImgItem.hidden = YES;
        selectImgItem.ls_top = 0;
    }
}

- (void)renderSelectImgItem
{
    for (SelectImgItem3 *selectImgItem in self.selectImgItemList) {
        selectImgItem.oldPath = nil;
    }
    if (self.filePathList.count>0) {
        ;
        NSUInteger limit = self.filePathList.count>self.maxNum?self.maxNum:self.filePathList.count;
        for (NSUInteger i = 0;i < limit; i++) {
            SelectImgItem3 *selectImgItem = [self.selectImgItemList objectAtIndex:i];
            NSString *path = [self.filePathList objectAtIndex:i];
            LSPictureAdvertisingVo *vo = self.filePathMap[path];
            if (vo.isShowFailImage) {//上传图片失败
                selectImgItem.lblFailed.hidden = NO;
                selectImgItem.imgView.hidden = NO;
                selectImgItem.viewUploading.hidden = YES;
                selectImgItem.path = vo.path;
            } else if ([self.fileImageMap objectForKey:path]!=nil) {
                selectImgItem.lblFailed.hidden = YES;
                selectImgItem.imgView.hidden = NO;
                UIImage *image = [self.fileImageMap objectForKey:path];
                [selectImgItem initWithImage:image path:path];
            } else if ([self.filePathMap objectForKey:path]!=nil) {
                selectImgItem.lblFailed.hidden = YES;
                selectImgItem.imgView.hidden = NO;
                id<IImageData> imageData = [self.filePathMap objectForKey:path];
                selectImgItem.oldPath = path;
                [selectImgItem initView:[imageData obtainFilePath] path:path];
            }
            selectImgItem.hidden = NO;
            selectImgItem.ls_left = 10;
            selectImgItem.ls_top = 210*i;
        }
    }
}

- (void)renderAddImageItem
{
    NSUInteger index = self.filePathList.count;
    if (index<self.maxNum) {
        SelectImgItem3 *selectImgItem = [self.selectImgItemList objectAtIndex:index];
        self.currentSelectImgItem = selectImgItem;
        selectImgItem.hidden = NO;
        selectImgItem.btnUp.hidden=YES;
        selectImgItem.btnDown.hidden=YES;
        [selectImgItem initView:nil path:nil];
        selectImgItem.ls_top = 210*index;
        selectImgItem.ls_left = 10;
        self.ls_height = 210*(index + 1);
    } else {
        self.ls_height = 210*self.maxNum;
        self.ls_height = 210*self.maxNum;
    }
    __weak typeof(self) wself = self;
    [self.filePathList enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger idx, BOOL * _Nonnull stop) {
        SelectImgItem3 *selectImgItem = self.selectImgItemList[idx];
        if (selectImgItem == self.selectImgItemList[0]) {
            selectImgItem.btnUp.hidden=YES;
        }else{
            selectImgItem.btnUp.hidden=NO;
        }
        if (selectImgItem == wself.selectImgItemList[self.filePathList.count-1]) {
            selectImgItem.btnDown.hidden=YES;
        }else{
            selectImgItem.btnDown.hidden=NO;
        }
    }];

}

- (void)changeImg:(NSString *)filePath img:(UIImage*)img {
    self.isChange = YES;
    [self.currentSelectImgItem initWithImage:img path:filePath];
    [self.filePathList addObject:filePath];
    [self.fileImageMap setValue:img forKey:filePath];
    LSPictureAdvertisingVo *vo = [[LSPictureAdvertisingVo alloc] init];
    vo.isChange = YES;
    vo.path = filePath;
    [self.filePathMap setValue:vo forKey:filePath];
    [self renderAddImageItem];
}

-(void)upFilePath:(NSString *)path{
    for (int i = 0; i<self.filePathList.count; i++) {
        if ([self.filePathList[i] isEqualToString:path]) {
            self.num = i;
            break;
        }
    }
    SelectImgItem3 *selectImgItem=[self selectImgItemList][self.num];
    CGRect frame=selectImgItem.frame;
    SelectImgItem3 *selectImgItem1=[self selectImgItemList][self.num-1];
    CGRect frame1=selectImgItem1.frame;
    [self.filePathList exchangeObjectAtIndex:self.num withObjectAtIndex:self.num-1];
    [self.selectImgItemList exchangeObjectAtIndex:self.num withObjectAtIndex:self.num-1];
    if (self.num==1) {
        selectImgItem.btnUp.hidden=YES;
        selectImgItem.btnDown.hidden=NO;
    }else{
        selectImgItem.btnUp.hidden=NO;
        selectImgItem.btnDown.hidden=NO;
    }
    if (self.num==self.filePathList.count-1) {
        selectImgItem1.btnUp.hidden=NO;
        selectImgItem1.btnDown.hidden=YES;
    }else{
        selectImgItem1.btnUp.hidden=NO;
        selectImgItem1.btnDown.hidden=NO;
    }
    [UIView animateWithDuration:1.0 animations:^{
        [selectImgItem setFrame:frame1];
        [selectImgItem1 setFrame:frame];
    }];
    self.isChange = YES;
}

-(void)downFilePath:(NSString *)path{
    
    for (int i=0; i<self.filePathList.count; i++) {
        if ([self.filePathList[i] isEqualToString:path]) {
            self.num=i;
            break;
        }
    }
    SelectImgItem3 *selectImgItem=[self selectImgItemList][self.num];
    CGRect frame = selectImgItem.frame;
    SelectImgItem3 *selectImgItem1=[self selectImgItemList][self.num+1];
    CGRect frame1 = selectImgItem1.frame;
    [self.filePathList exchangeObjectAtIndex:self.num withObjectAtIndex:self.num+1];
    [self.selectImgItemList exchangeObjectAtIndex:self.num withObjectAtIndex:self.num+1];
    if (self.num==0) {
        selectImgItem1.btnUp.hidden=YES;
        selectImgItem1.btnDown.hidden=NO;
    }else{
        selectImgItem1.btnUp.hidden=NO;
        selectImgItem1.btnDown.hidden=NO;
    }
    if (self.num==self.filePathList.count-2) {
        selectImgItem.btnUp.hidden=NO;
        selectImgItem.btnDown.hidden=YES;
    }else{
        selectImgItem.btnUp.hidden=NO;
        selectImgItem.btnDown.hidden=NO;
    }
    [UIView animateWithDuration:1.0 animations:^{
        [selectImgItem setFrame:frame1];
        [selectImgItem1 setFrame:frame];
    }];
    self.isChange = YES;
    
}

- (void)removeFilePath:(NSString *)path
{
    if (self.filePathList != nil && [self.filePathList containsObject:path]) {
        [self.filePathList removeObject:path];
        [self.filePathMap removeObjectForKey:path];
        [self.fileImageMap removeObjectForKey:path];
        [self resetSelectImgItem];
        [self renderSelectImgItem];
        [self renderAddImageItem];
    }
}
-(void)setIsChange:(BOOL)isChange {
    _isChange = isChange;
}


@end
