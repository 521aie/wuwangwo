//
//  LSMemberAccessView.m
//  retailapp
//
//  Created by byAlex on 16/9/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberAccessView.h"
#import "LSMemberCardCell.h"
#import "LSMemberSubmenuCell.h"
#import "LSMemberSubmenus.h"
#import "UIView+Sizes.h"
#import "LSMemberCardVo.h"
#import "LSMemberConst.h"
#import "LSAlertHelper.h"

@interface LSMemberAccessView()<UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic ,assign) MBAccessViewType type;/* <类型，*/
@property (nonatomic ,strong) NSArray *dataSource;/* <*/
@property (nonatomic ,strong) UICollectionView *collectionView;/* <*/
// <MBAccessCardsInfo 类型需要，分页显示多张卡
@property (nonatomic ,strong) UIPageControl *pageControl;
@property (nonatomic ,weak) id<MBAccessViewDelegate> delegate;/*<>*/
@end

@implementation LSMemberAccessView

+ (instancetype)memberAccessView:(MBAccessViewType)type delegate:(id<MBAccessViewDelegate>)delegate {
    
    CGFloat height = (type == MBAccessFunctions ? 173 : 178);
    LSMemberAccessView *accessView = [[LSMemberAccessView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, height)];
    accessView.type = type;
    accessView.delegate = delegate;
    [accessView setCollectionView];
    [accessView addNotification];
    
    return accessView;
}

// 添加通知监听“重新发卡”事件
- (void)addNotification {
    if (self.type == MBAccessCardsInfoDetailPage) {
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reSendDeletedCard:) name:kReSendDeletedCardNotificationKey object:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReSendDeletedCardNotificationKey object:nil];
}

- (void)reSendDeletedCard:(NSNotification *)not {
    
    // 两种情况： 1、未领卡点击发卡 2、已删除此卡点击重发
    if (self.type == MBAccessCardsInfoDetailPage) {
        if ([not.object isKindOfClass:[LSMemberCardCell class]]) {
            LSMemberCardCell *cell = (LSMemberCardCell *)not.object;
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            if (indexPath && [self.delegate respondsToSelector:@selector(memberAccessView:reSendCard:)]) {
                if ([ObjectUtil isNotEmpty:self.dataSource] && self.dataSource.count > indexPath.row) {
                    [self.delegate memberAccessView:self reSendCard:self.dataSource[indexPath.row]];
                }
                else {
                    [self.delegate memberAccessView:self reSendCard:nil];
                }
            }
        }
    }
}


- (void)setCardDatas:(NSArray<LSMemberCardVo *> *)array initPage:(NSInteger)page {
    
    self.dataSource = array;
    if (!self.pageControl) { [self setPageControl]; }
    if (array.count > 1) {
        self.pageControl.numberOfPages = array.count;
        self.pageControl.currentPage = page;
    } else {
        self.pageControl.hidden = YES;
        if (self.ls_height >= 200) {
            // pageControl 隐藏后，collectionView 整体调高一些，为了整体居中美观
            self.collectionView.ls_top = 15.0;
        }
    }
    [self.collectionView reloadData];
    if (self.type == MBAccessCardsInfo && page >= 1) {
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.ls_width*page, 0)];
    }
}


- (void)setPageControl {
    
    if (self.type != MBAccessFunctions) {
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.ls_height, self.ls_width, 22.0)];
        self.ls_height += 22.0;
        self.pageControl.numberOfPages = MAX(self.dataSource.count, 1);
        self.pageControl.currentPage = 0;
        [self addSubview:self.pageControl];
    }
}

- (void)setCollectionView {

    if (self.type == MBAccessFunctions) {
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 13.0;
        flowLayout.minimumInteritemSpacing = 10.0;
        flowLayout.itemSize = CGSizeMake(65.0, 75.0);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.ls_width, self.ls_height) collectionViewLayout:flowLayout];
        self.collectionView.contentInset = UIEdgeInsetsMake(9, 10, 9, 10);
        self.collectionView.scrollEnabled = NO;
        [self.collectionView registerClass:[LSMemberSubmenuCell class] forCellWithReuseIdentifier:@"LSMemberSubmenuCell"];
    }
    else {
        CGFloat collectionViewHeight = self.ls_height - self.pageControl.ls_height - 10;
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(self.ls_width - 20, collectionViewHeight);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 10, self.ls_width - 20, collectionViewHeight) collectionViewLayout:flowLayout];
        self.collectionView.pagingEnabled = YES;
        
        [self.collectionView registerClass:[LSMemberCardCell class] forCellWithReuseIdentifier:@"LSMemberCardCell"];
    }
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.collectionView];
}

#pragma mark UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.type == MBAccessCardsInfoDetailPage) {
        return self.dataSource.count ? : 1;
    }
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == MBAccessFunctions) {
        
        LSMemberSubmenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LSMemberSubmenuCell" forIndexPath:indexPath];
        LSMemberSubmenus *model = [self.dataSource objectAtIndex:indexPath.row];
        [cell fill:model.icon title:model.name action:model.actionCode];
        cell.title.textColor = [ColorHelper getTipColor6]; // 详情页模块名称字体颜色为灰色
        return cell;
    }
    else {
        LSMemberCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LSMemberCardCell" forIndexPath:indexPath];
        if ([ObjectUtil isNotEmpty:self.dataSource] && indexPath.row < self.dataSource.count) {
            [cell fillMemberCardVo:self.dataSource[indexPath.row] type:self.type];
        }
        else {
            [cell fillMemberCardVo:nil type:self.type];
        }
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    if (self.type == MBAccessFunctions && self.delegate) {
        
        LSMemberSubmenus *model = [self.dataSource objectAtIndex:indexPath.row];
        // 权限判断
        if ([[Platform Instance] lockAct:model.actionCode]) {
            [LSAlertHelper showAlert:[NSString stringWithFormat:@"您没有[%@]的权限！" ,model.name] block:nil];
            return;
        }
        [self.delegate memberAccessView:self tapFunction:model];
    }
}

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger page = (scrollView.contentOffset.x/scrollView.ls_width);
    self.pageControl.currentPage = page;
    if (self.dataSource[page] && [self.delegate respondsToSelector:@selector(memberAccessView:selectdPage:)]) {
        [self.delegate memberAccessView:self selectdPage:self.dataSource[page]];
    }
}

@end
