//
//  ForcastData.m
//  Weather App
//
//  Created by Ashish kumar on 7/21/17.
//  Copyright © 2017 Ashish kumar. All rights reserved.
//

#import "ForcastData.h"

@implementation ForcastData


- (id)initWithDictionary:(NSDictionary*)dict description:(NSDictionary*)sdict {
    if ((self = [super init]))
    {
        @try {
            NSString *Weekday=[dict[@"date"] objectForKey:@"weekday"];
            NSDictionary *sampleDict=[sdict objectForKey:Weekday];
            self.title=[dict[@"date"] objectForKey:@"pretty"];
            self.highTemp=[dict[@"high"] objectForKey:@"fahrenheit"];
            self.LowTemp=[dict[@"low"] objectForKey:@"fahrenheit"];
            self.imageUrl=dict[@"icon_url"];
            self.forcastDescription=sampleDict[@"fcttext_metric"];

        }
        @catch (NSException *exception) {
            //Handle an exception thrown in the @try block
        }
        @finally {
            //  Code that gets executed whether or not an exception is thrown
        }
        
    }
    
    return self;
}


@end
