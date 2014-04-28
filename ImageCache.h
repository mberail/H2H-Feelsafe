//
//  ImageCache.h
//  H2H Feelsafe
//
//  Created by Maxime Berail on 28/04/14.
//  Copyright (c) 2014 Maxime Berail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

@property (nonatomic, retain) NSCache *imgCache;

+ (ImageCache*)sharedImageCache;
- (void)addImage:(NSString *)imageURL with:(UIImage *)image;
- (UIImage*)getImage:(NSString *)imageURL;
- (BOOL)doesExist:(NSString *)imageURL;

@end
