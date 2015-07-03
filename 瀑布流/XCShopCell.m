//
//  XCShopCell.m
//  瀑布流
//
//  Created by chengxun on 15/6/17.
//  Copyright (c) 2015年 chengxun. All rights reserved.
//

#import "XCShopCell.h"
#import "UIImageView+WebCache.h"
@interface XCShopCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
@implementation XCShopCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)shopCellWith:(UICollectionView*)collectionView andIndexPath:(NSIndexPath*)indexPath
{
    UINib * nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([self class])];
    XCShopCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    return cell;
}

- (void)setShop:(XCShop *)shop
{
    _shop = shop;
    NSURL * url = [NSURL URLWithString:shop.img];
    
    [self.photoView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    
    self.priceLabel.text = shop.price;
}
@end
