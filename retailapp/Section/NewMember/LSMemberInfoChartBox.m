//
//  LSMemberInfoChartBox.m
//  retailapp
//
//  Created by taihangju on 2016/10/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberInfoChartBox.h"
#import "LSMemberInfoChartCell.h"
#import "LSMemberSummaryInfoVo.h"
#import "DateUtils.h"

CGFloat kCellWidth = 30.0;
CGFloat kCellHeight = 130.0;
CGFloat kReusableViewWidth = 137; // 是collectionView宽度的一半减去cell宽度的一半
@interface LSMemberInfoChartBox()<UICollectionViewDelegate ,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldMemberLabel;
@property (weak, nonatomic) IBOutlet UILabel *refreshMemberLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,weak) id<LSMemberInfoChartBoxDelegate> delegate;
@property (nonatomic ,strong) NSArray *datas;/*<数据源>*/
@property (nonatomic ,strong) NSNumber *maxMemberNum;/*<最大会员数>*/
@end

@implementation LSMemberInfoChartBox

+ (instancetype)memberInfoChartBox:(id<LSMemberInfoChartBoxDelegate>)delegate {
    
    LSMemberInfoChartBox *box = [[NSBundle mainBundle] loadNibNamed:@"LSMemberInfoChartBox" owner:nil options:nil].firstObject;
    box.collectionView.delegate = box;
    box.collectionView.dataSource = box;
    box.delegate = delegate;
    [box.collectionView registerNib:[UINib nibWithNibName:@"LSMemberInfoChartCell" bundle:nil] forCellWithReuseIdentifier:@"LSMemberInfoChartCell"];
    [box.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionViewReuseseHeader"];
    [box.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionViewReuseseFooter"];
    return box;
}

- (void)setData:(NSArray *)dataSource memberNum:(NSNumber *)num startPage:(NSInteger)page {
    
    self.maxMemberNum = num;
    self.datas = dataSource;
    if (self.datas.count > 0) {
        [self.collectionView reloadData];
        [self performSelector:@selector(collectionViewScrollToPage:) withObject:@(page) afterDelay:0.5];
    }
}

- (void)collectionViewScrollToPage:(NSNumber *)page {
    
    if (self.datas && page.integerValue < self.datas.count) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:page.intValue inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        if ([self.delegate respondsToSelector:@selector(memberInfoChartBox:page:)]) {
            self.timeLabel.text = [self.delegate memberInfoChartBox:self page:page.integerValue];
        }
    }
    if (page.integerValue == 0) {
        [self scrollViewDidScroll:self.collectionView];
    }
}

#pragma mark UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LSMemberInfoChartCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LSMemberInfoChartCell" forIndexPath:indexPath];
    LSMemberSummaryInfoVo *vo = [self.datas objectAtIndex:indexPath.row];
    if ([NSString isNotBlank:vo.date]) {
        // 按日显示会员汇总信息
        [cell fill:self.maxMemberNum oldMemberNum:vo.custormerOldNumDay newMemberNum:vo.customerNumDay];
    }
    else {
        // 按月显示会员汇总信息
        [cell fill:self.maxMemberNum oldMemberNum:vo.customerOldNumMonth newMemberNum:vo.customerNumMonth];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionViewReuseseHeader" forIndexPath:indexPath];
        return header;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionViewReuseseFooter" forIndexPath:indexPath];
        return footer;
    }
    return nil;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kReusableViewWidth ,kCellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(kReusableViewWidth, kCellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kCellWidth, kCellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
    CGFloat offsetX = MAX(self.collectionView.contentOffset.x, 0);
    NSInteger page = (NSInteger)(offsetX/kCellWidth + 0.5);
    if (self.datas) {
    
        page = MIN(self.datas.count - 1, page);
        if ([self.delegate respondsToSelector:@selector(memberInfoChartBox:page:)]) {
            self.timeLabel.text = [self.delegate memberInfoChartBox:self page:page];
            LSMemberSummaryInfoVo *vo = [self.datas objectAtIndex:page];
            
            if ([NSString isNotBlank:vo.date]) {
                // 按日
                self.refreshMemberLabel.text = [NSString stringWithFormat:@"老会员%@人" ,vo.custormerOldNumDay?:@"0"];
                self.oldMemberLabel.text = [NSString stringWithFormat:@"新会员%@人" ,vo.customerNumDay?:@"0"];
            }
            else {
                // 按月
                self.refreshMemberLabel.text = [NSString stringWithFormat:@"老会员%@人" ,vo.customerOldNumMonth?:@"0"];
                self.oldMemberLabel.text = [NSString stringWithFormat:@"新会员%@人" ,vo.customerNumMonth?:@"0"];
            }
            
        }
        if ([self.delegate respondsToSelector:@selector(memberInfoChartBox:select:)]) {
            self.currentData = self.datas[page];
            [self.delegate memberInfoChartBox:self select:self.currentData];
        }
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0] animated:NO scrollPosition:0];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self adjustCollectionViewPosition];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (fabs(targetContentOffset->x - scrollView.contentOffset.x) <= 10) {
        [self adjustCollectionViewPosition];
    }
}


- (void)adjustCollectionViewPosition {
    
    CGFloat offsetX = MAX(self.collectionView.contentOffset.x, 0);
    NSInteger page = (NSInteger)(offsetX/kCellWidth + 0.5);
    if (self.datas) {

        page = MIN((self.datas.count - 1), page);
        [self collectionViewScrollToPage:@(page)];
    }
}


//// 更新相关数据
//
//- (void)displayMemberNum:(NSInteger)page {
//    
//    
//}
@end
