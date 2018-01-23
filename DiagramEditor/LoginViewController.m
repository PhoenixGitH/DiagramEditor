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
#import "WARest.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@end


@implementation LoginViewController

-(void)viewDidLoad{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

- (IBAction)LoginUser:(id)sender {
    NSString *user = _fieldUser.text;
    NSString *pass = _fieldPass.text;
    
    if([user isEqualToString:@""] || [pass isEqualToString:@""]){
        //No se ha introducido user o pass.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:@"User name or password not filled"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        //Conexión para comprobar usuario y contraseña
        NSDictionary *objectDic = @{@"user" : user, @"password" : pass};
        
        
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:objectDic
                                                              options:NSJSONWritingPrettyPrinted
                                                                error:nil];
        
        NSURL *url = [NSURL URLWithString:@"http://diagrameditorserver.herokuapp.com/login"];
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
                                                        NSDictionary* res = [jsonObject objectForKey:@"array"];
                                                        
                                                        if([code isEqualToString:@"200"]){
                                                            // Continue to app with the kind of user.
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                                                                            message:@"Everything OK"
                                                                                                           delegate:self
                                                                                                  cancelButtonTitle:@"OK"
                                                                                                  otherButtonTitles:nil];
                                                                [alert show];
                                                                
                                                                //Keep the kind of user.
                                                                NSString *role = [res objectForKey:@"role"];
                                                                
                                                                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                                                
                                                                [userDefaults setObject:role
                                                                                 forKey:@"role"];
                                                         
                                                                [userDefaults synchronize];
                                                                
                                                                UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                ConfigureDiagramViewController *cdc = [sb instantiateViewControllerWithIdentifier:@"ConfigureViewControllerID"];
                                                                [self showViewController:cdc sender:self];
                                                            });
                                                            
                                                            
                                                            
                                                        }else{
                                                            // We don't have that user.
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                                                                                message:@"Wrong user or password"
                                                                                                               delegate:self
                                                                                                      cancelButtonTitle:@"OK"
                                                                                                      otherButtonTitles:nil];
                                                                [alert show];
                                                            });

                                                        }
                                                    }];
        
        [dataTask resume];
        
    }
    
}

- (IBAction)ContinueRegister:(id)sender {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterViewController *rvc = [sb instantiateViewControllerWithIdentifier:@"RegisterViewControllerID"];
    [self showViewController:rvc sender:self];
}


- (IBAction)LogAsGuest:(id)sender {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ConfigureDiagramViewController *cdc = [sb instantiateViewControllerWithIdentifier:@"ConfigureViewControllerID"];
    [self showViewController:cdc sender:self];
}

@end
