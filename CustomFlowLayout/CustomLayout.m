//
//  CustomLayout.m
//  CustomFlowLayout
//
//  Created by GM on 16/7/20.
//  Copyright © 2016年 李国民. All rights reserved.
//

#import "CustomLayout.h"

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.1
#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)

#define KItemWid 250
#define KItemHei 350
#define KSpace 15

@implementation CustomLayout

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewLayoutAttributes * attribute = [super layoutAttributesForItemAtIndexPath:indexPath];
    if (attribute == nil) {
        attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    }
    attribute.frame = CGRectMake(indexPath.row * (KItemWid + KSpace), 0.5 * (kScreen_Height - KItemWid), KItemWid, KItemHei);
    return attribute;
}
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{

    NSLog(@"rect : %@",NSStringFromCGRect(rect));
    NSMutableArray *attributeArr = [NSMutableArray array];
    for (NSInteger i = 0 ; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [attributeArr addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    NSLog(@"visibleRect : %@",NSStringFromCGRect(visibleRect));
    for (UICollectionViewLayoutAttributes* attributes in attributeArr) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            distance = ABS(distance);
            NSLog(@"distance : %f",distance);
            if (distance <= kScreen_Width / 2 + KItemWid/2) {
                CGFloat zoom = 1 + ZOOM_FACTOR * (1 - distance / ACTIVE_DISTANCE);
                NSLog(@"zoom : %f",zoom);
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.transform3D = CATransform3DTranslate(attributes.transform3D, 0 , -zoom * 25, -zoom * 50);
                attributes.alpha = zoom - ZOOM_FACTOR;
            }
        }
    }
    return attributeArr;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);

    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [self layoutAttributesForElementsInRect:targetRect];
    /**
     *  找到在松手的那一刻哪个item距离horizontalCenter最近  最近的距离是多少
     */
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        NSLog(@"ABS(offsetAdjustment) %f",ABS(offsetAdjustment));
        NSLog(@"ABS(itemHorizontalCenter - horizontalCenter) %f",ABS(itemHorizontalCenter - horizontalCenter));
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    NSLog(@"stop point : %@",NSStringFromCGPoint(CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y)));
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

- (CGSize)collectionViewContentSize{
//
    NSInteger rows = [self.collectionView numberOfItemsInSection:0];
    CGSize size = CGSizeMake(rows * (KItemWid + KSpace) - KSpace, KItemHei);
    NSLog(@"contentSize : %@",NSStringFromCGSize(size));
    return CGSizeMake(rows * (KItemWid + KSpace) - KSpace, KItemHei);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}
@end
