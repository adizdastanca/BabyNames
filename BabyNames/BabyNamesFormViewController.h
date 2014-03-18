//
//  BabyNamesFormViewController.h
//  BabyNames
//
//  Created by Adrian on 06/02/2014.
//  Copyright (c) 2014 Adrian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BabyNamesFormViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *first_nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *middle_nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *last_nameTextField;

- (IBAction)cancelButton:(UIButton *)sender;
- (IBAction)saveButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;

@property (strong) NSManagedObject *editName;

@end
