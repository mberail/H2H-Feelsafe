//
//  ALAssetViewController.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 27/12/13.
//  Copyright (c) 2013 Maxime Berail. All rights reserved.
//

#import "ALAssetViewController.h"
#import "ALAssetCell.h"

@interface ALAssetViewController ()
{
    NSMutableArray *assets;
}
@end

@implementation ALAssetViewController
@synthesize group;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop)
    {
        if (asset)
        {
            [assets addObject:asset];
        }
    };
    assets = [[NSMutableArray alloc] init];
    [group enumerateAssetsUsingBlock:resultsBlock];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCell" forIndexPath:indexPath];
    cell.picture.image = [UIImage imageWithCGImage:[[assets objectAtIndex:assets.count - indexPath.row - 1] thumbnail]];
    return cell;
}

#pragma mark - CollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    UIImage *picture = [UIImage imageWithCGImage:[[assets objectAtIndex:assets.count - indexPath.row - 1] thumbnail]];
    NSData *picData = UIImagePNGRepresentation(picture);
    [pref setObject:picData forKey:@"picture"];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers indexOfObject:self.navigationController.viewControllers.lastObject] - 2] animated:YES];
}

@end
