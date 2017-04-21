//
//  CallModel.h
//  TriggersV3
//
//  Created by Miso on 6/3/17.
//  Copyright © 2017 Javier. All rights reserved.
//

#ifndef CallModel_h
#define CallModel_h

#import "JSONModel.h"
#import "APIModel.h"

@protocol ParameterModel;


@interface ParameterModel : JSONModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *value;

- (id) initWithValues: (NSString *)name andValue: (NSString *) value;

-(NSString *) getName;
-(NSString *) getValue;

@end

@interface CallModel : JSONModel

-(id) initWithValues: (NSArray *)params andUrl: (NSString *) url andParam: (NSString *)param andAuth: (AuthModel *) auth;

@property (nonatomic) NSArray <ParameterModel> *params;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *parametro;
@property (nonatomic) AuthModel *auth;

-(AuthModel *) getAuth;
-(NSString *) getUrl;
-(NSArray *) getParams;
-(NSString *) getParametro;

@end


#endif /* CallModel_h */
