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
#import "API.h"
#import "UIImageView+WebCache.h"

@implementation EHViewController

@synthesize mCollectionMenu;
@synthesize mImageHilight;
@synthesize mCountHilight;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
 
    [mCollectionMenu setHidden:YES];
    
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
    
    [a api_hilight:^(id JSON){
        NSDictionary *json = (NSDictionary*)JSON;
        [a saveObject:json forKey:M_hilight];
        [self updateUI];
    }failure:^(NSError* error){
    }];

}

- (void)updateUI {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateUI) object:nil];
    
    API *a = [API getAPI];
    NSDictionary *data = [a getObject:M_hilight];
    if(data){
        NSArray *hilight = [data objectForKey:@"hilight"];
        if(hilight){
            if(mCountHilight >= [hilight count])
                self.mCountHilight = 0;
            
            NSDictionary *item = [hilight objectAtIndex:mCountHilight];
            NSString *image = [item objectForKey:@"image_mobile"];
            
            [mImageHilight setImageWithURL:[NSURL URLWithString:image]
                          placeholderImage:mImageHilight.image
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                                     if(image){
                                         [UIView transitionWithView:mImageHilight
                                                           duration:1.0f
                                                            options:UIViewAnimationOptionTransitionCrossDissolve
                                                         animations:^{
                                                             mImageHilight.image = image;
                                                         } completion:^(BOOL finished){
                                                             mCountHilight++;
                                                             [self performSelector:@selector(updateUI) withObject:nil afterDelay:3.0];
                                                         }];
                                     }
                                 }];
        }
        
    }
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
