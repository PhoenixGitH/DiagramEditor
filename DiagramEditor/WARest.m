//
//  WARest.m
//  TriggersV3
//
//  Created by Diego on 16/12/16.
//  Copyright © 2016 Diego. All rights reserved.
//

#import "WARest.h"

@implementation WARest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _baseURL = @"";
        _data = nil;
    }
    return self;
}


-(void)writeValue{
    
    
    
    NSURL *url = [NSURL URLWithString:_baseURL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
   
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[_data length]];
    request.HTTPMethod = @"POST";
    [request setValue:postLength forHTTPHeaderField:@"Content-Length" ];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = _data;
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
                                                    NSLog(@"Done");
                                                    NSLog(@"Error:%@", [error description]);
                                                    NSData *responseData = [[NSData alloc]initWithData:data];
                                                    NSMutableDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                                                    NSLog(@"Random Output= %@", jsonObject);
    }];
    
    [dataTask resume];
}



@end
