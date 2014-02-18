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
        NSArray *results = [responseObject valueForKey:@"users"];
        NSLog(@"ARRAY: %@", results);
        NSLog(@"%d", [results count]);
        for (int i = 0; i < [results count]; i++) {
            NSDictionary *item = [results objectAtIndex:i];
            NSString *first_name = [self getFirstName:item];
            NSLog(@"%@", first_name);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    return nil;
}

-(NSDictionary *) getFirstName:(NSDictionary *)jsonObject
{
    return [jsonObject valueForKey:@"first_name"];
}
-(void) saveNewRecord :(NSManagedObject *)databaseRecord :(NSDictionary *)newItem
{
//    [newName setValue:self.first_nameTextField.text forKey:@"first_name"];
//    [newName setValue:self.middle_nameTextField.text forKey:@"middle_name"];
//    [newName setValue:self.last_nameTextField.text forKey:@"last_name"];
}

@end
