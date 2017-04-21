//
//  RARest.m
//  TriggersV3
//
//  Created by Diego on 14/12/16.
//  Copyright © 2016 Diego. All rights reserved.
//

#import "RARest.h"

@implementation RARest



- (instancetype)init
{
    self = [super init];
    if (self) {
        super.name = @"Read from REST";
        super.information = @"Executes a rest call from @baseURL and returns the specified data according to @orderToData";
        
        _baseURL = @"";
        _paramsDictionary = [[NSMutableDictionary alloc] init];
        _orderToData = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)addKeyToOrder:(NSString *)key{
    [_orderToData addObject:key];
}

-(void)addParamWithKey:(NSString *)key
              andValue:(NSString *)value{
    [_paramsDictionary setObject:value forKey:key];
}


-(id)getValue{
    
    NSString * urlString = [NSString stringWithFormat:@"%@", _baseURL];
    
    NSArray * dicKeys = [_paramsDictionary allKeys];
    
    for(NSString * key in dicKeys){
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, [_paramsDictionary objectForKey:key]]];
    }
    
    if([urlString characterAtIndex:urlString.length-1] == '&'){
        urlString = [urlString substringToIndex:[urlString length] - 1];
    }
    
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    __block NSData * dataToReturn = nil;
    __block NSError * error;
    
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url
                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *err) {
                                              
                                              error = err;
                                              dataToReturn = data;
                                              
                                              dispatch_group_leave(group);
                                          }];
    [downloadTask resume];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    
    
    if(error){
        return nil;
    }else{
        NSError * jsonError = nil;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:dataToReturn
                                                             options:NSJSONWritingPrettyPrinted
                                                               error:&jsonError];
        
        if(jsonError){
            return nil;
        }else{
            
            
            if(_orderToData.count > 0){
                return [self recoverValueFromDictionary:json UsingOrder:_orderToData];
            }else{
                return json;
            }
            
        }
        
    }
    
    
    
    return nil;
}

-(id)recoverValueFromDictionary:(NSDictionary *)dic
                     UsingOrder:(NSMutableArray *)order{
    
    //order holds the keys
    
    NSDictionary * currentDic = dic;
    
    for (NSString * key in order) {
        
        if(currentDic != nil){
            if([currentDic isKindOfClass:[NSArray class]]){
                NSArray * arr = (NSArray *)currentDic;
                currentDic = [arr objectAtIndex:0];
            }
            NSDictionary * nextDic = [currentDic objectForKey:key];
            currentDic = nextDic;
        }else{
            return nil;
        }
    }
    
    return currentDic;
}


@end
