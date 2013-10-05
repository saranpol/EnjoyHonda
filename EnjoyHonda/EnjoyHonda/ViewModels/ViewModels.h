//
//  ViewModels.h
//  EnjoyHonda
//
//  Created by saranpol on 9/26/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewModels : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *mCollectionView;
@property (nonatomic, strong) NSArray *mArrayModels;

@end
