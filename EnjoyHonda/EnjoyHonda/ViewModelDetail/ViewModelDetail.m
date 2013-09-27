//
//  ViewModelDetail.m
//  EnjoyHonda
//
//  Created by saranpol on 9/26/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import "ViewModelDetail.h"
#import "CellModelTitle.h"
#import "CellModelPrice.h"
#import "CellModelFeature.h"

@implementation ViewModelDetail

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger i = indexPath.row;
    if(i <= 0){
        CellModelTitle *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellModelTitle" forIndexPath:indexPath];
        return cell;
    }

    if(i <= 3){
        CellModelPrice *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellModelPrice" forIndexPath:indexPath];
        return cell;
    }

    if(i <= 8){
        CellModelFeature *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellModelFeature" forIndexPath:indexPath];
        return cell;

    }
    

    CellModelTitle *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellModelTitle" forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if(kind == UICollectionElementKindSectionHeader){
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderModelDetail" forIndexPath:indexPath];
    }else{
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterModelDetail" forIndexPath:indexPath];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger i = indexPath.row;
    if(i <= 0)
        return CGSizeMake(286, 165 + 150);
    
    if(i <= 3)
        return CGSizeMake(286, 40);
    
    if(i <= 8)
        return CGSizeMake(286, 184 + 255);
    
    return CGSizeMake(286, 100);
}





@end

