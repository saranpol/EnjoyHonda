//
//  CellMenu.m
//  EnjoyHonda
//
//  Created by saranpol on 9/25/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import "CellMenu.h"

@implementation CellMenu

@synthesize mLabelName;
@synthesize mViewHighlight;

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];

    float a = (highlighted) ? 0.3 : 0.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [mViewHighlight setAlpha:a];
    }];
}

@end
