//
//  APIModel.m
//  TriggersV3
//
//  Created by Miso on 3/3/17.
//  Copyright © 2017 Diego. All rights reserved.
//

#import "APIModel.h"

@implementation AuthModel

-(NSString *) getName{
    return _name;
}

-(NSString *) getValue{
    return _value;
}

@end

@implementation ParametersModel

-(NSString *) getNombre{
    return _nombre;
}
-(NSString *) getDescripcion{
    return _descripcion;
}
-(NSString *) getTipo{
    return _tipo;
}

@end

@implementation ValueModel

-(NSString *) getNombre{
    return _nombre;
}
-(NSString *) getRuta{
    return _ruta;
}
-(NSString *) getTipo{
    return _tipo;
}

@end


@implementation APIModel

-(AuthModel *) getAuth{
    return _auth;
}

-(NSString *) getName{
    return _name;
}
-(NSString *) getURL{
    return [_protocol stringByAppendingString: _url];
}

-(NSString *) getDescription{
    return self.description;
}
-(NSArray<ParametersModel> *) getParams{
    return _params;
}
-(NSArray<ValueModel> *) getValues{
    return _values;
}

@end
