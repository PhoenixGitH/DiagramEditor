//
//  ComponentDetailsViewController.h
//  DiagramEditor
//
//  Created by Diego Vaquero Melchor on 9/12/15.
//  Copyright © 2015 Diego Vaquero Melchor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Component;
@class AppDelegate;


@interface ComponentDetailsView : UIView <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>{
    
    __weak IBOutlet UIView *previewComponentView;
    Component * previewComponent;
    __weak IBOutlet UILabel *typeLabel;
    
    __weak IBOutlet UIButton *searchButton;
    __weak IBOutlet UIButton *deleteButton;
    
    
    AppDelegate * dele;
    __weak IBOutlet UILabel *classLabel;
    

    __weak IBOutlet UIImageView *infoImage;
    __weak IBOutlet UITableView *table;

    
    NSMutableArray * connections;
    
    __weak IBOutlet UIView *blurView;
    UITapGestureRecognizer * tapgr;
    id delegate;
    __weak IBOutlet UIView *containerView;
}

@property (nonatomic, retain)id delegate;

@property Component * comp;

@property UIScrollView * scroll;
- (void)prepare: (bool)root;
- (IBAction)closeDetailsViw:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *background;

- (void)hideButtons;
- (void)showButtons;
- (void)hideInfo;
- (void)showInfo;

@end;

@protocol ComponentDetailsViewDelegate

@required
-(void)closeDetailsViewAndUpdateThings;


@end
