//
//  NSDictionary+ServerActions.m
//  BabyNames
//
//  Created by Adrian on 18/02/2014.
//  Copyright (c) 2014 Adrian. All rights reserved.
//

#import "NSDictionary+ServerActions.h"
#import "AFHTTPRequestOperationManager.h"
#import "BabyNamesViewController.h"

@implementation NSDictionary (ServerActions)

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(NSDictionary *)getResults
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://mas-web.co.uk/webservices/user.php?user=adrian" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        
        NSLog(@"%@", responseObject);
//        NSManagedObjectContext *newContext = [self managedObjectContext];
        [self clearLocalDatabase:@"People"];
        NSArray *results = [responseObject valueForKey:@"users"];
        for (int i = 0; i < [results count]; i++) {
            NSDictionary *item = [results objectAtIndex:i];
            [self saveNewRecord :item];
        }
        
//        [self saveOnServer];
        [self populateNamesList];
        NSLog(@"getResuts METHOD");
        
        
        
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
-(void) saveNewRecord :(NSDictionary *)newItem
{
    NSManagedObjectContext *newContext = [self managedObjectContext];
    NSManagedObject *databaseRecord = [NSEntityDescription insertNewObjectForEntityForName:@"People"
                                                                    inManagedObjectContext:newContext];
    
    [databaseRecord setValue:[self firstName:newItem] forKey:@"first_name"];
    [databaseRecord setValue:[self middleName:newItem] forKey:@"middle_name"];
    [databaseRecord setValue:[self lastName:newItem] forKey:@"last_name"];
    [databaseRecord setValue:[self noOfVotes:newItem] forKey:@"votes"];
    
    /*
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    [databaseRecord setValue:dateFormatter forKey:@"updated_at"];
     */
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![newContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    NSLog(@"SAVED!!!");

}
-(void) clearLocalDatabase :(NSString *)entityDescription
{
    NSLog(@"CLEAR DATABASE");
    
    NSManagedObjectContext *newContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:newContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [newContext executeFetchRequest:fetchRequest error:&error];
    
    if ([items count]) {
        for (NSManagedObject *managedObject in items) {
            [newContext deleteObject:managedObject];
            NSLog(@"%@ object deleted",entityDescription);
        }
        if (![newContext save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }

    }

}

-(void) populateNamesList
{
    BabyNamesViewController *myNamesList = [[BabyNamesViewController alloc] init];
    [myNamesList displayNamesList];
}

@end
