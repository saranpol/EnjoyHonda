//
//  CellDealer.m
//  EnjoyHonda
//
//  Created by saranpol on 9/26/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import "CellDealer.h"
#import <MapKit/MapKit.h>

@implementation CellDealer

@synthesize mLabelName;
@synthesize mLabelEmail;
@synthesize mLabelTel;
@synthesize mLabelFax;
@synthesize mLabelWeb;
@synthesize mLabelAddress;
@synthesize mImageMap;
@synthesize mLat;
@synthesize mLong;

- (IBAction)clickMap:(id)sender {
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([mLat doubleValue], [mLong doubleValue]);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:mLabelName.text];
        
        [mapItem openInMapsWithLaunchOptions:nil];
        
//        // Set the directions mode to "Walking"
//        // Can use MKLaunchOptionsDirectionsModeDriving instead
//        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
//        // Get the "Current User Location" MKMapItem
//        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
//        // Pass the current location and destination map items to the Maps app
//        // Set the direction mode in the launchOptions dictionary
//        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
//                       launchOptions:launchOptions];
    }
}

@end
