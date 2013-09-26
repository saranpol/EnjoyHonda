//
//  ViewDealers.m
//  EnjoyHonda
//
//  Created by saranpol on 9/26/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import "ViewDealers.h"
#import "CellDealer.h"

@implementation ViewDealers

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CellDealer *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellDealer" forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderDealer" forIndexPath:indexPath];
    return cell;
}


@end
