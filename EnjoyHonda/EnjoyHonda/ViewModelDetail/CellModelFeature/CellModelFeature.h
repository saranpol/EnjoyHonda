//
//  CellModelFeature.h
//  EnjoyHonda
//
//  Created by saranpol on 9/27/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellModelFeature : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *mImage;
@property (nonatomic, weak) IBOutlet UILabel *mLabelName;
@property (nonatomic, weak) IBOutlet UILabel *mLabelDescription;


@end
