//
//  ViewModelDetail.h
//  EnjoyHonda
//
//  Created by saranpol on 9/26/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewModelDetail : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *mCollectionView;
@property (nonatomic, strong) NSDictionary *mData;
@property (nonatomic, strong) NSString *mModelID;

- (void)setup:(NSString*)model_id;



@end
