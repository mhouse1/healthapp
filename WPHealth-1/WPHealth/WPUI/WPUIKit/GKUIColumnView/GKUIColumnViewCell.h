//
//  JSTUIColumnViewCell.h
//
//  Create by Test Sup on 11/21/11
//  Copyright 2011 dreamblock.net. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GKUIColumnViewCell : UIView 
{	
	NSString			*reuseIdentifier;
	
    UIView              *_contentView;
	UIView				*backgroundView;
	UIView              *selectedBackgroundView;
	
	BOOL selected;
}

@property(nonatomic,readonly,copy) NSString			*reuseIdentifier;

@property(nonatomic, retain)UIView *contentView;
@property(nonatomic,retain) UIView					*backgroundView;
@property(nonatomic,retain) UIView                *selectedBackgroundView;

@property(nonatomic,getter=isSelected) BOOL         selected; 

- (id)initWithReuseIdentifier:(NSString *)identifier; 

@end
