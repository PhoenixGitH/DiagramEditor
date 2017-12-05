
//
//  UserInfo.m
//  DiagramEditor
//
//  Created by MISO on 3/5/17.
//  Copyright © 2017 Javier. All rights reserved.
//


#import "UserInfo.h"
#import "BooleanAttributeTableViewCell.h"
#import "StringAttributeTableViewCell.h"
#import "EnumTableViewCell.h"
#import "DoubleTableViewCell.h"
#import "IntegerTableViewCell.h"
#import "APIModel.h"
#import "DeviceSelector.h"
#import "RARest.h"
#import "WARest.h"
#import "CallModel.h"

#define getInfo @"https://triggerstest.herokuapp.com/api/Call/"



@interface UserInfo ()

@end

@implementation UserInfo

- (void) prepare: (AppDelegate*) delegate location: (CLLocation *) location andInfo: (NSArray<ClassAttribute*> *) userinfo andOwnData:
    (bool) isOwnData{
    _delegate = delegate;
    _location = location;
    self.userinfo = userinfo;
    self.table.delegate = self;
    self.table.dataSource = self;
    self.isOwnData = isOwnData;
    [self.table registerNib:[UINib nibWithNibName:@"StringAttributeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StrCell"];
    [self.table registerNib:[UINib nibWithNibName:@"BooleanAttributeTableViewCell" bundle:nil] forCellReuseIdentifier:@"BoolCell"];
    [self.table registerNib:[UINib nibWithNibName:@"EnumTableViewCell" bundle:nil] forCellReuseIdentifier:@"EnumCell"];
    [self.table registerNib:[UINib nibWithNibName:@"DoubleTableViewCell" bundle:nil] forCellReuseIdentifier:@"DoubleCell"];
    [self.table registerNib:[UINib nibWithNibName:@"IntegerTableViewCell" bundle:nil] forCellReuseIdentifier:@"IntCell"];
    [self.table layoutIfNeeded];
    [self.table reloadData];
    self.table.translatesAutoresizingMaskIntoConstraints = NO;
    [self.table sizeToFit];
}


/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.userData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    
    //UITableViewCell *cell;
            
    //NSString* type = [_userData objectAtIndex:indexPath.row];
    NSString * type = _userinfo[indexPath.row].type;
    
    //if([type isEqualToString:@"ExperienceLevel"]) type = @"int";
    
    NSDictionary *annotations = _delegate.paletteAnnotations;
    
    NSString *private = [annotations objectForKey:@"privacity"];
    
    if([type isEqualToString:@"String"]){
        StringAttributeTableViewCell * atvc = [tableView dequeueReusableCellWithIdentifier:@"StrCell"];
        
        atvc.attributeNameLabel.text = self.userData[indexPath.row];
        [self checkForAPIString:_userinfo[indexPath.row] andCell:atvc];
        //atvc.textField.text = _userinfo[indexPath.row].defaultValue;
        atvc.backgroundColor = [UIColor clearColor];
        if([private isEqualToString:@"privateData"] && !_isOwnData)
            atvc.textField.text = @"Private";
        
        return atvc;
    }else if([type isEqualToString:@"boolean"] || [type isEqualToString:@"EBooleanObject"]){
        BooleanAttributeTableViewCell * batvc = [tableView dequeueReusableCellWithIdentifier:@"BoolCell"];
        
        batvc.nameLabel.text = self.userData[indexPath.row];
        _userinfo[indexPath.row].defaultValue = @"1";
        [batvc.switchValue setOn: [_userinfo[indexPath.row].defaultValue intValue]];
        if([private isEqualToString:@"privateData"] && !_isOwnData)
           [batvc.switchValue setEnabled:FALSE];
        
        batvc.backgroundColor = [UIColor clearColor];
        
        return batvc;
    }else if([type isEqualToString:@"int"] || [type isEqualToString:@"Int"]){
        
        IntegerTableViewCell * iatvc = [tableView dequeueReusableCellWithIdentifier:@"IntCell"];
        
        iatvc.label.text = self.userData[indexPath.row];
        [self checkForAPIInt: _userinfo[indexPath.row] andCell:iatvc];
        //iatvc.textField.text = _userinfo[indexPath.row].defaultValue;
        iatvc.backgroundColor = [UIColor clearColor];
    
        if([private isEqualToString:@"privateData"] && !_isOwnData)
            iatvc.textField.text = @"0";
        
        return iatvc;
    }else if([type isEqualToString:@"EDouble"] || [type isEqualToString:@"EFloat"]){
        
        DoubleTableViewCell * datvc = [tableView dequeueReusableCellWithIdentifier:@"DoubleCell"];
        
        datvc.label.text = self.userData[indexPath.row];
        datvc.backgroundColor = [UIColor clearColor];
        
        [self checkForAPIDouble: _userinfo[indexPath.row] andCell:datvc];
        //datvc.textField.text = _userinfo[indexPath.row].defaultValue;

        if([private isEqualToString:@"privateData"] && !_isOwnData)
            datvc.textField.text = @"0.00";
        
        return datvc;
    }else{
        //It is an enum?
        if([_delegate.enumsDic objectForKey:type] != nil){
            NSArray * options = [_delegate.enumsDic objectForKey:type];
            EnumTableViewCell * etvc = [tableView dequeueReusableCellWithIdentifier:@"EnumCell"];
            
            etvc.options = options;
            etvc.label.text = type;
            etvc.backgroundColor = [UIColor clearColor];
            
            [etvc prepare];
            etvc.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [etvc.optionsPicker selectRow:[_userinfo[indexPath.row].currentValue integerValue] inComponent:0 animated:NO];
            
            return etvc;
        }
    }
    
    return nil;
}


// Here we check if there are annotations for string.
- (void) checkForAPIString: (ClassAttribute *) atr andCell: (StringAttributeTableViewCell *) atvc{
    NSDictionary *annotations = atr.annotations;
    if(annotations.count != 0){
        NSArray *pol = [annotations valueForKey:@"policy"];
        if(pol[0] == [NSNull null] || [pol[0] isEqualToString:@"onOpen"]){
            NSArray *api = [annotations valueForKey:@"api"];
            NSArray *device = [annotations valueForKey:@"device"];
            
            if(api[0] != [NSNull null]){
                [atvc.textField setText:[[self callForAPIValue:annotations] description]];
                atvc.textField.enabled = NO;
            }else if(device[0] != [NSNull null]){
                DeviceSelector *devsel = [[DeviceSelector alloc] init];
                [atvc.textField setText: [devsel TypeToReturn:device[0]]];
                atvc.textField.enabled = NO;
            }else{
                [atvc.textField setText:atr.currentValue];
            }
        }
    }else{
        atvc.textField.text =  atr.currentValue;
    }
}

// Here we check if there are annotations.
- (void) checkForAPIInt: (ClassAttribute *) atr andCell: (IntegerTableViewCell *) iatvc{
    NSDictionary *annotations = atr.annotations;
    if(annotations.count != 0){
        NSArray *pol = [annotations valueForKey:@"policy"];
        if(pol[0] == [NSNull null] || [pol[0] isEqualToString:@"onOpen"]){
            NSArray *api = [annotations valueForKey:@"api"];
            NSArray *device = [annotations valueForKey:@"device"];
            
            if(api[0] != [NSNull null]){
                [iatvc.textField setText:[[self callForAPIValue:annotations] description]];
                iatvc.textField.enabled = NO;
            }else if(device[0] != [NSNull null]){
                DeviceSelector *devsel = [[DeviceSelector alloc] init];
                [iatvc.textField setText: [devsel TypeToReturn:device[0]]];
                iatvc.textField.enabled = NO;
            }else{
                [iatvc.textField setText:atr.currentValue];
            }
        }
    }else{
        [iatvc.textField setText:atr.currentValue];
    }
}

// Here we check if there are annotations.
- (void) checkForAPIDouble: (ClassAttribute *) atr andCell: (DoubleTableViewCell *) iatvc{
    NSDictionary *annotations = atr.annotations;
    if(annotations.count != 0){
        NSArray *pol = [annotations valueForKey:@"policy"];
        if(pol[0] == [NSNull null] || [pol[0] isEqualToString:@"onOpen"]){
            NSArray *api = [annotations valueForKey:@"api"];
            NSArray *device = [annotations valueForKey:@"device"];
            
            if(api[0] != [NSNull null]){
                [iatvc.textField setText:[[self callForAPIValue:annotations] description]];
                iatvc.textField.enabled = NO;
            }else if(device[0] != [NSNull null]){
                DeviceSelector *devsel = [[DeviceSelector alloc] init];
                [iatvc.textField setText: [devsel TypeToReturn:device[0]]];
                iatvc.textField.enabled = NO;
                
            }else{
                [iatvc.textField setText:atr.currentValue];
            }
        }
    }else{
        [iatvc.textField setText:atr.currentValue];
    }
}

-(NSObject *) callForAPIValue: (NSDictionary *) annotations{
    NSArray *api = [annotations valueForKey:@"api"];
    
    RARest * rar = [[RARest alloc] init];
    rar.baseURL = [@"https://triggerstest.herokuapp.com/api/API/" stringByAppendingString:api[0]];
    
    NSError *err;
    
    APIModel *result = [[APIModel alloc] initWithDictionary: [rar getValue] error: &err];
    
    NSArray <ParameterModel*> *params = [self checkForParamsType:annotations andAPI: result];
    
    NSArray *get = [annotations valueForKey:@"get"];
    
    CallModel *call = [[CallModel alloc] initWithValues:params andUrl:[result getURL] andParam:get[0] andAuth: [result getAuth]];
    
    NSData *data = [call toJSONData];
    
    NSURL *url = [NSURL URLWithString:getInfo];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[data length]];
    request.HTTPMethod = @"POST";
    [request setValue:postLength forHTTPHeaderField:@"Content-Length" ];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = data;
    
    __block NSObject *obj;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    
                                                    NSLog(@"Done");
                                                    NSLog(@"Error:%@", [error description]);
                                                    NSData *responseData = [[NSData alloc]initWithData:data];
                                                    NSMutableDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                                                    NSLog(@"Random Output= %@", jsonObject);
                                                    obj = [jsonObject valueForKey:@"param"];
                                                    dispatch_group_leave(group);
                                                }];
    
    [dataTask resume];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    return obj;
    
}

// Comprueba como queremos extraer los datos de la API.
// P.ej: geo = lat, lon. val = valor directo, attr: es un atributo directo como lon.
- (NSArray <ParameterModel *> *)checkForParamsType:(NSDictionary *)annotations andAPI: (APIModel*) api{
    
    NSArray *parameters = [api getParams];
    
    NSMutableArray <ParameterModel*> *params = [[NSMutableArray alloc] init];
    
    // TODO: Considerar si se quiere hacer por formulario.
    for(int i = 0; i<parameters.count; i++){
        NSArray *parame = [annotations valueForKey:[parameters[i] getNombre]];
        if(parame){
            ParameterModel *param;
            NSString *parametro = [parame[0] componentsSeparatedByString:@"."][1];
            if([parame[0] hasPrefix:@"geo"]){
                // Se trata de latitud
                if([parametro  isEqual: @"lat"]){
                    NSString *string = [NSString stringWithFormat:@"%f", _location.coordinate.latitude];
                    param =  [[ParameterModel alloc] initWithValues:[parameters[i] getNombre] andValue:string];
                    // Es longitud
                }else if ([parametro  isEqual: @"lon"]){
                    NSString *string = [NSString stringWithFormat:@"%f", _location.coordinate.longitude];
                    param =  [[ParameterModel alloc] initWithValues:[parameters[i] getNombre] andValue:string];
                }
                
            }else if([parame[0] hasPrefix:@"val"]){
                param = [[ParameterModel alloc] initWithValues:[parameters[i] getNombre] andValue:parametro];
            }else if([parame[0] hasPrefix:@"form"]){
                //TODO: FORM DATA
            }else if([parame[0] hasPrefix:@"dev"]){
                DeviceSelector *devsel = [[DeviceSelector alloc] init];
                param = [[ParameterModel alloc] initWithValues:[parameters[i] getNombre] andValue: [devsel TypeToReturn:parame[0]]];
            }else{
                //TODO: Other specific values from component.
            }
            [params addObject:param];
        }
        
    }
    return params;
}



@end
