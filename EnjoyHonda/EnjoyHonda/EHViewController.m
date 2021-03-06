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
@synthesize mImagePopupMenu;
@synthesize mWillSaveImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
 
    [mCollectionMenu setHidden:YES];
    
    self.mImagePopupMenu = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_menu.png"]];
    CGRect r = mImagePopupMenu.frame;
    r.origin.x = 10;
    r.origin.y = 30;
    [mImagePopupMenu setFrame:r];
    [self.navigationController.view addSubview:mImagePopupMenu];
    
    
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
        NSDictionary *data = [a getObject:M_hilight];
        if(!data)
            [a showPleaseConnectInternet];
    }];

}

- (void)updateUI {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateUI) object:nil];
    if(mWillSaveImage)
        return;
    
    API *a = [API getAPI];
    NSDictionary *data = [a getObject:M_hilight];
    if(data){
        NSArray *hilight = [data objectForKey:@"hilight"];
        if(hilight){
            if(mCountHilight >= (int)[hilight count])
                self.mCountHilight = 0;
            if(mCountHilight < 0)
                self.mCountHilight = [hilight count] - 1;
            
            NSDictionary *item = [hilight objectAtIndex:mCountHilight];
            NSString *image = [item objectForKey:@"image"];
            
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
    if(![mImagePopupMenu isHidden]){
        [UIView animateWithDuration:0.5 animations:^{
            [mImagePopupMenu setAlpha:0];
        }completion:^(BOOL finished){
            [mImagePopupMenu setHidden:YES];
        }];
    }
         
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


- (IBAction)clickImage:(id)sender {
    UILongPressGestureRecognizer *g = (UILongPressGestureRecognizer*)sender;
    if(g.state == UIGestureRecognizerStateBegan){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Save Photo", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
        self.mWillSaveImage = YES;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        UIImageWriteToSavedPhotosAlbum(mImageHilight.image, nil, nil, nil);
    }
    self.mWillSaveImage = NO;
    [self performSelector:@selector(updateUI) withObject:nil afterDelay:3.0];
}

- (IBAction)swipeImageRight:(id)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateUI) object:nil];
    mCountHilight--;
    mCountHilight--;
    [self updateUI];
}

- (IBAction)swipeImageLeft:(id)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateUI) object:nil];
    [self updateUI];
}


@end
