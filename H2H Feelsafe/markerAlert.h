//
//  markerAlert.h
//  H2H Feelsafe
//
//  Created by Pierre perrin on 22/04/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, AlertType) {
    AlertGreen,
    AlertOrange,
    AlertRed
};

@interface markerAlert : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic) AlertType type;
@property (nonatomic) UIImageView *img;

@end