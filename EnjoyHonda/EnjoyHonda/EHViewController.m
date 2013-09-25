//
//  EHViewController.m
//  EnjoyHonda
//
//  Created by saranpol on 9/25/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import "EHViewController.h"
#import "CellMenu.h"
#import "ViewModels.h"
#import "ViewDealers.h"

@implementation EHViewController

@synthesize mCollectionMenu;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CellMenu *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellMenu" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            [cell.mLabelName setText:@"Models"];
            break;
        case 1:
            [cell.mLabelName setText:@"Dealers"];
            break;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            ViewModels *v = (ViewModels*)[self.storyboard instantiateViewControllerWithIdentifier:@"ViewModels"];
            [self.navigationController pushViewController:v animated:YES];
            break;
        }
        case 1: {
            ViewDealers *v = (ViewDealers*)[self.storyboard instantiateViewControllerWithIdentifier:@"ViewDealers"];
            [self.navigationController pushViewController:v animated:YES];
            break;
        }
    }
}


- (IBAction)clickMenu:(id)sender {
    if(mCollectionMenu.hidden){
        [mCollectionMenu setHidden:NO];
        CGRect f = mCollectionMenu.frame;
        f.origin.y = -f.size.height;
        mCollectionMenu.frame = f;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = mCollectionMenu.frame;
            f.origin.y = 0;
            mCollectionMenu.frame = f;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = mCollectionMenu.frame;
            f.origin.y = -f.size.height;
            mCollectionMenu.frame = f;
        }completion:^(BOOL finished){
            if(finished){
                [mCollectionMenu setHidden:YES];
            }
        }];
    }
}

@end
