//
//  ViewModelDetail.m
//  EnjoyHonda
//
//  Created by saranpol on 9/26/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import "ViewModelDetail.h"
#import "CellModelHeader.h"
#import "CellModelTitle.h"
#import "CellModelPrice.h"
#import "CellModelRemark.h"
#import "CellModelFeature.h"
#import "CellModelSeparator.h"
#import "CellBrochure.h"
#import "CellSpec.h"
#import "API.h"
#import "AlignWithTopFlowLayout.h"

@implementation ViewModelDetail

@synthesize mCollectionView;
@synthesize mData;
@synthesize mModelID;


- (void)setup:(NSString*)model_id {
    self.mModelID = model_id;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    API *a = [API getAPI];
    if(a.mIsTablet){
        AlignWithTopFlowLayout *layout = [[AlignWithTopFlowLayout alloc] init];
        layout.minimumLineSpacing = 2.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.itemSize = CGSizeMake(300, 300);
        layout.headerReferenceSize = CGSizeMake(1004, 47);
        layout.footerReferenceSize = CGSizeMake(50, 50);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [mCollectionView setCollectionViewLayout:layout animated:NO];
    }
    
    [self updateUI];
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

- (NSString*)getModelKey {
    return [M_model stringByAppendingString:mModelID];
}

- (void)updateData {
    API *a = [API getAPI];
    
    [a api_model:mModelID
         success:^(id JSON){
             NSDictionary *json = (NSDictionary*)JSON;
             [a saveObject:json forKey:[self getModelKey]];
             [self updateUI];
         }failure:^(NSError* error){
         }];
}

- (void)updateUI {
    API *a = [API getAPI];
    NSDictionary *data = [a getObject:[self getModelKey]];
    if(data){
        self.mData = data;
        [mCollectionView reloadData];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(!mData)
        return 0;
    
    NSArray *price_list = [mData objectForKey:@"price_list"];
    NSArray *feature_list = [mData objectForKey:@"feature_list"];
    
    return 1 + [price_list count] + 1 + [feature_list count] + 1 + 1 + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger i = indexPath.row;
    API *a = [API getAPI];
    
    if(i == 0){
        CellModelTitle *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellModelTitle" forIndexPath:indexPath];
        [a loadImage:cell.mImage url:[a getText:mData key:@"keyvisual_url"]];
        [cell.mLabelName setText:[a getText:mData key:@"title_th"]];
        [cell.mLabelTitle setText:[a getText:mData key:@"sub_title_th"]];
        [cell.mLabelDescription setText:[a getText:mData key:@"description"]];
        return cell;
    }

    NSArray *price_list = [mData objectForKey:@"price_list"];
    NSArray *feature_list = [mData objectForKey:@"feature_list"];
    
    if(i < 1 + [price_list count]){
        NSInteger j = i - 1;
        CellModelPrice *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellModelPrice" forIndexPath:indexPath];
        NSDictionary *price = [price_list objectAtIndex:j];
        [cell.mLabelLabel setText:[a getText:price key:@"label"]];
        [cell.mLabelValue setText:[a getText:price key:@"value"]];
        return cell;
    }

    if(i < 1 + [price_list count] + 1){
        CellModelRemark *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellModelRemark" forIndexPath:indexPath];
        return cell;
    }

    if(i < 1 + [price_list count] + 1 + [feature_list count]){
        NSInteger j = i - 1 - [price_list count] - 1;
        CellModelFeature *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellModelFeature" forIndexPath:indexPath];
        NSDictionary *feature = [feature_list objectAtIndex:j];
        
        [a loadImage:cell.mImage url:[a getText:feature key:@"image"]];
        [cell.mLabelName setText:[a getText:feature key:@"title"]];
        [cell.mLabelDescription setText:[a getText:feature key:@"description"]];
        return cell;
    }

    if(i < 1 + [price_list count] + 1 + [feature_list count] + 1){
        CellModelSeparator *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellModelSeparator" forIndexPath:indexPath];
        return cell;
    }
    
    if(i < 1 + [price_list count] + 1 + [feature_list count] + 1 + 1){
        CellBrochure *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellBrochure" forIndexPath:indexPath];
        return cell;
    }

    if(i < 1 + [price_list count] + 1 + [feature_list count] + 1 + 1 + 1){
        CellSpec *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellSpec" forIndexPath:indexPath];
        return cell;
    }

    return nil;
}




- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger i = indexPath.row;
    API *a = [API getAPI];
    if(i == 0){
        if(a.mIsTablet){
            CGFloat h = [a getHeightOfFont:[UIFont systemFontOfSize:16.0] w:974 text:[a getText:mData key:@"description"]];
            return CGSizeMake(984, 456 + h + 28);
        }else{
            CGFloat h = [a getHeightOfFont:[UIFont systemFontOfSize:14.0] w:276 text:[a getText:mData key:@"description"]];
            return CGSizeMake(286, 169 + h);
            
        }
    }
    
    NSArray *price_list = [mData objectForKey:@"price_list"];
    NSArray *feature_list = [mData objectForKey:@"feature_list"];
    
    if(i < 1 + [price_list count]){
        //CellModelPrice
        if(a.mIsTablet){
            if(i == 1 + [price_list count] - 1){
                NSUInteger c = [price_list count];
                if((c%3) == 1)
                    return CGSizeMake(984, 40);
                if((c%3) == 2)
                    return CGSizeMake(635, 40);
            }
            return CGSizeMake(286, 40);
        }else{
            return CGSizeMake(286, 40);
        }
    }
    
    if(i < 1 + [price_list count] + 1){
        //CellModelRemark
        if(a.mIsTablet){
            return CGSizeMake(974, 70);
        }else{
            return CGSizeMake(286, 70);
        }
    }
    
    if(i < 1 + [price_list count] + 1 + [feature_list count]){
        float w = 286;
        float y = 202;
        if(a.mIsTablet){
            w = 300;
            y = 209;
            if(i == 1 + [price_list count] + 1 + [feature_list count] - 1){
                NSUInteger c = [feature_list count];
                if((c%3) == 1)
                    w = 984;
                if((c%3) == 2)
                    w = 655;
            }
        }
        
        //CellModelFeature
        NSInteger j = i - 1 - [price_list count] - 1;
        NSDictionary *feature = [feature_list objectAtIndex:j];
        CGFloat h = [a getHeightOfFont:[UIFont systemFontOfSize:14.0] w:276 text:[a getText:feature key:@"description"]];
        return CGSizeMake(w, y + h + 24);
    }
    
    if(i < 1 + [price_list count] + 1 + [feature_list count] + 1){
        // CellModelSeparator
        if(a.mIsTablet){
            return CGSizeMake(974, 36);
        }else{
            return CGSizeMake(286, 36);
        }
    }
    
    if(i < 1 + [price_list count] + 1 + [feature_list count] + 1 + 1){
        return CGSizeMake(286, 140);
    }
    
    if(i < 1 + [price_list count] + 1 + [feature_list count] + 1 + 1 + 1){
        return CGSizeMake(286, 140);
    }

    return CGSizeMake(286, 140);
}






- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    API *a = [API getAPI];
    if(kind == UICollectionElementKindSectionHeader){
        CellModelHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderModelDetail" forIndexPath:indexPath];
        if(mData)
            [cell.mLabelName setText:[NSString stringWithFormat:@"MODELS / %@", [a getText:mData key:@"name"]]];
        else
            [cell.mLabelName setText:@"LOADING..."];
        return cell;
    }else{
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterModelDetail" forIndexPath:indexPath];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    API *a = [API getAPI];
    
    NSInteger i = indexPath.row;
    NSArray *price_list = [mData objectForKey:@"price_list"];
    NSArray *feature_list = [mData objectForKey:@"feature_list"];

    if(i < 1 + [price_list count] + 1 + [feature_list count]){
        return;
    }
    
    if(i < 1 + [price_list count] + 1 + [feature_list count] + 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[a getText:mData key:@"brochure_url"]]];
    }
    
    if(i < 1 + [price_list count] + 1 + [feature_list count] + 1 + 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[a getText:mData key:@"spec_url"]]];
    }
    
}


@end

