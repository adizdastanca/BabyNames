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

-(NSDictionary *)getResults:(NSManagedObject *)databaseRecord :(NSManagedObjectContext *)context
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://mas-web.co.uk/webservices/user.php?user=adrian" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        
        
        [self clearLocalDatabase:@"People" :context];
        NSArray *results = [responseObject valueForKey:@"users"];
        for (int i = 0; i < [results count]; i++) {
            NSDictionary *item = [results objectAtIndex:i];
            [self saveNewRecord:databaseRecord :item :context];
        }
        
        [self saveOnServer];
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    return nil;
}

-(NSDictionary *)saveOnServer
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"votes": @"100", @"user_id": @"1"};
    [manager POST:@"http://mas-web.co.uk/webservices/user.php?user=adrian" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    return nil;
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"observe here");
//    if ([keyPath isEqual:@"latitude"]) {
//        self.latitude.text=[[self.person valueForKey:@"latitude"] stringValue];
//    }
}

-(NSString *) firstName:(NSDictionary *)jsonObject
{
    return [jsonObject valueForKey:@"first_name"];
}
-(NSString *) middleName:(NSDictionary *)jsonObject
{
    return [jsonObject valueForKey:@"middle_name"];
}
-(NSString *) lastName:(NSDictionary *)jsonObject
{
    return [jsonObject valueForKey:@"last_name"];
}
-(NSNumber *) noOfVotes:(NSDictionary *)jsonObject
{
    NSString *numberofVotes = [jsonObject valueForKey:@"number_of_votes"];
    return [NSNumber numberWithInt:[numberofVotes intValue]];
}
-(void) saveNewRecord :(NSManagedObject *)databaseRecord :(NSDictionary *)newItem :(NSManagedObjectContext *)context
{
    [databaseRecord setValue:[self firstName:newItem] forKey:@"first_name"];
    [databaseRecord setValue:[self middleName:newItem] forKey:@"middle_name"];
    [databaseRecord setValue:[self lastName:newItem] forKey:@"last_name"];
    [databaseRecord setValue:[self noOfVotes:newItem] forKey:@"votes"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    NSLog(@"SAVED!!!");

}
-(void) clearLocalDatabase :(NSString *)entityDescription :(NSManagedObjectContext *)context
{
    NSLog(@"CLEAR DATABASE");
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([items count]) {
        for (NSManagedObject *managedObject in items) {
            [context deleteObject:managedObject];
            NSLog(@"%@ object deleted",entityDescription);
        }
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }

    }

}

@end
