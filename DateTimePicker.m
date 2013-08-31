//
//  DateTimePicker.m
//  Heard Here
//
//  Created by Dianna Mertz on 8/13/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

// From http://stackoverflow.com/questions/6231587/iphone-adding-a-done-button-within-a-pop-up-datepicker-frame

#import "DateTimePicker.h"

#define MyDateTimePickerToolbarHeight 40

@interface DateTimePicker()

@property (nonatomic, assign, readwrite) UIDatePicker *picker;

@property (nonatomic, assign) id doneTarget;
@property (nonatomic, assign) SEL doneSelector;

- (void) donePressed;

@end


@implementation DateTimePicker

@synthesize picker = _picker;

@synthesize doneTarget = _doneTarget;
@synthesize doneSelector = _doneSelector;

- (id) initWithFrame: (CGRect) frame {
    if ((self = [super initWithFrame: frame])) {
        self.backgroundColor = [UIColor clearColor];
        
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0, MyDateTimePickerToolbarHeight, frame.size.width, frame.size.height - MyDateTimePickerToolbarHeight)];
        [self addSubview: picker];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, MyDateTimePickerToolbarHeight)];
        toolbar.barStyle = UIBarStyleBlackOpaque;
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleBordered target: self action: @selector(donePressed)];
        UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        toolbar.items = [NSArray arrayWithObjects:flexibleSpace, doneButton, nil];
        
        [self addSubview: toolbar];
        
        self.picker = picker;
        picker.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        self.picker.timeZone = [NSTimeZone localTimeZone];
        
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        
        [picker addTarget:self action:@selector(dateHasChanged:) forControlEvents:UIControlEventValueChanged];
    }
   
    return self;
}

-(NSString *)dateHasChanged:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    self.myDateString = [[NSString alloc] init];
    
    if (self.picker.datePickerMode == UIDatePickerModeDate) {
        //[formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setDateFormat:@"yyyy-MM-dd"];

    } else if (self.picker.datePickerMode == UIDatePickerModeTime) {
        [formatter setDateFormat:@"HH:mm"];
    }
    self.myDateString = [formatter stringFromDate:self.picker.date];
    
    return [self myDateString];
}

- (void) setMode: (UIDatePickerMode) mode {
    self.picker.datePickerMode = mode;
}

- (void) donePressed {
    if (self.doneTarget) {
        [self.doneTarget performSelector:self.doneSelector withObject:nil afterDelay:0];
    }
}

- (void) addTargetForDoneButton: (id) target action: (SEL) action {
    self.doneTarget = target;
    self.doneSelector = action;
}

-(void)dealloc
{
    self.picker = nil;
    self.myDateString = nil;
    self.doneTarget = nil;
    self.doneSelector = nil;
}

@end