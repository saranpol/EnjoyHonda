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
#import "CellModelRemark.h"
#import "CellModelFeature.h"
#import "API.h"

@implementation ViewModelDetail

@synthesize mCollectionView;
@synthesize mData;
@synthesize mModelID;


- (void)setup:(NSString*)model_id {
    self.mModelID = model_id;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateData];
}

- (NSString*)getModelKey {
    return [M_model stringByAppendingString:mModelID];
}

- (void)updateData {
    API *a = [API getAPI];
    
    [a api_model:mModelID
         success:^(id JSON){
             NSDictionary *json = (NSDictionary*)JSON;
             [a saveObject:json forKey:[self getModelKey]];
             [self updateUI];
         }failure:^(NSError* error){
         }];
}

- (void)updateUI {
    API *a = [API getAPI];
    NSDictionary *data = [a getObject:[self getModelKey]];
    if(data){
        self.mData = data;
        [mCollectionView reloadData];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(!mData)
        return 0;
    
    NSArray *price_list = [mData objectForKey:@"price_list"];
    NSArray *feature_list = [mData objectForKey:@"feature_list"];
    
    return 1 + [price_list count] + 1 + [feature_list count] + 1 + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger i = indexPath.row;
    if(i == 0){
        CellModelTitle *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellModelTitle" forIndexPath:indexPath];
        return cell;
    }

    NSArray *price_list = [mData objectForKey:@"price_list"];
    NSArray *feature_list = [mData objectForKey:@"feature_list"];
    
    if(i < 1 + [price_list count]){
        NSInteger j = i - 1;
        CellModelPrice *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellModelPrice" forIndexPath:indexPath];
        return cell;
    }

    if(i < 1 + [price_list count] + 1){
        CellModelRemark *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellModelRemark" forIndexPath:indexPath];
        return cell;
    }

    if(i < 1 + [price_list count] + 1 + [feature_list count]){
        NSInteger j = i - 1 - [price_list count] - 1;
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
    if(i == 0){
        return CGSizeMake(286, 165 + 150);
    }
    
    NSArray *price_list = [mData objectForKey:@"price_list"];
    NSArray *feature_list = [mData objectForKey:@"feature_list"];
    
    if(i < 1 + [price_list count]){
        //CellModelPrice
        NSInteger j = i - 1;
        return CGSizeMake(286, 40);
    }
    
    if(i < 1 + [price_list count] + 1){
        //CellModelRemark
        return CGSizeMake(286, 70);
    }
    
    if(i < 1 + [price_list count] + 1 + [feature_list count]){
        //CellModelFeature
        NSInteger j = i - 1 - [price_list count] - 1;
        return CGSizeMake(286, 184 + 255);
    }
    
    return CGSizeMake(286, 100);
}





@end

