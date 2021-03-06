//
//  EHViewController.h
//  EnjoyHonda
//
//  Created by saranpol on 9/25/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *mCollectionMenu;
@property (nonatomic, weak) IBOutlet UIImageView *mImageHilight;
@property (nonatomic, assign) NSInteger mCountHilight;
@property (nonatomic, strong) UIImageView *mImagePopupMenu;
@property (nonatomic, assign) BOOL mWillSaveImage;

- (IBAction)clickMenu:(id)sender;
- (IBAction)clickImage:(id)sender;
- (IBAction)swipeImageRight:(id)sender;
- (IBAction)swipeImageLeft:(id)sender;

@end
