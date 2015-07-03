//
//  XCWaterFallLayout.h
//  瀑布流
//
//  Created by chengxun on 15/6/17.
//  Copyright (c) 2015年 chengxun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XCWaterFallLayout;
@protocol XCWaterFallLayoutDelegate <NSObject>

@required

- (CGFloat)waterFallLayout:(XCWaterFallLayout*)waterFallLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath;

@end
@interface XCWaterFallLayout : UICollectionViewLayout
/**列间距*/
@property (nonatomic,assign)CGFloat columnMargin;
/**  行间距  */
@property (nonatomic,assign)CGFloat rowMargin;
/**  列数  */
@property (nonatomic,assign)NSInteger columnsCount;
/**  四周的距离设置  */
@property (nonatomic,assign)UIEdgeInsets sectionInset;

@property (nonatomic,weak)id<XCWaterFallLayoutDelegate> delegate;
@end
