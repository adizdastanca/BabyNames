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

@synthesize title;

@synthesize detailName;

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
    
    [self.title setText:[NSString stringWithFormat:@"%@ %@ %@",
                         [self.detailName valueForKey:@"first_name"],
                         [self.detailName valueForKey:@"middle_name"],
                         [self.detailName valueForKey:@"last_name"]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.detailName) {
        NSLog(@"%@", [self.detailName valueForKey:@"first_name"]);
        NSLog(@"%@", [self.detailName valueForKey:@"middle_name"]);
        NSLog(@"%@", [self.detailName valueForKey:@"last_name"]);
        
        [self.title setText:[NSString stringWithFormat:@"%@ %@ %@",
                             [self.detailName valueForKey:@"first_name"],
                             [self.detailName valueForKey:@"middle_name"],
                             [self.detailName valueForKey:@"last_name"]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
