//
//  NSDictionary+ServerActions.m
//  BabyNames
//
//  Created by Adrian on 18/02/2014.
//  Copyright (c) 2014 Adrian. All rights reserved.
//

#import "NSDictionary+ServerActions.h"
#import "AFHTTPRequestOperationManager.h"

@implementation NSDictionary (ServerActions)

-(NSDictionary *) getResults:(NSManagedObject *)databaseRecord
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://mas-web.co.uk/webservices/user.php?user=adrian" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

@end
