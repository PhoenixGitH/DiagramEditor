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
#import "BooleanAttributeTableViewCell.h"
#import "DoubleTableViewCell.h"
#import "IntegerTableViewCell.h"


@interface UserInfo ()

@end

@implementation UserInfo

- (void) prepare: (AppDelegate*) delegate{
    _delegate = delegate;
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table registerNib:[UINib nibWithNibName:@"StringAttributeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StrCell"];
    [self.table registerNib:[UINib nibWithNibName:@"BooleanAttributeTableViewCell" bundle:nil] forCellReuseIdentifier:@"BoolCell"];
    [self.table registerNib:[UINib nibWithNibName:@"DoubleTableViewCell" bundle:nil] forCellReuseIdentifier:@"DoubleCell"];
    [self.table registerNib:[UINib nibWithNibName:@"IntegerTableViewCell" bundle:nil] forCellReuseIdentifier:@"IntCell"];
    [self.table reloadData];
    [self.table layoutIfNeeded];
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
    NSString * type = _delegate.userArray[indexPath.row].type;
    
    if([type isEqualToString:@"String"]){
        StringAttributeTableViewCell * atvc = [tableView dequeueReusableCellWithIdentifier:@"StrCell"];
        
        atvc.attributeNameLabel.text = self.userData[indexPath.row];
        atvc.backgroundColor = [UIColor clearColor];
        
        return atvc;
    }else if([type isEqualToString:@"boolean"] || [type isEqualToString:@"EBooleanObject"]){
        BooleanAttributeTableViewCell * batvc = [tableView dequeueReusableCellWithIdentifier:@"BoolCell"];
        
        batvc.nameLabel.text = self.userData[indexPath.row];
        batvc.backgroundColor = [UIColor clearColor];
        
        return batvc;
    }else if([type isEqualToString:@"int"] || [type isEqualToString:@"Int"]){
        
        IntegerTableViewCell * iatvc = [tableView dequeueReusableCellWithIdentifier:@"IntCell"];
        
        iatvc.label.text = self.userData[indexPath.row];
        iatvc.backgroundColor = [UIColor clearColor];
    
        return iatvc;
    }else if([type isEqualToString:@"EDouble"] || [type isEqualToString:@"EFloat"]){
        
        DoubleTableViewCell * datvc = [tableView dequeueReusableCellWithIdentifier:@"DoubleCell"];
        
        datvc.label.text = self.userData[indexPath.row];
        datvc.backgroundColor = [UIColor clearColor];
        
        return datvc;
    }
    
    return nil;
}



@end
