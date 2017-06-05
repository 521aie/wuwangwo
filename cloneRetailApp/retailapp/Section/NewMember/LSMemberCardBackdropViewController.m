//
//  LSMemberCardBackdropViewController.m
//  retailapp
//
//  Created by byAlex on 16/9/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberCardBackdropViewController.h"
#import "LSImagePickerController.h"
#import "NavigateTitle2.h"
#import "LSMemberCardCell.h"
#import "HttpEngine+Member.h"
#import "LSCardBackgroundImageVo.h"
#import "LSAlertHelper.h"

@interface LSMemberCardBackdropViewController ()<INavigateEvent ,LSImagePickerDelegate ,UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout ,UIActionSheetDelegate>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) UICollectionView *collectionView;/*<>*/
@property (nonatomic ,strong) LSImagePickerController *imagePicker;/* <<#desc#>*/
@property (nonatomic ,strong) NSString *imagePath;/* <为选择的图片生成的标识String*/
@property (nonatomic ,strong) UIImage *image;/* <选中的image*/
@property (nonatomic ,strong) NSArray *cardBackgroundVos;/*<卡背景图列表>*/


@property (nonatomic ,strong) NSDictionary *cardInfoDic;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *fontColorString;/*<字体颜色string>*/
@end

@implementation LSMemberCardBackdropViewController

- (instancetype)init:(NSDictionary *)cardInfoDic {
    
    self = [super init];
    if (self) {
        self.cardInfoDic = cardInfoDic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self getCardBackGroundList];
    [self initNavigate];
    [self initCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - NavigateTitle2 代理
//初始化导航栏
- (void)initNavigate {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"卡片背景" backImg:Head_ICON_BACK moreImg:nil];
    self.titleBox.btnUser.hidden = NO;
    self.titleBox.imgMore.hidden = NO;
    self.titleBox.imgMore.image = [UIImage imageNamed:@"ico_usr_define"];
    [self.view addSubview:self.titleBox];
    
    NSMutableArray *removeLayouts = [[NSMutableArray alloc] init];
    [removeLayouts addObjectsFromArray:self.titleBox.imgMore.constraints];
    [removeLayouts addObjectsFromArray:self.titleBox.lblRight.constraints];
    
    for (NSLayoutConstraint *layout in self.titleBox.constraints) {
        if ([layout.secondItem isEqual:self.titleBox.imgMore]) {
            [removeLayouts addObject:layout];
        }
    }
    [NSLayoutConstraint deactivateConstraints:removeLayouts];
    UIImageView *_imgMore = self.titleBox.imgMore;
    NSDictionary *views = NSDictionaryOfVariableBindings(_imgMore);
    NSArray *xLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imgMore(65)]-10-|" options:0 metrics:nil views:views];
    NSArray *yLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imgMore(18)]-16-|" options:0 metrics:nil views:views];
    [self.titleBox addConstraints:xLayoutArray];
    [self.titleBox addConstraints:yLayoutArray];

}

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
    else {
        [LSAlertHelper showSheet:@"请选择图片来源" cancle:@"返回" cancleBlock:nil selectItems:@[@"图库" ,@"拍照"] selectdblock:^(NSInteger index) {
            
            [self showImagePickerController:index];
        }];
    }
}

#pragma mark - UICollectionView

- (void)initCollectionView {
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(SCREEN_W - 20, 183); // 款高比 3：2
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 5, 5, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64.0, SCREEN_W, SCREEN_H - 64.0) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[LSMemberCardCell class] forCellWithReuseIdentifier:@"LSMemberCardCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

#pragma mark UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.cardBackgroundVos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LSMemberCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LSMemberCardCell" forIndexPath:indexPath];
    
    LSCardBackgroundImageVo *vo = [self.cardBackgroundVos objectAtIndex:indexPath.row];
    [cell fillCardBackgroundImageVo:vo.filePath cardInfo:self.cardInfoDic];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LSCardBackgroundImageVo *vo = [self.cardBackgroundVos objectAtIndex:indexPath.row];
    if (self.selectImage) {
        self.selectImage(nil ,nil ,vo);
    }
}

#pragma mark - 
// LSImagePickerController, 选择处理照片
- (void)showImagePickerController:(UIImagePickerControllerSourceType)type {
    
    _imagePicker = [LSImagePickerController showImagePickerWith:type presenter:self];
    _imagePicker.cropSize = CGSizeMake(300, 140);
}

// LSImagePickerDelegate
- (void)imagePicker:(LSImagePickerController *)controller pickerImage:(UIImage *)image {
    
    self.image = image;
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSString *filePath = [NSString stringWithFormat:@"%@/kindcard/%@.png" ,entityId ,[NSString getUniqueStrByUUID]];
    self.imagePath = filePath;
    [self uploadBackgroundImage];
    
}

- (void)imagePickerDidCancel:(LSImageMessageType)message {
    
    if (message == LSImageMessageNoSupportCamera) {
        [LSAlertHelper showAlert:@"相机好像不能用哦!" block:nil];
    }else if (message == LSImageMessageNoSupportPhotoLibrary) {
        [LSAlertHelper showAlert:@"相册好像不能访问哦!" block:nil];
    }
    _imagePicker = nil;
}


#pragma mark - 网络请求
// 获取卡片背景列表
- (void)getCardBackGroundList {
    
    [BaseService getRemoteLSOutDataWithUrl:@"kindCard/queryCardSysCovers" param:nil withMessage:@"" show:YES CompletionHandler:^(id json) {
        self.cardBackgroundVos = [LSCardBackgroundImageVo getObjectsFrom:json[@"data"]];
        if (self.cardBackgroundVos.count) {
            [self.collectionView reloadData];
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
    
//    AFHTTPRequestOperation *op = [BaseService getRemoteLSOutOperationWithparams:nil withUrlStr:@"kindCard/queryCardSysCovers" completionHandler:^(id json) {
//        
//        self.cardBackgroundVos = [LSCardBackgroundImageVo getObjectsFrom:json[@"data"]];
//        if (self.cardBackgroundVos.count) {
//            [self.collectionView reloadData];
//        }
//        
//    } errorHandler:^(id json) {
//        
//        [LSAlertHelper showAlert:json block:nil];
//    }];
//    [BaseService startOperationQueue:@[op] withMessage:@"" show:YES];
}


// 上传背景图片
- (void)uploadBackgroundImage {
    
    NSString *urlString = [[Platform Instance] getkey:@"imageUploadPath"];
    NSDictionary *dic = @{@"data": UIImageJPEGRepresentation(self.image, 0.5)};
    NSArray *images = @[dic];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.imagePath forKey:@"path"];
    
    [HttpEngine mb_upLoadImage:urlString param:param imageData:images CompletionHandler:^(id json) {
        
        if (self.selectImage) {
            self.selectImage(self.image ,self.imagePath ,nil);
        }
        
    } errorHandler:^(id json) {
        
        [LSAlertHelper showAlert:json block:nil];
    }];

}

@end
