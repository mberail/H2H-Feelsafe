//
//  ALGroupViewController.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 27/12/13.
//  Copyright (c) 2013 Maxime Berail. All rights reserved.
//

#import "ALGroupViewController.h"
#import "ALGroupCell.h"
#import "ALAssetViewController.h"

@interface ALGroupViewController ()
{
    ALAssetsLibrary *assetsLibrary;
    NSMutableArray *groups;
}
@end

@implementation ALGroupViewController

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
	[self loadGroups];
    self.navigationItem.title = @"Albums";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)loadGroups
{
    if (!assetsLibrary)
    {assetsLibrary = [[ALAssetsLibrary alloc] init];}
    if (!groups)
    {groups = [[NSMutableArray alloc] init];}
    else
    {[groups removeAllObjects];}
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if(group)
        {[groups addObject:group];}
        [self.tableView reloadData];
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
    {
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    NSUInteger groupTypes = ALAssetsGroupAll;
    [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALGroupCell *cell = (ALGroupCell *)[tableView dequeueReusableCellWithIdentifier:@"ALGroupCell"];
    if (cell == nil)
    {
        cell = [[ALGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ALGroupCell"];
    }
    cell.picture.image = [UIImage imageWithCGImage:[[groups objectAtIndex:indexPath.row] posterImage]];
    cell.description.text = [[groups objectAtIndex:indexPath.row] valueForProperty:ALAssetsGroupPropertyName];
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup *group = [groups objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ALAssetViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ALAssetViewController"];
    vc.group = group;
    vc.navigationItem.title = [[groups objectAtIndex:indexPath.row] valueForProperty:ALAssetsGroupPropertyName];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
