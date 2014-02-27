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
        
        [self hideVoteButtonOnceVoted];
        
        NSLog(@"%@", [self.detailName valueForKey:@"first_name"]);
        NSLog(@"%@", [self.detailName valueForKey:@"middle_name"]);
        NSLog(@"%@", [self.detailName valueForKey:@"last_name"]);
        NSLog(@"%@", [self.detailName valueForKey:@"updated_at"]);
        NSLog(@"%@", [self.detailName valueForKey:@"user_id"]);
        NSLog(@"%@", [self.detailName valueForKey:@"old_votes"]);
        NSLog(@"%@", [self.detailName valueForKey:@"votes"]);
        
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
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSString *noVotes = [self.detailName valueForKey:@"votes"];
    int myVotes = [noVotes intValue];
    myVotes = myVotes + 1;
    
    //save vote to local db
    id votesConvertedFromIntToId = [NSNumber numberWithInteger:myVotes];
    [self.detailName setValue:votesConvertedFromIntToId forKey:@"votes"];
    
    //save updated_At to local db
    NSDate *now = [[NSDate alloc] init];
    [self.detailName setValue:now forKey:@"updated_at"];
    
    [self.detailName setValue:[NSNumber numberWithBool:YES] forKey:@"already_voted"];
    
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    //end save to database
    
    [self.numberOfVotes setText:[NSString stringWithFormat:@"%d", myVotes]];
    
    [self hideVoteButtonOnceVoted];
    
}

-(void) hideVoteButtonOnceVoted
{
    
    NSString *alreadyVotedString = [self.detailName valueForKey:@"already_voted"];
    BOOL alreadyVoted = [alreadyVotedString boolValue];
    
    NSLog(@"%hhd", alreadyVoted);
    
    if (alreadyVoted) {
        self.detailVoteButton.hidden = YES;
    } else {
        self.detailVoteButton.hidden = NO;
    }

}
@end
