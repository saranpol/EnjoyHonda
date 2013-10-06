//
//  ViewDealers.h
//  EnjoyHonda
//
//  Created by saranpol on 9/26/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface ViewDealers : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, TTTAttributedLabelDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *mCollectionView;
@property (nonatomic, strong) NSArray *mArrayDealers;


@end
