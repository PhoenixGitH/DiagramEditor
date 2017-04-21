//
//  RARest.h
//  TriggersV3
//
//  Created by Diego on 14/12/16.
//  Copyright © 2016 Diego. All rights reserved.
//

#import "ReadAction.h"

@interface RARest : ReadAction


//By default RARest will be a GET REST call


@property NSString * baseURL;
@property NSMutableDictionary * paramsDictionary;
@property NSMutableArray * orderToData;


-(void)addParamWithKey:(NSString *)key
              andValue:(NSString *)value;

-(void)addKeyToOrder:(NSString *)key;

-(id)recoverValueFromDictionary:(NSDictionary *)dic
                     UsingOrder:(NSMutableArray *)order;



@end
