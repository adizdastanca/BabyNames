//
//  BabyNamesFormViewController.m
//  BabyNames
//
//  Created by Adrian on 06/02/2014.
//  Copyright (c) 2014 Adrian. All rights reserved.
//

#import "BabyNamesFormViewController.h"
#import "AppDelegate.h"

@interface BabyNamesFormViewController ()
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSManagedObject *person;

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
    //NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    [self.person setValue:self.first_nameTextField.text forKey:@"first_name"];
    [self.person setValue:self.last_nameTextField.text forKey:@"last_name"];
    [self.person setValue:self.nameTextField.text forKey:@"name"];
    
    [self.context save:nil];
    
    //populate latitude and longitude
    NSManagedObjectID *mid = [self.person objectID];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Now I am on a different thread
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        context.persistentStoreCoordinator = [appDelegate persistentStoreCoordinator];
        NSLog(@"test");
        NSManagedObject *baby = [context objectWithID:mid];
        [baby setValue:@123 forKey:@"latitude"];
        [baby setValue:@987 forKey:@"longitude"];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"error: %@", error);
        }
        //[context save:nil];
    });
    
    /*
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
     */
    
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"observe here");
    if ([keyPath isEqual:@"latitude"]) {
        self.latitude.text=[[self.person valueForKey:@"latitude"] stringValue];
    }
    if ([keyPath isEqual:@"longitude"]) {
        self.longitude.text=[[self.person valueForKey:@"longitude"] stringValue];
    }
}

-(void) dealloc
{
    [self.person removeObserver:self forKeyPath:@"latitude"];
    [self.person removeObserver:self forKeyPath:@"longitude"];
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
    id delegate = [[UIApplication sharedApplication] delegate];
    self.context = [delegate performSelector:@selector(managedObjectContext)];
    self.person = [NSEntityDescription insertNewObjectForEntityForName:@"People" inManagedObjectContext:self.context];
    [self.person addObserver:self forKeyPath:@"latitude" options:NSKeyValueObservingOptionNew context:nil];
    [self.person addObserver:self forKeyPath:@"longitude" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
