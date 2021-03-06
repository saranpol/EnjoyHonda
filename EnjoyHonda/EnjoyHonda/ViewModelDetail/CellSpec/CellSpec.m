//
//  CellSpec.m
//  EnjoyHonda
//
//  Created by saranpol on 9/26/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import "CellSpec.h"

@implementation CellSpec

@synthesize mViewHighlight;
@synthesize mImage;

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    float a = (highlighted) ? 0.3 : 0.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [mViewHighlight setAlpha:a];
    }];
}

@end
