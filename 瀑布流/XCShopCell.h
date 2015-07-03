//
//  XCShopCell.h
//  瀑布流
//
//  Created by chengxun on 15/6/17.
//  Copyright (c) 2015年 chengxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCShop.h"
@interface XCShopCell : UICollectionViewCell

/**  shop模型  */
@property (nonatomic,strong)XCShop * shop;

+ (instancetype)shopCellWith:(UICollectionView*)collectionView andIndexPath:(NSIndexPath*)indexPath;

@end
