//
//  NSDictionary+ParseJson.m
//  BabyNames
//
//  Created by Adrian on 07/02/2014.
//  Copyright (c) 2014 Adrian. All rights reserved.
//

#import "NSDictionary+ParseJson.h"

@implementation NSDictionary (ParseJson)

-(NSDictionary *) giveMeLocation
{
    NSArray *results = [self valueForKey:@"results"];
    NSDictionary *firstElement = [results objectAtIndex:0];
    NSDictionary *geometry = [firstElement objectForKey:@"geometry"];
    NSDictionary *location = [geometry objectForKey:@"location"];
    
    return location;
}

-(NSNumber *) giveMeLatitude
{
    NSDictionary *location = [self giveMeLocation];
    return [location objectForKey:@"lat"];
}
-(NSNumber *) giveMeLongitude
{
    NSDictionary *location = [self giveMeLocation];
    return [location objectForKey:@"lng"];
}


@end
