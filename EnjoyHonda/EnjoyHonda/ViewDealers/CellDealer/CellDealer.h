//
//  CellDealer.h
//  EnjoyHonda
//
//  Created by saranpol on 9/26/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface CellDealer : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *mLabelName;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *mLabelEmail;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *mLabelTel;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *mLabelFax;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *mLabelWeb;
@property (nonatomic, weak) IBOutlet UILabel *mLabelAddress;
@property (nonatomic, strong) NSString *mLat;
@property (nonatomic, strong) NSString *mLong;

- (IBAction)clickMap:(id)sender;

@end
