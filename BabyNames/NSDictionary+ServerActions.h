//
//  NSDictionary+ServerActions.h
//  BabyNames
//
//  Created by Adrian on 18/02/2014.
//  Copyright (c) 2014 Adrian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ServerActions)

-(NSDictionary *) getResults :(NSManagedObject *)databaseRecord;

-(NSDictionary *) saveOnServer;

@end
