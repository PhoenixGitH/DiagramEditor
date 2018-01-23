//
//  RegisterViewController.m
//  DiagramEditor
//
//  Created by MISO on 22/1/18.
//  Copyright © 2018 Diego Vaquero Melchor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

-(void)viewDidLoad{
    _role = @"editor";
}

- (IBAction)typeUserChanged:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex == 0){
        _role = @"editor";
    }else if(sender.selectedSegmentIndex == 1){
        _role = @"creator";
    }
}

- (IBAction)registerButtonPressed:(id)sender {
    NSString *name = _nameField.text;
    if([name isEqualToString: @""]){
        [self showPopUp: @"Name not completed"];
        return;
    }
    NSString *surname = _surnameField.text;
    if([surname isEqualToString: @""]){
        [self showPopUp: @"Surname not completed"];
        return;
    }
    NSString *email = _emailField.text;
    if([email isEqualToString: @""]){
        [self showPopUp: @"Email not completed"];
        return;
    }
    NSString *user = _userField.text;
    if([user isEqualToString: @""]){
        [self showPopUp: @"User not completed"];
        return;
    }
    NSString * password = _passwordField.text;
    if([password isEqualToString: @""]){
        [self showPopUp: @"Password not completed"];
        return;
    }
    
    //Conexión para comprobar usuario y contraseña
    NSDictionary *objectDic = @{@"name" : name, @"lastname" : surname, @"user" : user, @"password" : password, @"role" : _role, @"email" : email};
    
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:objectDic
                                                          options:NSJSONWritingPrettyPrinted
                                                            error:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://diagrameditorserver.herokuapp.com/register"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[requestData length]];
    request.HTTPMethod = @"POST";
    [request setValue:postLength forHTTPHeaderField:@"Content-Length" ];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = requestData;
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    
                                                    NSLog(@"Done");
                                                    NSLog(@"Error:%@", [error description]);
                                                    NSData *responseData = [[NSData alloc]initWithData:data];
                                                    NSMutableDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                                                    NSLog(@"Random Output= %@", jsonObject);
                                                    NSString *code = [jsonObject objectForKey:@"code"];
                                                    
                                                    if([code isEqualToString:@"200"]){
                                                        // Continue to app with the kind of user.
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                                                                            message:@"Register completed!"
                                                                                                           delegate:self
                                                                                                  cancelButtonTitle:@"OK"
                                                                                                  otherButtonTitles:nil];
                                                            [alert show];
                                                            
                                                            
                                                            
                                                            [self dismissViewControllerAnimated:TRUE completion:nil];
                                                        });
                                                        
                                                        
                                                        
                                                    }else{
                                                        // We don't have that user.
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                                                                            message:@"We already have that user o email"
                                                                                                           delegate:self
                                                                                                  cancelButtonTitle:@"OK"
                                                                                                  otherButtonTitles:nil];
                                                            [alert show];
                                                        });
                                                        
                                                    }
                                                }];
    
    [dataTask resume];
    

}

- (void) showPopUp: (NSString *) texto{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                    message:texto
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
