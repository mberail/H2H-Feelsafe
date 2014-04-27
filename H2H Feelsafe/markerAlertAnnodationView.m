//
//  markerAlertAnnodationView.m
//  H2H Feelsafe
//
//  Created by Pierre perrin on 22/04/2014.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import "markerAlertAnnodationView.h"
#import "markerAlert.h"

@implementation markerAlertAnnodationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        markerAlert *alertAnnodation = self.annotation;
        
        switch (alertAnnodation.type)
        {
            case AlertGreen:
            {
                self.image = [UIImage imageNamed:@"marker_ok.png"];
                alertAnnodation.img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 45, 35)];
                //alertAnnodation.img.image = [UIImage imageNamed:@"alert"];
                [self addSubview:alertAnnodation.img];
                break;
            }
               
                
            case AlertOrange:
            {
                self.image = [UIImage imageNamed:@"marker_warning.png"];
                alertAnnodation.img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 45, 35)];
                //imag.image = [UIImage imageNamed:@"no_img.jpg"];
                [self addSubview:alertAnnodation.img];
                break;
                
            }
               
                
            case AlertRed:
            {
                self.image = [UIImage imageNamed:@"marker_alert.png"];
                alertAnnodation.img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 45, 35)];
                //imag.image = [UIImage imageNamed:@"no_img.jpg"];
                [self addSubview:alertAnnodation.img];
                break;
            }
                
        }
       
        
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
