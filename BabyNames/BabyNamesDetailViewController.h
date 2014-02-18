//
//  BabyNamesDetailViewController.h
//  BabyNames
//
//  Created by Adrian on 11/02/2014.
//  Copyright (c) 2014 Adrian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BabyNamesDetailViewController : UIViewController

- (IBAction)voteButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UILabel *numberOfVotes;


@property (strong) NSManagedObject *detailName;


@end
