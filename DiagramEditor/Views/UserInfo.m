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
#import "BooleanAttributeTableViewCell.h"

@interface UserInfo ()

@end

@implementation UserInfo

- (void) prepare{
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table registerNib:[UINib nibWithNibName:@"StringAttributeTableViewCell" bundle:nil] forCellReuseIdentifier:@"AttrCellID"];
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
    
    static NSString *MyIdentifier = @"AttrCellID";
    
            
    //NSString* type = [_userData objectAtIndex:indexPath.row];
    //NSString * type = attr.type;
            
    StringAttributeTableViewCell * atvc = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    //if(atvc == nil){
        //NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"StringAttributeTableViewCell"
                                                      //owner:self
                                                    //options:nil];
        //atvc = [nib objectAtIndex:0];
        atvc.attributeNameLabel.text = self.userData[indexPath.row];
        atvc.backgroundColor = [UIColor clearColor];
        //atvc.comp = comp;
        //atvc.associatedAttribute = attr;
        //atvc.detailsPreview = previewComponent;
    //}
    
    return atvc;
        
}



@end
