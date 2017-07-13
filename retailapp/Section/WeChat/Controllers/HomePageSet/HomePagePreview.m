//
//  WeChatShopHomeSet.m
//  retailapp
//
//  Created by diwangxie on 16/4/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "HomePagePreview.h"
#import "XHAnimalUtil.h"
#import "EditItemBase.h"
#import "CarouselFigurePreview.h"
#import "DoubleFocusSet.h"
#import "SingleFocusSet.h"
#import "HotTypeSet.h"
#import "SingleGoodsSet.h"
#import "DoubleGoodsSet.h"

#import "UIView+Sizes.h"
#import "StyleItem.h"
#import "AlertBox.h"
#import "MicroShopHomepageVo.h"
#import "ObjectUtil.h"
#import "EditItemImage6.h"
#import "BaseService.h"
#import "ServiceFactory.h"
#import "WeChatImageBox.h"

@interface HomePagePreview () <EditItemImageDelegate,EditItemImage6Delegate>

@property (strong, nonatomic) UIScrollView *scrollView;
/**
 *  轮播图展示，原则上选择sortCode最小的那张展示，这个值是变化的。
 */
@property (nonatomic ,assign) NSInteger scrollPhotoSortCode;
@property (nonatomic ,strong) NSMutableArray *microShopHomepageList;/*<微店主页图片列表*/
@property (nonatomic ,strong) NSMutableArray *doubleGoodsList;/*<双列商品列表*/
@property (nonatomic ,strong) NSMutableArray *rmViewsArr;/* <存储“根具数据增删的view”*/
@property (nonatomic ,strong) BaseService   *service; //网络服务

@property (nonatomic ,strong) WeChatImageBox *scrollBox;/* <轮播图*/
@property (nonatomic ,strong) WeChatImageBox *doubleFocusBox1;/* <双列焦点图1*/
@property (nonatomic ,strong) WeChatImageBox *doubleFocusBox2;/* <双列焦点图2*/
@property (nonatomic ,strong) WeChatImageBox *singleFocusBox;/* <单列焦点图*/
@property (nonatomic ,strong) WeChatImageBox *hotCateBox1;/* <热点分类图1*/
@property (nonatomic ,strong) WeChatImageBox *hotCateBox2;/* <热点分类图2*/
@property (nonatomic ,strong) WeChatImageBox *hotCateBox3;/* <热点分类图3*/
@property (nonatomic ,strong) WeChatImageBox *hotCateBox4;/* <热点分类图4*/
@property (nonatomic ,strong) WeChatImageBox *hotCateBox5;/* <热点分类图5*/
@property (nonatomic ,strong) WeChatImageBox *hotCateBox6;/* <热点分类图6*/
@property (nonatomic ,strong) WeChatImageBox *singleGoodBox;/* <单列商品图*/
@property (nonatomic ,strong) UILabel *noticeLabel;/* <提示信息label*/
@end

@implementation HomePagePreview

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self addStableViews];
    _service = [ServiceFactory shareInstance].baseService;
    _microShopHomepageList = [[NSMutableArray alloc] init];
    _rmViewsArr = [[NSMutableArray alloc] init];
    _doubleGoodsList = [[NSMutableArray alloc] init];
    [self reloadData];
    [self configHelpButton:HELP_WECHAT_HOME_SETTING];
}

- (void)configViews {
    [self configTitle:@"微店主页设置" leftPath:Head_ICON_BACK rightPath:nil];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.scrollView];
}

- (void)reloadData {
    _scrollPhotoSortCode = 5;
    if (_microShopHomepageList.count) {
         // 删除之前的双列商品view列表
        [_rmViewsArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_rmViewsArr removeAllObjects];
        [self addStableViews];
        
        [_scrollBox initBoxView:nil homePageId:nil];
        [_doubleFocusBox1 initBoxView:nil homePageId:nil];
        [_doubleFocusBox2 initBoxView:nil homePageId:nil];
        [_singleFocusBox initBoxView:nil homePageId:nil];
        [_hotCateBox1 initBoxView:nil homePageId:nil];
        [_hotCateBox2 initBoxView:nil homePageId:nil];
        [_hotCateBox3 initBoxView:nil homePageId:nil];
        [_hotCateBox4 initBoxView:nil homePageId:nil];
        [_hotCateBox5 initBoxView:nil homePageId:nil];
        [_hotCateBox6 initBoxView:nil homePageId:nil];
        [_singleGoodBox initBoxView:nil homePageId:nil];

    }
    [self getHomepageDataList];
}

#pragma mark - 网络
- (void)getHomepageDataList {
    
    NSString *shopId = nil;
    shopId = [[Platform Instance] getkey:SHOP_ID];
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"shopId":shopId,
                            @"interface_version":@2};
    NSString *url = @"microShopHomepage/selectHomepageImage";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        
        // 获取页面列表数据
        weakSelf.microShopHomepageList = [MicroShopHomepageVo getMicroShopHomepageVos:
                                          [json objectForKey:@"microShopHomepageList"]];
        
        [_doubleGoodsList removeAllObjects];
        for (MicroShopHomepageVo *vo in weakSelf.microShopHomepageList) {
            if (vo.setType != 6) {
                [weakSelf fillData:vo];
            }else if (vo.setType == 6) {
                // 筛选出双列商品MicroShopHomepageVo
                [weakSelf.doubleGoodsList addObject:vo];
            }
        }
        
        // 配置新的双列商品view列表
        [weakSelf configVariableViews];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - 界面配置，数据处理
// 添加固定展示view
- (void)addStableViews {
    
    CGFloat _scrollViewContentHeight = 10;
    // 轮播图
    if (!_scrollBox) {
        _scrollBox = [[WeChatImageBox alloc] initWithFrame:CGRectMake(0, 0, 320, 200) action:1 tag:1 delegate:self];
        _scrollBox.tag = 101;
        [_scrollView addSubview:_scrollBox];
    }
    _scrollViewContentHeight += _scrollBox.view.ls_size.height;
    
    // 双列焦点图
    if (!_doubleFocusBox1) {
        _doubleFocusBox1 = [[WeChatImageBox alloc] initWithFrame:CGRectMake(0, _scrollViewContentHeight, 160, 77) action:2 tag:2 delegate:self];
        _doubleFocusBox1.tag = 102;
        [_scrollView addSubview:_doubleFocusBox1];
    }

    if (!_doubleFocusBox2) {
        _doubleFocusBox2 = [[WeChatImageBox alloc] initWithFrame:CGRectMake(155, _scrollViewContentHeight, 160, 77) action:2 tag:3 delegate:self];
        _doubleFocusBox2.tag = 103;
        [_scrollView addSubview:_doubleFocusBox2];
    }
    _scrollViewContentHeight += (_doubleFocusBox2.view.ls_size.height+10);
    
    // 单列焦点图
    if (!_singleFocusBox) {
        _singleFocusBox = [[WeChatImageBox alloc] initWithFrame:CGRectMake(0, _scrollViewContentHeight, 320, 100) action:3 tag:4 delegate:self];
        _singleFocusBox.tag = 104;
        [_scrollView addSubview:_singleFocusBox];
    }
    _singleFocusBox.ls_height = 100;
    _scrollViewContentHeight += _singleFocusBox.view.ls_size.height;
    
    // 热点分类-圆形图 共6张
    if (!_hotCateBox1) {
        _hotCateBox1 = [[WeChatImageBox alloc] initWithFrame:CGRectMake(0, _scrollViewContentHeight, 106, 136) action:4 tag:5 delegate:self];
        _hotCateBox1.tag = 105;
        [_scrollView addSubview:_hotCateBox1];
    }
     [_hotCateBox1 initBoxViewToCornerRadius:@"分类一"];
    _hotCateBox1.ls_top = _scrollViewContentHeight;
    
    if (!_hotCateBox2) {
        _hotCateBox2 = [[WeChatImageBox alloc] initWithFrame:CGRectMake(106, _scrollViewContentHeight, 106, 136) action:4 tag:6 delegate:self];
        _hotCateBox2.tag = 106;
        [_scrollView addSubview:_hotCateBox2];
    }
    [_hotCateBox2 initBoxViewToCornerRadius:@"分类二"];
    _hotCateBox2.ls_top = _scrollViewContentHeight;
    
    if (!_hotCateBox3) {
        _hotCateBox3 = [[WeChatImageBox alloc] initWithFrame:CGRectMake(213, _scrollViewContentHeight, 106, 136) action:4 tag:7 delegate:self];
        _hotCateBox3.tag = 107;
        [_scrollView addSubview:_hotCateBox3];
    }
    [_hotCateBox3 initBoxViewToCornerRadius:@"分类三"];
    _hotCateBox3.ls_top = _scrollViewContentHeight;
    _scrollViewContentHeight += 136;
    
    if (!_hotCateBox4) {
        _hotCateBox4 = [[WeChatImageBox alloc] initWithFrame:CGRectMake(0, _scrollViewContentHeight, 106, 136) action:4 tag:8 delegate:self];
        _hotCateBox4.tag = 108;
        [_scrollView addSubview:_hotCateBox4];
    }
     [_hotCateBox4 initBoxViewToCornerRadius:@"分类一"];
    _hotCateBox4.ls_top = _scrollViewContentHeight;
    
    if (!_hotCateBox5) {
        _hotCateBox5 = [[WeChatImageBox alloc] initWithFrame:CGRectMake(106, _scrollViewContentHeight, 106, 136) action:4 tag:9 delegate:self];
  
        _hotCateBox5.tag = 109;
        [_scrollView addSubview:_hotCateBox5];
    }
    [_hotCateBox5 initBoxViewToCornerRadius:@"分类二"];
    _hotCateBox5.ls_top = _scrollViewContentHeight;
    
    if (!_hotCateBox6) {
        _hotCateBox6 = [[WeChatImageBox alloc] initWithFrame:CGRectMake(213, _scrollViewContentHeight, 106, 136) action:4 tag:10 delegate:self];
        _hotCateBox6.tag = 110;
        [_scrollView addSubview:_hotCateBox6];
    }
    [_hotCateBox6 initBoxViewToCornerRadius:@"分类三"];
    _hotCateBox6.ls_top = _scrollViewContentHeight;
    
    _scrollViewContentHeight += 136;
    
    // 单列商品图
    if (!_singleGoodBox) {
        _singleGoodBox = [[WeChatImageBox alloc] initWithFrame:CGRectMake(0, _scrollViewContentHeight, 320, 200) action:1 tag:11 delegate:self];
        _singleGoodBox.tag = 111;
        [_scrollView addSubview:_singleGoodBox];
        _singleGoodBox.img.contentMode = UIViewContentModeScaleToFill;
    }
    _singleGoodBox.ls_top = _scrollViewContentHeight;
    _scrollViewContentHeight += _singleGoodBox.ls_height;
    
    // 底部提示信息
    if (!_noticeLabel) {
        _noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _scrollViewContentHeight, 300, 30)];
        _noticeLabel.text = @"提示:未设置的模块，将在微店H5端上隐藏。";
        _noticeLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
        _noticeLabel.textColor = [UIColor grayColor];
        _noticeLabel.tag = 112;
        [_scrollView addSubview:_noticeLabel];
    }
    _noticeLabel.ls_top = _scrollViewContentHeight;
    _scrollViewContentHeight = CGRectGetMaxY(_noticeLabel.frame) + 30;
    [self.scrollView setContentSize:CGSizeMake(320, _scrollViewContentHeight)];
}

// 根据数据更新固定view界面，
- (void)fillData:(MicroShopHomepageVo *)vo {
    
    if (vo.setType == 1 && vo.sortCode <= _scrollPhotoSortCode) {
        _scrollPhotoSortCode = vo.sortCode;
        [_scrollBox initBoxView:vo.filePath homePageId:vo.homePageId];
        
    }else if (vo.setType == 2) {
        
        if (vo.sortCode  == 1) {
            [_doubleFocusBox1 initBoxView:vo.filePath homePageId:vo.homePageId];
        }else{
            [_doubleFocusBox2 initBoxView:vo.filePath homePageId:vo.homePageId];
        }
        
    }else if (vo.setType == 3) {
        
        [_singleFocusBox initBoxView:vo.filePath homePageId:vo.homePageId];
        
        
    }else if (vo.setType == 4) {
        
        if (vo.sortCode  == 1) {
            [_hotCateBox1 initBoxView:vo.filePath homePageId:vo.homePageId];
            [_hotCateBox1 initBoxViewToCornerRadius:vo.cateGoryName];
        }else if(vo.sortCode == 2) {
            [_hotCateBox2 initBoxView:vo.filePath homePageId:vo.homePageId];
            [_hotCateBox2 initBoxViewToCornerRadius:vo.cateGoryName];
        }else if(vo.sortCode == 3) {
            [_hotCateBox3 initBoxView:vo.filePath homePageId:vo.homePageId];
            [_hotCateBox3 initBoxViewToCornerRadius:vo.cateGoryName];
        }else if(vo.sortCode  == 4) {
            [_hotCateBox4 initBoxView:vo.filePath homePageId:vo.homePageId];
            [_hotCateBox4 initBoxViewToCornerRadius:vo.cateGoryName];
        }else if(vo.sortCode  == 5) {
            [_hotCateBox5 initBoxView:vo.filePath homePageId:vo.homePageId];
            [_hotCateBox5 initBoxViewToCornerRadius:vo.cateGoryName];
        }else if(vo.sortCode  == 6) {
            [_hotCateBox6 initBoxView:vo.filePath homePageId:vo.homePageId];
            [_hotCateBox6 initBoxViewToCornerRadius:vo.cateGoryName];
        }
        
    }else if (vo.setType == 5) {
        
        [_singleGoodBox initBoxView:vo.filePath homePageId:vo.homePageId];
        
    }
}


// 添加可变views -> 双列商品图
- (void)configVariableViews {
    
    CGFloat _scrollViewContentHeight = CGRectGetMaxY(_singleGoodBox.frame);
    NSInteger maxCount = _doubleGoodsList.count;
    if (!_doubleGoodsList.count) {
        maxCount += 1;
    }
    for (int count = 0; count < maxCount; count ++) {
        
        CGRect frame = CGRectMake(10 + (count%2)*(145+10),
                                  _scrollViewContentHeight, 145, 200);
        EditItemImage6 *doubleBox = [[EditItemImage6 alloc]
                                     initWithFrame:frame delegate:self];
        doubleBox.tag = _noticeLabel.tag + count + 1;
        if (_doubleGoodsList.count) {
            MicroShopHomepageVo *vo = (MicroShopHomepageVo *)_doubleGoodsList[count];
            [doubleBox initListView:[vo convertToDictionary] delegate:self];
            [doubleBox initView:vo.filePath path:vo.file styleCode:vo.styleCode];
        }else {
            // 设置一个空的doubleBox
            [doubleBox initListView:nil delegate:self];
        }
        if (count%2) {
            _scrollViewContentHeight += 200;
        }
        [_scrollView addSubview:doubleBox];
        [_rmViewsArr addObject:doubleBox];
    }
    
    // 调整scrollview的contentsize和noticeLabel的位置
    if (maxCount%2 == 1) {
        _scrollViewContentHeight += 200;
    }
    [_scrollView setContentSize:CGSizeMake(320, _scrollViewContentHeight+50)];
    _noticeLabel.ls_top = _scrollViewContentHeight;
}

#pragma mark - EditItemImageDelegate
// 根据下载完成的图片，调整单列焦点图的高度，并重新对界面子views调整高度
- (void)itemImageDownloadSuccess:(WeChatImageBox *)item {
    
    if ([item isEqual:_singleFocusBox]) {
        
        CGSize imageSize = _singleFocusBox.img.image.size;
        CGFloat newHeight = (imageSize.height/imageSize.width)*_singleFocusBox.ls_width;
        CGFloat dValue = newHeight - _singleFocusBox.ls_height;
        _singleFocusBox.ls_height = newHeight;
        
        NSInteger maxCout = _doubleGoodsList.count + _noticeLabel.tag + 1;
        
        for (NSInteger i = 105; i <= maxCout; i ++ ) {
            
            UIView *view = [_scrollView viewWithTag:i];
            view.ls_top += dValue;
        }
    }
    
    [_scrollView setContentSize:CGSizeMake(320, _noticeLabel.ls_bottom+30)];
}

//点击图片进入相应的图片设置页面
- (void)editItemImage:(WeChatImageBox *)item {
    
    __weak typeof(self) weakSelf = self;
    if (item.btnAdd.tag == 1) {
       
        // 轮播图 -> 轮播图
        CarouselFigurePreview *vc = [[CarouselFigurePreview alloc] init];
        [vc callBack:^{
            [weakSelf performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        }];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
    }else if(item.btnAdd.tag <= 3) {
        
        //双列焦点图 -> 双列焦点图设置
        DoubleFocusSet *vc = [[DoubleFocusSet alloc] initWithNibName:[SystemUtil getXibName:@"DoubleFocusSet"] bundle:nil];
        [vc setHomepageId:item.homePageId sortCode:item.btnAdd.tag-1 block:^{
            [weakSelf performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        }];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
    }else if(item.btnAdd.tag == 4) {
        
        // 单列焦点图 -> 单列焦点图设置
        SingleFocusSet *vc = [[SingleFocusSet alloc] initWithNibName:[SystemUtil getXibName:@"SingleFocusSet"] bundle:nil];
        [vc setHomepageId:item.homePageId callBack:^{
            [weakSelf performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        }];
        //表ID
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
    }else if(item.btnAdd.tag == 11) {
        
        // 单列商品图 -> 单列商品设置
        SingleGoodsSet *vc = [[SingleGoodsSet alloc] initWithNibName:[SystemUtil getXibName:@"SingleGoodsSet"] bundle:nil];
        [vc setHomepageId:item.homePageId callBack:^{
            [weakSelf performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        }];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }else {
      
        // 圆形图(6张) -> 热门分类设置
        HotTypeSet *vc = [[HotTypeSet alloc] initWithNibName:[SystemUtil getXibName:@"HotTypeSet"] bundle:nil];
        [vc setHomepageId:item.homePageId sortCode:item.btnAdd.tag-4 block:^{
            [weakSelf performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        }];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

#pragma mark - EditItemImage6Delegate
- (void)editItemImage2:(EditItemImage6 *)item {
    
    // 双列商品图点击 -> 双列商品图设置
    __weak typeof(self) weakSelf = self;
    DoubleGoodsSet *vc = [[DoubleGoodsSet alloc] initWithNibName:@"DoubleGoodsSet" bundle:nil];
    [vc setCallBack:^{
        [weakSelf performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    }];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
