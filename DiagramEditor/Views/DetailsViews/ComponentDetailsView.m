
//
//  ComponentDetailsViewController.m
//  DiagramEditor
//
//  Created by Diego Vaquero Melchor on 9/12/15.
//  Copyright © 2015 Diego Vaquero Melchor. All rights reserved.
//

#import "ComponentDetailsView.h"
#import "RARest.h"
#import "WARest.h"
#import "CallModel.h"
#import "Component.h"
#import "AppDelegate.h"
#import "Connection.h"
#import "StringAttributeTableViewCell.h"
#import "BooleanAttributeTableViewCell.h"
#import "GenericAttributeTableViewCell.h"
#import "ClassAttribute.h"
#import "Reference.h"
#import "ReferenceTableViewCell.h"
#import "LinkPalette.h"
#import "ExpandableItemView.h"
#import "EditorViewController.h"
#import "DoubleTableViewCell.h"
#import "IntegerTableViewCell.h"
#import "EnumTableViewCell.h"
#import "DeviceSelector.h"
#import "GeoComponentAnnotationView.h"

#define getInfo @"https://triggerstest.herokuapp.com/api/Call/"

@interface ComponentDetailsView ()

@end

@implementation ComponentDetailsView

@synthesize comp, delegate, background;


-(void)awakeFromNib{
    [super awakeFromNib];
    tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleTap:)];
    [tapgr setDelegate:self];
    [background addGestureRecognizer:tapgr];
    [previewComponent setNeedsDisplay];
    [previewComponent updateNameLabel];
    
    previewComponent.layer.masksToBounds = NO;
}
- (void)prepare: (bool) root{
    
    
    
    table.delegate = self;
    table.dataSource = self;
    
    if(!root){
        //remove all subviews from previewcomponentView
        NSArray *vtr = [previewComponentView subviews];
        for (UIView *v in vtr) {
            [v removeFromSuperview];
        }
        
        
        NSData * buff = [NSKeyedArchiver archivedDataWithRootObject:comp];
        previewComponent = [NSKeyedUnarchiver unarchiveObjectWithData:buff];
        
        CGRect frame = previewComponent.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.width = previewComponentView.frame.size.width;
        frame.size.height = previewComponentView.frame.size.height;
        [previewComponent setFrame:frame];
        
        [previewComponentView setBounds:comp.bounds];
        [previewComponent setBounds:comp.bounds];
        
        [previewComponentView addSubview:previewComponent];
        
        previewComponent.textLayer = nil;
        [previewComponent prepare];
        [previewComponent updateNameLabel];
        
        /*for (UIGestureRecognizer *recognizer in previewComponent.gestureRecognizers) {
         [previewComponent removeGestureRecognizer:recognizer];
         }*/
        for (UIGestureRecognizer *recognizer in previewComponent.gestureRecognizers) {
            [previewComponent removeGestureRecognizer:recognizer];
        }
        
        //Remove all previewComponents subviews
        NSArray *viewsToRemove = [previewComponent subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        
        //[previewComponent addSubview:temp];
        
        [previewComponent setNeedsDisplay];
    }
    
    dele = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSArray * parsedArr = [comp.type componentsSeparatedByString:@":"];
    typeLabel.text = [parsedArr objectAtIndex:parsedArr.count-1];
    
    //Connection * tc = nil;
    connections = [[NSMutableArray alloc] init];
    for(int i = 0; i< dele.connections.count; i++){
        Connection * tc = [dele.connections objectAtIndex:i];
        if(tc.source == comp)
            [connections addObject:tc];
    }
    
    
    
    
    //[previewComponent setNeedsDisplay];
    
    classLabel.text = comp.className;
    
    //Tap to close
    
    [table reloadData];
    
}

-(void)updateThisView: (NSNotification *)not{
    [self setNeedsDisplay];
}

- (IBAction)closeDetailsViw:(id)sender {
    [self showButtons];
    [self hideInfo];
    [delegate closeDetailsViewAndUpdateThings];
}



-(void)updateLocalConenctions{
    Connection * tc = nil;
    connections = [[NSMutableArray alloc] init];
    for(int i = 0; i< dele.connections.count; i++){
        tc = [dele.connections objectAtIndex:i];
        if(tc.source == comp)
            [connections addObject:tc];
    }
    
    [table reloadData];
}



#pragma mark UITextField delegate methods
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(textField.text.length >0){
        [previewComponent updateNameLabel];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"repaintCanvas" object:self];
    }else{
        
    }
}
/*
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * new = [nameTextField.text stringByReplacingCharactersInRange:range withString:string];
    if(new.length > 0){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"repaintCanvas" object:self];
        [previewComponent updateNameLabel];
        [comp updateNameLabel];
        return YES;
    }
    else
        return NO;
}*/


- (IBAction)deleteCurrentComponent:(id)sender {
    
    if(dele.amITheMaster || dele.manager.session.connectedPeers.count <= 1){
        //Remove all connections for this element
        Connection * conn = nil;
        NSMutableArray * connsToRemove = [[NSMutableArray alloc] init];
        for(int i = 0; i<dele.connections.count; i++){
            conn = [dele.connections objectAtIndex:i];
        
            if(conn.target == comp || conn.source == comp){
                //Remove this connection
                [connsToRemove addObject:conn ];
            }
        }
    
        for(int i = 0; i<connsToRemove.count; i++){
            conn = [connsToRemove objectAtIndex:i];
            [dele.connections removeObject:conn];
        }
    
    
        //Remove this component
        if(dele.isGeoPalette){
            GeoComponentAnnotationView *aso = comp.annotationView;
            
            
            [dele.map removeAnnotation:aso.point];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"repaintMap" object:self];
        }else{
            [comp removeFromSuperview];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"repaintCanvas" object:self];
        }
        [dele.components removeObject:comp];
    
    
    
        //[self dismissViewControllerAnimated:YES completion:nil];
    
    
    
        [delegate closeDetailsViewAndUpdateThings];
        [previewComponent setNeedsDisplay];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:@"You can't do that if you are not the master"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,nil];
        [alert show];
    }
}

- (void)viewDidAppear:(BOOL)animated{

}


#pragma mark UITableView Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(comp.isExpandable == YES){
        int count = 2;
        
        count = count + (int)comp.expandableItems.count;
        /*NSArray * keys = [comp.linkPaletteDic allKeys];
        for(NSString * key in keys){
            LinkPalette * lp = [comp.linkPaletteDic objectForKey:key];
            if(lp.isExpandableItem == YES){
                count ++;
            }
        }*/
        return count;
    }else
        return 2;    //0-> Attributes   1->Out connections
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        return comp.attributes.count;
    }else if(section == 1){
        return connections.count;
    }else{
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return @"Attributes";
    }else if(section == 1){
        return @"Out connections";
    }else{
        int index = (int)section -2;
        LinkPalette * lp = comp.expandableItems[index];
        return [NSString stringWithFormat:@"Expandable item %d", lp.expandableIndex];
    }

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    
    if(indexPath.section >= 1){ //Attributes section
        return YES;
    }else{
        return NO;
    }
    /*if(indexPath.section == 0){ //Attributes
        return NO;
    }else{
        if(connections.count == 0){
            return YES;
        }else{
            if(indexPath.section == 1){
                return YES;
            }else{
                return NO;
            }
        }
    }*/
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section > 1){ //It is a ExpandableItem
        int index = (int)indexPath.section -2;
        LinkPalette * lp = comp.expandableItems[index];
        ExpandableItemView * eiv = [[[NSBundle mainBundle] loadNibNamed:@"ExpandableItemView"
                                              owner:self
                                            options:nil] objectAtIndex:0];
        
        
        [eiv prepare];
        eiv.lp = lp;
        eiv.comp = comp;
        [eiv setTitle:lp.paletteName];
        
        [eiv setFrame:dele.evc.view.frame];
        
        [dele.evc.view addSubview:eiv];
        
    }else if(indexPath.section == 1){
        
            Connection * conn = [connections objectAtIndex:indexPath.row];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"showConnNot" object: conn];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell;
    
    if(indexPath.section == 1){
        static NSString *MyIdentifier = @"outCellID";
        
        Connection * c = [connections objectAtIndex:indexPath.row];
        
        cell= [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier] ;
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumScaleFactor = 0.5;
        cell.textLabel.text = [NSString stringWithFormat:@"Name: %@",c.className];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(indexPath.section == 0){
        static NSString *MyIdentifier = @"AttrCellID";
        
        //Check component type
        
        if([[comp.attributes objectAtIndex:indexPath.row]isKindOfClass:[ClassAttribute class]]){
            
            ClassAttribute * attr = [comp.attributes objectAtIndex:indexPath.row];
            NSString * type = attr.type;
            
            if([type isEqualToString:@"EString"]){
                StringAttributeTableViewCell * atvc = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
                
                if(atvc == nil){
                    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"StringAttributeTableViewCell"
                                                                  owner:self
                                                                options:nil];
                    atvc = [nib objectAtIndex:0];
                    atvc.attributeNameLabel.text = attr.name;
                    atvc.backgroundColor = [UIColor clearColor];
                    atvc.comp = comp;
                    atvc.associatedAttribute = attr;
                    atvc.detailsPreview = previewComponent;
                    
                    
                    if([dele amITheMaster] || dele.inMultipeerMode == NO){
                        [atvc.textField setEnabled:YES];
                    }else{
                        [atvc.textField setEnabled:NO];
                    }
                    
                    // TODO: Add the new values getted by API.
                    for(ClassAttribute * atr in comp.attributes){
                        if([atr.name isEqualToString:atvc.attributeNameLabel.text]){
                            [self checkForAPIString: atr andCell: atvc];
                        }
                    }
                    [comp updateNameLabel];
                    [previewComponent updateNameLabel];
                    //[previewComponent updateNameLabel];

                    
                    //atvc.typeLabel.text = attr.type;
                    atvc.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                return atvc;
                
            }else if([type isEqualToString:@"EBoolean"] || [type isEqualToString:@"EBooleanObject"]){
                BooleanAttributeTableViewCell * batvc = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
                if(batvc == nil){
                    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"BooleanAttributeTableViewCell"
                                                                  owner:self
                                                                options:nil];
                    batvc = [nib objectAtIndex:0];
                    batvc.nameLabel.text = attr.name;
                    //batvc.typeLabel.text = attr.type;
                    batvc.associatedAttribute = attr;
                    batvc.backgroundColor = [UIColor clearColor];
                    
                    if([dele amITheMaster]|| dele.inMultipeerMode == NO){
                        [batvc.switchValue setEnabled:YES];
                    }else{
                        [batvc.switchValue setEnabled:NO];
                    }
                    
                    //Update switch value for this attribute value
                    if(attr.currentValue == nil){
                        [batvc.switchValue setOn:NO];
                    }else if([attr.currentValue isEqualToString: @"false"]){
                        [batvc.switchValue setOn:NO];
                    }else if([attr.currentValue isEqualToString:@"true"]){
                        [batvc.switchValue setOn:YES];
                    }
                    batvc.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                return batvc;
            }else if([type isEqualToString:@"EDouble"] || [type isEqualToString:@"EFloat"]){
                
                DoubleTableViewCell * datvc = [tableView dequeueReusableCellWithIdentifier:@"DoubleCell"];
                if(datvc == nil){
                    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"DoubleTableViewCell"
                                                                  owner:self
                                                                options:nil];
                    datvc = [nib objectAtIndex:0];
                    datvc.label.text = attr.name;
                    datvc.associatedAttribute = attr;
                    datvc.backgroundColor = [UIColor clearColor];
                    datvc.comp = comp;
                    
                    if([dele amITheMaster]|| dele.inMultipeerMode == NO){
                        [datvc.textField setEnabled:YES];
                    }else{
                        [datvc.textField setEnabled:NO];
                    }
                    
                    //Update textfield value for this attribute value
                    [self checkForAPIDouble: attr andCell: datvc];
                    datvc.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                return  datvc;
 
            }else if([type isEqualToString:@"EInt"] || [type isEqualToString:@"EInteger"]){
                
                IntegerTableViewCell * iatvc = [tableView dequeueReusableCellWithIdentifier:@"IntCell"];
                if(iatvc == nil){
                    NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"IntegerTableViewCell" owner:self options:nil];
                    iatvc  = [nib objectAtIndex:0];
                    iatvc.label.text = attr.name;
                    iatvc.associatedAttribute = attr;
                    iatvc.backgroundColor = [UIColor clearColor];
                    iatvc.comp = comp;
                    
                    if([dele amITheMaster]|| dele.inMultipeerMode == NO){
                        [iatvc.textField setEnabled:YES];
                    }else{
                        [iatvc.textField setEnabled:NO];
                    }
                    [self checkForAPIInt: attr andCell: iatvc];
                    iatvc.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                return iatvc;
            }else{
                
                //It is an enum?
                if([dele.enumsDic objectForKey:attr.type] != nil){
                    NSArray * options = [dele.enumsDic objectForKey:attr.type];
                    EnumTableViewCell * etvc = [tableView dequeueReusableCellWithIdentifier:@"enumID"];
                    if(etvc == nil){
                        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"EnumTableViewCell"
                                                                      owner:self
                                                                    options:nil];
                        etvc = [nib objectAtIndex:0];
                        etvc.options = options;
                        etvc.label.text = attr.name;
                        etvc.backgroundColor = [UIColor clearColor];
                        etvc.comp = comp;
                        etvc.associatedAttribute = attr;
                        etvc.previewComp  = previewComponent;
                        if([dele amITheMaster]|| dele.inMultipeerMode == NO){
                            [etvc.optionsPicker setUserInteractionEnabled:YES];
                        }else{
                            [etvc.optionsPicker setUserInteractionEnabled:NO];
                        }
                        
                        [etvc prepare];
                        etvc.selectionStyle = UITableViewCellSelectionStyleNone;
                       
                    }
                    return etvc;
                }else{
                    GenericAttributeTableViewCell * gatvc = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
                    if(gatvc == nil){
                        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"GenericAttributeTableViewCell"
                                                                      owner:self
                                                                    options:nil];
                        gatvc = [nib objectAtIndex:0];
                        gatvc.nameLabel.text =  [NSString stringWithFormat:@"%@: %@", attr.name, attr.type];//attr.name;
                        //gatvc.typeLabel.text = attr.type;
                        gatvc.backgroundColor = [UIColor clearColor];
                        gatvc.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                    }
                    return gatvc;
                }
                
            }
            
            
            
            return nil;
        }else if([[comp.attributes objectAtIndex:indexPath.row] isKindOfClass:[Reference class]]){
            Reference * ref = [comp.attributes objectAtIndex:indexPath.row];
            ReferenceTableViewCell * rtvc = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
            if(rtvc == nil){
                NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"ReferenceTableViewCell" owner:self options:nil];
                rtvc = [nib objectAtIndex:0];
                
                rtvc.nameLabel.text = ref.name;
                rtvc.targetLabel.text = ref.target;
                rtvc.minLabel.text = [ref.min description];
                rtvc.maxLabel.text = [ref.max description];
                [rtvc.containmentSwitch setOn:ref.containment];
                rtvc.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            //[rtvc setHidden:YES];
            return rtvc;
        }
    }else{
        //Expandable item
        int index = (int)indexPath.section -2;
        LinkPalette * lp = comp.expandableItems[index];
        NSString *MyIdentifier = [NSString stringWithFormat:@"ExpItemId%d",lp.expandableIndex];
        
       
        
        cell= [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier] ;
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumScaleFactor = 0.5;
        cell.textLabel.textColor = dele.blue4;
        cell.textLabel.text = [NSString stringWithFormat:@"%@",lp.paletteName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    
    
    
    
    return cell;
}

/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1)
        return YES;
    else
        return NO;
}
*/


//Hide references
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.section == 1){
        return 47;
    }else if(indexPath.section == 0){
        if([[comp.attributes objectAtIndex:indexPath.row] isKindOfClass:[Reference class]]){
            return 0;
        }else{
            return 47;
        }
    }else{
        return 47;
    }
    
   
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1){
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //add code here for when you hit delete
            Connection * toDelete = [connections objectAtIndex:indexPath.row];
            
            [dele.connections removeObject:toDelete];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"repaintMap" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"repaintCanvas" object:self];
            
            
            [self updateLocalConenctions];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color

    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:dele.blue3];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
     header.contentView.tintColor = dele.blue3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {
        // whatever height you'd want for a real section header
        return 20;
    }
}


#pragma mark UITapGestureRecognizer methods
-(void)handleTap: (UITapGestureRecognizer *)recog{
    [self showButtons];
    [self hideInfo];
    [self setHidden:YES];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    [self endEditing:YES];
    if (touch.view != background || touch.view != blurView) { // accept only touchs on superview, not accept touchs on subviews
        return NO;
    }
    
    return YES;
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
                    NSString *string = [NSString stringWithFormat:@"%f", comp.latitude];
                    param =  [[ParameterModel alloc] initWithValues:[parameters[i] getNombre] andValue:string];
                // Es longitud
                }else if ([parametro  isEqual: @"lon"]){
                    NSString *string = [NSString stringWithFormat:@"%f", comp.longitude];
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



//Center canvas on this element
- (IBAction)showInCanvas:(id)sender {
    if(dele.isGeoPalette == NO){
        [self setHidden:YES];
        CGRect rectToZoom = CGRectMake(comp.frame.origin.x - (2*comp.frame.size.width),
                                       comp.frame.origin.y - (2* comp.frame.size.height),
                                       4*comp.frame.size.width,
                                       4*comp.frame.size.height);
        [_scroll zoomToRect:rectToZoom animated:YES];
    }else{ //Zoom to localization
    }
   
}

- (void) showButtons{
    deleteButton.hidden = FALSE;
    searchButton.hidden = FALSE;
}

- (void) hideButtons{
    deleteButton.hidden = TRUE;
    searchButton.hidden = TRUE;
}

- (void) showInfo{
    infoImage.hidden = FALSE;
}

- (void) hideInfo{
    infoImage.hidden = TRUE;
}

@end
