//
//  ForcastData.h
//  Weather App
//
//  Created by Ashish kumar on 7/21/17.
//  Copyright © 2017 Ashish kumar . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForcastData : NSObject
@property (nonatomic,retain)NSString *imageUrl;
@property (nonatomic,retain)NSString *highTemp;
@property (nonatomic,retain)NSString *LowTemp;
@property (nonatomic,retain)NSString *title;
@property (nonatomic,retain)NSString *forcastDescription;
- (id)initWithDictionary:(NSDictionary*)dict description:(NSDictionary*)sdict;
@end
