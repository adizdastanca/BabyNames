//
//  BabyNamesDetailViewController.m
//  BabyNames
//
//  Created by Adrian on 11/02/2014.
//  Copyright (c) 2014 Adrian. All rights reserved.
//

#import "BabyNamesDetailViewController.h"
#import "BabyNamesFormViewController.h"

@interface BabyNamesDetailViewController ()

@end

@implementation BabyNamesDetailViewController

@synthesize nameTitle;
@synthesize numberOfVotes;

@synthesize detailName;

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"UpdateName"]) {
        BabyNamesFormViewController *formViewController = segue.destinationViewController;
        formViewController.editName = self.detailName;
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.nameTitle setText:[NSString stringWithFormat:@"%@ %@ %@",
                         [self.detailName valueForKey:@"first_name"],
                         [self.detailName valueForKey:@"middle_name"],
                         [self.detailName valueForKey:@"last_name"]]];

    [self.numberOfVotes setText:[NSString stringWithFormat:@"%@",
                                 [self.detailName valueForKey:@"votes"]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.detailName) {
        NSLog(@"%@", [self.detailName valueForKey:@"first_name"]);
        NSLog(@"%@", [self.detailName valueForKey:@"middle_name"]);
        NSLog(@"%@", [self.detailName valueForKey:@"last_name"]);
        
        [self.nameTitle setText:[NSString stringWithFormat:@"%@ %@ %@",
                             [self.detailName valueForKey:@"first_name"],
                             [self.detailName valueForKey:@"middle_name"],
                             [self.detailName valueForKey:@"last_name"]]];
        [self.numberOfVotes setText:[NSString stringWithFormat:@"%@",
                                     [self.detailName valueForKey:@"votes"]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)voteButton:(UIButton *)sender
{
    NSString *noVotes = [self.detailName valueForKey:@"votes"];

    int myVotes = [noVotes intValue];
    myVotes = myVotes + 1;
    
    //save to database
    id votesConvertedFromIntToId = [NSNumber numberWithInteger:myVotes];
    [self.detailName setValue:votesConvertedFromIntToId forKey:@"votes"];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    //end save to database
    
    [self.numberOfVotes setText:[NSString stringWithFormat:@"%d", myVotes]];
    
}
@end
