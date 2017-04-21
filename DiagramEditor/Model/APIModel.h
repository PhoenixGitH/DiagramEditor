//
//  APIModel.h
//  TriggersV3
//
//  Created by Miso on 3/3/17.
//  Copyright © 2017 Javier. All rights reserved.
//

#ifndef APIModel_h
#define APIModel_h

#import "JSONModel.h"

@protocol AuthModel;

@interface AuthModel : JSONModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *value;

-(NSString *) getName;
-(NSString *) getValue;

@end

@protocol ParametersModel;

@interface ParametersModel : JSONModel

@property (nonatomic) NSString *nombre;
@property (nonatomic) NSString *descripcion;
@property (nonatomic) NSString *tipo;

-(NSString *) getNombre;
-(NSString *) getDescripcion;
-(NSString *) getTipo;

@end

@protocol ValueModel;

@interface ValueModel : JSONModel

@property (nonatomic) NSString *nombre;
@property (nonatomic) NSString *ruta;
@property (nonatomic) NSString *tipo;

-(NSString *) getNombre;
-(NSString *) getRuta;
-(NSString *) getTipo;

@end

@interface APIModel : JSONModel

@property (nonatomic) NSString *name;
@property (nonatomic) AuthModel<Optional> *auth;
@property (nonatomic) NSString *description;
@property (nonatomic) NSArray <ParametersModel> *params;
@property (nonatomic) NSArray <ValueModel> *values;
@property (nonatomic) NSString *protocol;
@property (nonatomic) NSString *url;

-(AuthModel *) getAuth;
-(NSString *) getName;
-(NSString *) getURL;
-(NSString *) getDescription;
-(NSArray<ParametersModel> *) getParams;
-(NSArray<ValueModel> *) getValues;

@end


#endif /* APIModel_h */
