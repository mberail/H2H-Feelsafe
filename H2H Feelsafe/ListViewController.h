//
//  ListViewController.h
//  H2H Feelsafe
//
//  Created by Maxime Berail on 02/01/14.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *mapSearchBar;
@property (weak, nonatomic) IBOutlet UIView *mapSuperView;
@property (weak, nonatomic) IBOutlet UIView *listSuperView;

- (IBAction)changeInterface:(id)sender;
@end
