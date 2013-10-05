//
//  ViewModels.m
//  EnjoyHonda
//
//  Created by saranpol on 9/26/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import "ViewModels.h"
#import "CellModel.h"
#import "API.h"
#import "UIImageView+WebCache.h"
#import "ViewModelDetail.h"

@implementation ViewModels

@synthesize mCollectionView;
@synthesize mArrayModels;


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

- (void)updateData {
    API *a = [API getAPI];
    
    [a api_models:^(id JSON){
        NSDictionary *json = (NSDictionary*)JSON;
        [a saveObject:json forKey:M_models];
        if(!mArrayModels)
            [self updateUI];
    }failure:^(NSError* error){
    }];
}

- (void)updateUI {
    API *a = [API getAPI];
    NSDictionary *data = [a getObject:M_models];
    if(data){
        self.mArrayModels = [data objectForKey:@"data"];
        [mCollectionView reloadData];
    }
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (mArrayModels) ? [mArrayModels count] : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CellModel *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellModel" forIndexPath:indexPath];
    
    NSDictionary *item = [mArrayModels objectAtIndex:indexPath.row];
    NSString *image_color = [item objectForKey:@"image_color"];

    [cell.mImage setImageWithURL:[NSURL URLWithString:image_color]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                           if(cacheType!=SDImageCacheTypeMemory){
                               [cell.mImage setAlpha:0.0];
                               [UIView animateWithDuration:0.3 animations:^{
                                   [cell.mImage setAlpha:1.0];
                               }];
                           }
                       }];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderModel" forIndexPath:indexPath];
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ViewModelDetail *v = (ViewModelDetail*)[self.storyboard instantiateViewControllerWithIdentifier:@"ViewModelDetail"];
    NSDictionary *item = [mArrayModels objectAtIndex:indexPath.row];
    NSString *model_id = [item objectForKey:@"model_id"];
    [v setup:model_id];
    [self.navigationController pushViewController:v animated:YES];
}









@end
