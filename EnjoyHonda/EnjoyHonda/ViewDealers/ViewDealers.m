//
//  ViewDealers.m
//  EnjoyHonda
//
//  Created by saranpol on 9/26/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import "ViewDealers.h"
#import "CellDealer.h"
#import "API.h"

@implementation ViewDealers

@synthesize mCollectionView;
@synthesize mArrayDealers;
@synthesize mTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    [self processSearch];
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
    
    [a api_dealer:^(id JSON){
        NSDictionary *json = (NSDictionary*)JSON;
        [a saveObject:json forKey:M_dealers];
        [self processSearch];
    }failure:^(NSError* error){
        NSDictionary *data = [a getObject:M_dealers];
        if(!data)
            [a showPleaseConnectInternet];
    }];
}

- (void)updateUI {
    [mCollectionView reloadData];
}

- (BOOL)containString:(NSString*)s text:(NSString*)text array:(NSMutableArray*)array item:(NSDictionary*)item {
    if([text rangeOfString:s].location != NSNotFound){
        [array addObject:item];
        return YES;
    }
    return NO;
}

- (void)processSearch {
    API *a = [API getAPI];
    NSArray *data = [a getObject:M_dealers];
    if(data){
        if(mTextField.text.length == 0){
            self.mArrayDealers = data;
            [self updateUI];
            return;
        }
        
        NSMutableArray *searchResult = [NSMutableArray new];

        NSString *q = mTextField.text;
        
        
        for(NSDictionary *item in data){
            if([self containString:q text:[a getText:item key:@"NameTh"] array:searchResult item:item])
                continue;
            
            NSString *a1 = [[a getText:item key:@"AddressTh"] stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
            NSString *a2 = [a getText:item key:@"StreetTh"];
            NSString *a3 = [a getText:item key:@"SubDistrictTh"];
            NSString *a4 = [a getText:item key:@"DistrictTh"];
            NSString *a5 = [a getText:item key:@"ProvinceNameTh"];
            NSString *a6 = [a getText:item key:@"Zipcode"];
            NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@", a1, a2, a3, a4, a5, a6];

            if([self containString:q text:address array:searchResult item:item])
                continue;
            
            if([self containString:q text:[a getText:item key:@"Email"] array:searchResult item:item])
                continue;
            if([self containString:q text:[a getText:item key:@"Phone"] array:searchResult item:item])
                continue;
            if([self containString:q text:[a getText:item key:@"Fax"] array:searchResult item:item])
                continue;
            if([self containString:q text:[a getText:item key:@"Website"] array:searchResult item:item])
                continue;
        }
        
        
        
        
        self.mArrayDealers = searchResult;
    }else{
        self.mArrayDealers = nil;
    }
    [self updateUI];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (mArrayDealers) ? [mArrayDealers count] : 0;
}

- (void)setTTTDelegate:(TTTAttributedLabel*)label {
    if(label.delegate != nil)
        return;

    [label setDelegate:self];
    UIColor *c0 = label.textColor;
    UIColor *c1 = [UIColor redColor];
    NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName,(id)kCTUnderlineStyleAttributeName, nil];
    NSArray *objects0 = [[NSArray alloc] initWithObjects:c0, [NSNumber numberWithInt:kCTUnderlineStyleNone], nil];
    NSArray *objects1 = [[NSArray alloc] initWithObjects:c1, [NSNumber numberWithInt:kCTUnderlineStyleNone], nil];
    NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects0 forKeys:keys];
    NSDictionary *activeLinkAttributes = [[NSDictionary alloc] initWithObjects:objects1 forKeys:keys];
    [label setLinkAttributes:linkAttributes];
    [label setActiveLinkAttributes:activeLinkAttributes];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CellDealer *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellDealer" forIndexPath:indexPath];
    
    NSDictionary *item = [mArrayDealers objectAtIndex:indexPath.row];
    
    API *a = [API getAPI];
    [cell.mLabelName setText:[a getText:item key:@"NameTh"]];

    [cell.mLabelEmail setDataDetectorTypes:NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber];
    [cell.mLabelEmail setText:[a getText:item key:@"Email" def:@"-"]];
    [self setTTTDelegate:cell.mLabelEmail];

    [cell.mLabelTel setDataDetectorTypes:NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber];
    [cell.mLabelTel setText:[a getText:item key:@"Phone" def:@"-"]];
    [self setTTTDelegate:cell.mLabelTel];
    
    [cell.mLabelFax setDataDetectorTypes:NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber];
    [cell.mLabelFax setText:[a getText:item key:@"Fax" def:@"-"]];
    [self setTTTDelegate:cell.mLabelFax];

    [cell.mLabelWeb setDataDetectorTypes:NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber];
    [cell.mLabelWeb setText:[a getText:item key:@"Website" def:@"-"]];
    [self setTTTDelegate:cell.mLabelWeb];

    
    NSString *a1 = [[a getText:item key:@"AddressTh"] stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    NSString *a2 = [a getText:item key:@"StreetTh"];
    NSString *a3 = [a getText:item key:@"SubDistrictTh"];
    NSString *a4 = [a getText:item key:@"DistrictTh"];
    NSString *a5 = [a getText:item key:@"ProvinceNameTh"];
    NSString *a6 = [a getText:item key:@"Zipcode"];
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@", a1, a2, a3, a4, a5, a6];
    [cell.mLabelAddress setText:address];
    
    [a loadImage:cell.mImageMap url:[a getText:item key:@"map"]];
    

    cell.mLat = [a getText:item key:@"Latitude"];
    cell.mLong = [a getText:item key:@"Longtitude"];
    
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderDealer" forIndexPath:indexPath];
//    return cell;
//}



- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    NSString *s = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"Tel:" withString:@""];
    NSString *p = [@"telprompt://" stringByAppendingString:s];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:p]];
}

- (IBAction)searchTextChanged:(id)sender {
    [self processSearch];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [mTextField resignFirstResponder];
}

- (IBAction)clickSearch:(id)sender {
    [mTextField resignFirstResponder];
}

@end
