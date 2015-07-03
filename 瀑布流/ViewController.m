//
//  ViewController.m
//  瀑布流
//
//  Created by chengxun on 15/6/17.
//  Copyright (c) 2015年 chengxun. All rights reserved.
//

#import "ViewController.h"
#import "XCShopCell.h"
#import "MJExtension.h"
#import "XCWaterFallLayout.h"
#import "MJRefresh.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,XCWaterFallLayoutDelegate>
/**  存放shop模型的数组  */
@property (nonatomic,strong)NSMutableArray * shops;
@property (nonatomic,weak)UICollectionView * collectionView;
@end

@implementation ViewController

- (CGFloat)waterFallLayout:(XCWaterFallLayout *)waterFallLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    XCShop * shop = self.shops[indexPath.item];
    CGFloat shopH = [shop.h floatValue];
    CGFloat shopW = [shop.w floatValue];
    return shopH/shopW * width;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray * shopArray = [XCShop objectArrayWithFilename:@"1.plist"];
    [self.shops addObjectsFromArray:shopArray];
    
    XCWaterFallLayout * layout = [[XCWaterFallLayout alloc]init];
    layout.delegate = self;
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    collectionView.delegate = self;
    
    collectionView.dataSource = self;
    
    collectionView.backgroundColor = [UIColor colorWithRed:1.000 green:0.248 blue:0.243 alpha:1.000];
    
    self.collectionView = collectionView;
    
  /**  自己定制需要的刷新文字效果,MJRefreshAutoNormalFooter 才可以修改这些状态 */
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [footer setTitle:@"Click or drag to refresh" forState:MJRefreshStateIdle];
    [footer setTitle:@"Loading More" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"No More Data" forState:MJRefreshStateNoMoreData];
    
    self.collectionView.footer = footer;
  
    
    [self.view addSubview:collectionView];
  
}
- (void)loadMore
{
    NSArray * shopArray = [XCShop objectArrayWithFilename:@"1.plist"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.shops addObjectsFromArray:shopArray];
        
        [self.collectionView reloadData];
        
     [self.collectionView.footer endRefreshing];
    });
    
    
   
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%zi",self.shops.count);
    return self.shops.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XCShopCell * cell = [XCShopCell shopCellWith:collectionView andIndexPath:indexPath];
    cell.shop = self.shops[indexPath.row];
    return cell;
}

- (NSMutableArray*)shops
{
    if(_shops == nil)
    {
        _shops = [NSMutableArray array];
    }
    return _shops;
}




@end
