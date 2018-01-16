//
//  LoginViewController.m
//  DiagramEditor
//
//  Created by MISO on 10/1/18.
//  Copyright © 2018 Diego Vaquero Melchor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "ConfigureDiagramViewController.h"

@interface LoginViewController ()

@end


@implementation LoginViewController


- (IBAction)LogAsGuest:(id)sender {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ConfigureDiagramViewController *cdc = [sb instantiateViewControllerWithIdentifier:@"ConfigureViewControllerID"];
    [self showViewController:cdc sender:self];
}

@end
