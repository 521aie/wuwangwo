//
//  LSBarChartFlowLayout.m
//  retailapp
//
//  Created by guozhi on 16/8/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSBarChartFlowLayout.h"
@interface LSBarChartFlowLayout()
@property (nonatomic, assign) CGSize kItemSize;
@property (nonatomic, assign) CGFloat kitemSpace;
@end
@implementation LSBarChartFlowLayout
-(instancetype)initWithItemSize:(CGSize)itemSize itemSpace:(CGFloat)itemSpace
{
    if(self=[super init]){
        self.kItemSize = itemSize;
        self.kitemSpace = itemSpace;
    }
    return self;
}
- (void)prepareLayout {
    [super prepareLayout];
    // 设置为水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 设置每个Item之间的距离
    self.minimumLineSpacing = self.kitemSpace;
    // 重新设置Item的尺寸，不然的话，有等比例缩小的可能
    self.itemSize = self.kItemSize;
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    
    return YES;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGFloat inset = (self.collectionView.frame.size.width - self.kItemSize.width) * 0.5;
    // 设置第一个和最后一个默认居中显示
    self.collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect contentFrame;
    contentFrame.size = self.collectionView.frame.size;
    contentFrame.origin = proposedContentOffset;
    
    NSArray *array = [self layoutAttributesForElementsInRect:contentFrame];
    
    //2. 计算在可视范围的距离中心线最近的Item
    CGFloat minCenterX = CGFLOAT_MAX;
    CGFloat collectionViewCenterX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if(ABS(attrs.center.x - collectionViewCenterX) < ABS(minCenterX)){
            minCenterX = attrs.center.x - collectionViewCenterX;
        }
    }
    
    //3. 补回ContentOffset，则正好将Item居中显示
    return CGPointMake(proposedContentOffset.x + minCenterX, proposedContentOffset.y);
    
}

@end
