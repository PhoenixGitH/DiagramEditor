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


@interface UserInfo : UIView <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>


@property NSArray *userData;
@property (weak, nonatomic) IBOutlet UITableView *table;

-(void) prepare;

@end


#endif /* UserInfo_h */
