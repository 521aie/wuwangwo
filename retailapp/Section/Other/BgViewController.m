//
//  BgViewController.m
//  retailapp
//
//  Created by taihangju on 16/6/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BgViewController.h"
#import "BackgroundData.h"
#import "XHAnimalUtil.h"

@interface BgImageCell()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@end

@implementation BgImageCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0f;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:YES];
    self.blurView.hidden = !selected;
    self.selectImageView.hidden = !selected;
}

- (void)fillData:(BackgroundData *)data
{
    self.bgImageView.image = [UIImage imageNamed:data.smallImgName];
}
@end


static NSString *cellReuseId = @"BgImageCell";
@interface BgViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *titleDev;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataList;/*<<#说明#>>*/
@property (nonatomic, strong) NSIndexPath *selectIndexPath;/*<<#说明#>>*/
@property (nonatomic ,strong) UIImageView *bigBgImgV;/* <显示选中的大图*/
@end

@implementation BgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBigBackgroundImageView];
    [self initNavigate];
    [self setSelectedIndelPath];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [[self.navigationController.viewControllers firstObject] performSelector:@selector(changeBackgroundImage) withObject:nil];
#pragma clang diagnostic pop
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //  scroll 到指定的cell
    [_collectionView scrollToItemAtIndexPath:_selectIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        BgImageCell *cell = (BgImageCell *)[_collectionView cellForItemAtIndexPath:_selectIndexPath];
        cell.blurView.hidden = NO;
        cell.selectImageView.hidden = NO;
    });
}

// 添加背景图
- (void)addBigBackgroundImageView {
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imgV.image = [Platform getBgImage];
    self.bigBgImgV = imgV;
    [self.view addSubview:imgV];
    [self.view sendSubviewToBack:imgV];
}

- (NSArray *)dataList
{
    if (!_dataList) {
        NSMutableArray *backgroundList = [[NSMutableArray alloc]initWithCapacity:9];
        [backgroundList addObject:[[BackgroundData alloc]init:@"bg_01_min" normalBgName:@"bg_01" blackBgName:@"bg_01b"]];
        [backgroundList addObject:[[BackgroundData alloc]init:@"bg_02_min" normalBgName:@"bg_02" blackBgName:@"bg_02b"]];
        [backgroundList addObject:[[BackgroundData alloc]init:@"bg_03_min" normalBgName:@"bg_03" blackBgName:@"bg_03b"]];
        [backgroundList addObject:[[BackgroundData alloc]init:@"bg_04_min" normalBgName:@"bg_04" blackBgName:@"bg_04b"]];
        [backgroundList addObject:[[BackgroundData alloc]init:@"bg_05_min" normalBgName:@"bg_05" blackBgName:@"bg_05b"]];
        [backgroundList addObject:[[BackgroundData alloc]init:@"bg_06_min" normalBgName:@"bg_06" blackBgName:@"bg_06b"]];
        [backgroundList addObject:[[BackgroundData alloc]init:@"bg_07_min" normalBgName:@"bg_07" blackBgName:@"bg_07b"]];
        [backgroundList addObject:[[BackgroundData alloc]init:@"bg_08_min" normalBgName:@"bg_08" blackBgName:@"bg_08b"]];
        [backgroundList addObject:[[BackgroundData alloc]init:@"bg_09_min" normalBgName:@"bg_09" blackBgName:@"bg_09b"]];
        _dataList = [backgroundList copy];
    }
    return _dataList;
}

- (void)setSelectedIndelPath
{
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    NSString *imageName = [self bgImgName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"blackBgName == %@", imageName];
    NSArray *resultArr = [self.dataList filteredArrayUsingPredicate:predicate];
    NSInteger index = 0;
    if (resultArr.count) {
        BackgroundData *data = (BackgroundData *)resultArr[0];
        index = [self.dataList indexOfObject:data];
    }
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    self.selectIndexPath = selectIndexPath;
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:selectIndexPath animated:YES scrollPosition:0];
}

#pragma mark - 初始化导航栏
- (void)initNavigate{
    [self configTitle:@"更换背景图" leftPath:Head_ICON_BACK rightPath:nil];
}


#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BgImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseId forIndexPath:indexPath];
    [cell fillData:_dataList[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BackgroundData *data = (BackgroundData *)[_dataList objectAtIndex:indexPath.row];
    self.bigBgImgV.image = [UIImage imageNamed:data.blackBgName];
    [[Platform Instance] saveKeyWithVal:BG_FILE withVal:data.blackBgName];
    if (self.selectIndexPath) {
        BgImageCell *cell = (BgImageCell *)[collectionView cellForItemAtIndexPath:_selectIndexPath];
        cell.selectImageView.hidden = YES;
        cell.blurView.hidden = YES;
        self.selectIndexPath = nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80, 80);
}

@end

