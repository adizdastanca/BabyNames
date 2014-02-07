//
//  BabyNamesFormViewController.m
//  BabyNames
//
//  Created by Adrian on 06/02/2014.
//  Copyright (c) 2014 Adrian. All rights reserved.
//

#import "BabyNamesFormViewController.h"

@interface BabyNamesFormViewController ()

@end

@implementation BabyNamesFormViewController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    NSLog(@"cancel pressed:");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)save:(UIBarButtonItem *)sender {
    NSLog(@"save pressed:");
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"People" inManagedObjectContext:context];
    [newDevice setValue:self.first_nameTextField.text forKey:@"first_name"];
    [newDevice setValue:self.last_nameTextField.text forKey:@"last_name"];
    [newDevice setValue:self.nameTextField.text forKey:@"name"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


/*
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
 */

/*
- (IBAction)save:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"People" inManagedObjectContext:context];
    [newDevice setValue:self.first_nameTextField.text forKey:@"first_name"];
    [newDevice setValue:self.last_nameTextField.text forKey:@"last_name"];
    [newDevice setValue:self.nameTextField.text forKey:@"name"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
 */


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
