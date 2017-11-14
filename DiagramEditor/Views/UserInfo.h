//
//  UserInfo.h
//  DiagramEditor
//
//  Created by MISO on 3/5/17.
//  Copyright © 2017 DJavier. All rights reserved.
//

#ifndef UserInfo_h
#define UserInfo_h

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface UserInfo : UIView <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>


@property NSMutableArray *userData;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property AppDelegate *delegate;
@property CLLocation *location;
@property NSArray<ClassAttribute*> *userinfo;
@property bool isOwnData;

-(void) prepare: (AppDelegate *) delegate location: (CLLocation*) location andInfo: (NSArray<ClassAttribute*> *) userinfo andOwnData:
    (bool) isOwnData;

@end


#endif /* UserInfo_h */
