//
//  ViewController.m
//  CustomFlowLayout
//
//  Created by 李国民 on 15/12/2.
//  Copyright (c) 2015年 李国民. All rights reserved.
//

#import "ViewController.h"
#import "CustomFlowLayout.h"
#import "CustomItem.h"
#import "CustomLayout.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView * _collectionView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CustomLayout * layout = [CustomLayout new];
//    CustomFlowLayout * flowLayout = [[CustomFlowLayout alloc]init];
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    flowLayout.itemCount = 10;
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:NSClassFromString(@"CustomItem") forCellWithReuseIdentifier:@"CustomItem"];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomItem * item = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomItem" forIndexPath:indexPath];
    return item;
}
@end
