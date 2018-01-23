//
//  RegisterViewController.h
//  DiagramEditor
//
//  Created by MISO on 22/1/18.
//  Copyright © 2018 Diego Vaquero Melchor. All rights reserved.
//

#ifndef RegisterViewController_h
#define RegisterViewController_h

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *surnameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (nonatomic) NSString *role;

@end

#endif /* RegisterViewController_h */
