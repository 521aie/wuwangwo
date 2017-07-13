//
//  WeChatHomeSetCarousel.m
//  retailapp
//
//  Created by diwangxie on 16/4/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "CarouselFigurePreview.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "MicroGoodsImageVo.h"
#import "SelectImgItem2.h"
#import "IEditItemImageEvent.h"
#import "CarouselFigureSet.h"
#import "MicroShopHomepageVo.h"
#import "NavigateTitle2.h"
#import "GoodsFooterListView.h"
#import <UIImageView+WebCache.h>
#import "Masonry/Masonry.h"

static NSString *carouseReuseCell = @"cell";
@interface CarouselFigurePreview ()<IEditItemImageEvent,INavigateEvent,FooterListEvent,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger adjustCounter;
}
@property (nonatomic, strong) WechatService *wechatService;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSMutableArray *photoList;/*<轮播图列表*/
@property (nonatomic ,strong) NSArray *originList;/* <<#desc#>*/
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) GoodsFooterListView *footView;
@property (nonatomic, copy) void (^refreshBlock)();
/**
 *  指示所有的轮播图状态是否改变
 */
@property (nonatomic ,assign) BOOL statusChanged;
@end

@implementation CarouselFigurePreview

- (void)callBack:(void (^)())block {
    self.refreshBlock = block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    
    _wechatService = [ServiceFactory shareInstance].wechatService;
    [self getImageList];
    [self configHelpButton:HELP_WECHAT_HOME_SETTING];
}

- (void)configSubViews {
    
    self.view.backgroundColor = RGBA(255.f, 255.f, 255.f, 0.7);
    // navigation titleBox
    _titleBox = [NavigateTitle2 navigateTitle:self];
    [_titleBox initWithName:@"轮播图" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:_titleBox];
    
    // collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(20, 0, 80, 0);
    layout.minimumLineSpacing = 10.f;
    layout.itemSize = CGSizeMake(300, 180);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[CarouselCollectionCell class] forCellWithReuseIdentifier:carouseReuseCell];
    [self.view addSubview:_collectionView];
    
    // footView
    _footView = [GoodsFooterListView goodFooterListView];
    [_footView initDelegate:self btnArrs:@[@"add"]];
    [self.view addSubview:_footView];
    
    [_titleBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@(64));
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@(60));
    }];
}

#pragma mark - 导航栏 onNavigateEvent

- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        
        // 轮播图状态改变，主动为微店主页更新数据，如图片更改了
        if (self.statusChanged && self.refreshBlock) {
            self.refreshBlock();
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self saveSet];
    }
}


#pragma mark - FooterListEvent

- (void)showAddEvent {
    
    if(_photoList.count >= 5) {
        [AlertBox show:@"只能添加五个轮播图"];
        return;
    }
    
    CarouselFigureSet *vc = [[CarouselFigureSet alloc] initWithNibName:[SystemUtil getXibName:@"CarouselFigureSet"] bundle:nil];
    __weak typeof(self) weakSelf = self;
    [vc setHomepageId:nil callBack:^{
        
        weakSelf.statusChanged = YES;
        [weakSelf performSelector:@selector(getImageList)
                       withObject:nil afterDelay:0.5];
    }];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma mark - UICollectionView -

- (void)collectionViewReload {
    if (!_collectionView.delegate) {
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    [_collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CarouselCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:carouseReuseCell forIndexPath:indexPath];
    MicroShopHomepageVo *vo = [_photoList objectAtIndex:indexPath.row];
    [cell fill:vo.filePath isFirst:!indexPath.row isLast:indexPath.row==_photoList.count-1];
    typeof(self) weakSelf = self;
    cell.RankBlock = ^(CarouselCollectionCell *rCell ,OrientationType direction){
        
        // 计算将要调换顺序两个cell的indexPath
        NSIndexPath *index1 = [weakSelf.collectionView indexPathForCell:rCell];
        NSInteger item = index1.row + (direction ? -1 : 1);
        NSIndexPath *index2 = [NSIndexPath indexPathForItem:item inSection:0];
        
        // 隐藏向上或者向下的button
        NSInteger maxIndex = weakSelf.photoList.count - 1;
        CarouselCollectionCell *changeCell = (CarouselCollectionCell *)[weakSelf.collectionView cellForItemAtIndexPath:index2];
        [rCell hideUpButton:!index2.row downButton:index2.row==maxIndex];
        [changeCell hideUpButton:!index1.row downButton:index1.row==maxIndex];
        
        // 记录点击上调和下调的次数
        if (!adjustCounter) {
            [weakSelf.titleBox editTitle:YES act:2];
        }
        adjustCounter += 1;
        [weakSelf.collectionView performBatchUpdates:^{
            [weakSelf.collectionView moveItemAtIndexPath:index1 toIndexPath:index2];
        } completion:^(BOOL finished) {
            
            [weakSelf.photoList exchangeObjectAtIndex:index1.row
                                    withObjectAtIndex:index2.row];
            
            // 当操作数是偶数的时候才去判断是否改变了最初的顺序
            if (adjustCounter%2 == 0) {
                
                BOOL allIndexEqual = NO;
                for (int idx = 0; idx <= maxIndex; ++idx) {
                    
                    id obj1 = weakSelf.photoList[idx];
                    id obj2 = weakSelf.originList[idx];
                    if ([obj1 isEqual:obj2]) {
                        allIndexEqual = YES;
                    }else {
                        allIndexEqual = NO;
                        break;
                    }
                }
                
                if (allIndexEqual) {
                    [weakSelf.titleBox editTitle:NO act:2];
                    adjustCounter = 0;
                }
            }
        }];
    };
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 轮播图 -> 轮播图设置
    CarouselFigureSet *vc = [[CarouselFigureSet alloc] initWithNibName:[SystemUtil getXibName:@"CarouselFigureSet"] bundle:nil];
    MicroShopHomepageVo *vo = [_photoList objectAtIndex:indexPath.row];
    __weak typeof(self) weakSelf = self;
    [vc setHomepageId:vo.homePageId callBack:^{
        [weakSelf performSelector:@selector(getImageList)
                       withObject:nil afterDelay:0.5];
        weakSelf.statusChanged = YES;
    }];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}


#pragma mark - 网络请求
// 获取轮播图列表
- (void)getImageList {
    
    NSString *url = @"microShopHomepage/selectCarouselImageList";
   self.shopId = [[Platform Instance] getkey:SHOP_ID];
    
    NSDictionary *param = @{@"shopId":self.shopId,
                            @"interface_version":@2};
    //是否启用主题销售
    __weak typeof(self) weakSelf = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSArray *arr = [MicroShopHomepageVo  getMicroShopHomepageVos:json[@"microShopHomepageList"]];
        if (arr.count) {
            weakSelf.originList = arr;
            weakSelf.photoList = [NSMutableArray arrayWithArray:arr];
        }else {
            weakSelf.originList = nil;
            [weakSelf.photoList removeAllObjects];
        }
        [weakSelf collectionViewReload];

    } errorHandler:^(id json) {
         [AlertBox show:json];
    }];
}

// 保存更改
- (void)saveSet {

    self.shopId=[[Platform Instance] getkey:SHOP_ID];
    
    NSString *url = @"microShopHomepage/updateCarouselImageSort";
    
    NSMutableArray *tempList = [[NSMutableArray alloc] initWithCapacity:5];
    for (MicroShopHomepageVo *vo in _photoList) {
        [tempList addObject:[vo convertToDictionary]];
    }
    NSDictionary *param = @{@"shopId":self.shopId, @"microShopHomepageList":tempList};
    //是否启用主题销售
    __weak typeof(self) weakSelf = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if (weakSelf.refreshBlock) {
            weakSelf.refreshBlock();
        }
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

@interface CarouselCollectionCell()

@property (strong, nonatomic) UIButton *upButton;
@property (strong, nonatomic) UIButton *downButton;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation CarouselCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        CALayer *layer = [self.contentView layer];
        layer.borderWidth = 1;
        layer.borderColor = [UIColor whiteColor].CGColor;
        
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imageView];
        
        _upButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_upButton setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        [_upButton setImage:[UIImage imageNamed:@"ico_pic_up"] forState:0];
        [_upButton addTarget:self action:@selector(upAdjuster) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_upButton];
        
        _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downButton setImage:[UIImage imageNamed:@"ico_pic_down"] forState:0];
        [_downButton setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        [_downButton addTarget:self action:@selector(downAdjuster) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_downButton];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsZero);
        }];
        
        [_upButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        [_downButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(0);
            make.left.equalTo(self.contentView).offset(0);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
    }
    return self;
}

- (void)fill:(NSString *)imagePath isFirst:(BOOL)first isLast:(BOOL)last {
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageAllowInvalidSSLCertificates];
    UIImage *loadingIcon = [UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"icon_loading" ofType:@"jpg"]];
    //图片加载时，显示加载中提示图片，如果失败显示加载失败提示图片，成功则显示加载成功的图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:imagePath]] placeholderImage:loadingIcon completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (error && !image) {
            UIImage *loadFailIcon = [UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"icon_load_fail" ofType:@"jpg"]];
            self.imageView.image = loadFailIcon;
        }
    }];

    _upButton.hidden = first;
    _downButton.hidden = last;
}

- (void)hideUpButton:(BOOL)upButtonHidden downButton:(BOOL)downButtonHidden {
    _upButton.hidden = upButtonHidden;
    _downButton.hidden = downButtonHidden;
}

// 向上调序
- (void)upAdjuster {
    self.RankBlock(self ,UpOrientation);
}

// 向下调序
- (void)downAdjuster {
    self.RankBlock(self ,DownOrientation);
}

@end
