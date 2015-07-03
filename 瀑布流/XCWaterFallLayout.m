//
//  XCWaterFallLayout.m
//  瀑布流
//
//  Created by chengxun on 15/6/17.
//  Copyright (c) 2015年 chengxun. All rights reserved.
//

#import "XCWaterFallLayout.h"
@interface XCWaterFallLayout()
/**  存储的每一列最大的Y  */
@property (nonatomic,strong)NSMutableDictionary * maxYDict;
/**  存放所有布局属性  */
@property (nonatomic,strong)NSMutableArray * attrsArray;
@end
@implementation XCWaterFallLayout

- (NSMutableArray*)attrsArray{
    if(_attrsArray == nil)
    {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableDictionary*)maxYDict
{
    if(_maxYDict == nil)
    {
        _maxYDict = [NSMutableDictionary dictionary];
    }
    return _maxYDict;
}
- (instancetype)init
{
    if(self = [super init])
    {
        self.columnsCount = 3;
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}
/**  每次重新布局都需要调用这个方法,所以要讲之间存储的item的属性和maxY都清空,然后重新计算  */
- (void)prepareLayout
{
    [super prepareLayout];
    /**  1 清空最大的Y值  都设置成top */
    for(int i = 0;i<self.columnsCount;i++)
    {
        NSString * column = [NSString stringWithFormat:@"%i",i];
        self.maxYDict[column] = @(self.sectionInset.top);
    }
    /**  2 计算所有cell的属性加到数组中  */
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for(int i = 0;i<count;i++)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
        
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}
/**  计算瀑布流中每个item的的UICollcetionViewLayoutAttributes  */
- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /** 寻找出最短的那一列  */
    __block NSString * minColumn = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber * maxY, BOOL *stop) {
        if([maxY floatValue]<[self.maxYDict[minColumn] floatValue])
        {
            minColumn = column;
        }
    }];
    /**  计算尺寸  */
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - self.columnMargin*(self.columnsCount-1))/self.columnsCount;
    /**  高度需要根据宽度乘以图片实际的比例来计算  */
    CGFloat height = [self.delegate waterFallLayout:self heightForWidth:width atIndexPath:indexPath];
    
    /**  计算位置  */
    CGFloat x= self.sectionInset.left + (width+self.columnMargin)*[minColumn intValue];
    
    CGFloat y = [self.maxYDict[minColumn]floatValue] + self.rowMargin;
    
    /**  更新最大的Y值  */
    self.maxYDict[minColumn] = @(y+height);
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    return attrs;
    
}


/**  返回所有尺寸  */
- (CGSize)collectionViewContentSize
{
    /**  假设现在Y最大的是第0列  */
    __block NSString * maxColumn = @"0";
    /**  对这个maxYDict 进行枚举,选出最长的那一行  */
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber * maxY, BOOL *stop) {
        if([maxY floatValue]>[self.maxYDict[maxColumn] floatValue])
        {
            maxColumn = column;
        }
    }];
    /**  计算得出最大的Y值  */
    return CGSizeMake(0, [self.maxYDict[maxColumn] floatValue]+self.sectionInset.bottom);
    
}

@end
