//
//  GKUIColumnViewCell.m
//
//  Create by Test Sup on 11/21/11
//  Copyright 2011 dreamblock.net. All rights reserved.
//

#import "GKUIColumnViewCell.h"


@implementation GKUIColumnViewCell

@synthesize contentView = _contentView;
@synthesize backgroundView;
@synthesize selectedBackgroundView;
@synthesize selected;
@synthesize reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)identifier
{
	self = [super init];
	if (self)
	{
		reuseIdentifier = [[NSString alloc] initWithString:identifier];

		backgroundView = nil;
		selectedBackgroundView = nil;
		selected = NO;
	}
	
	return self;
}


- (void)setBackgroundView:(UIView *)bgView
{
	[backgroundView removeFromSuperview];
	backgroundView = nil;
	
	backgroundView = bgView;
	
	if(!selected)
	{
		[self addSubview:backgroundView];
		[self sendSubviewToBack:backgroundView];	
	}
}

- (UIView *)backgroundView
{
	if (!backgroundView) 
	{
		backgroundView = [[UIView alloc] init];
		
		[self addSubview:backgroundView];
		[self sendSubviewToBack:backgroundView];	
	}
	return backgroundView;
}

- (void)setSelectedBackgroundView:(UIView *)selectedBg
{
	[selectedBackgroundView removeFromSuperview];
	selectedBackgroundView = nil;
	
	selectedBackgroundView = selectedBg;
	
	if(selected)
	{
		[self addSubview:selectedBackgroundView];
		[self sendSubviewToBack:selectedBackgroundView];	
	}
}

- (UIView *)selectedBackgroundView
{
	if (!selectedBackgroundView) 
	{
		selectedBackgroundView = [[UIView alloc] init];
	}
	return selectedBackgroundView;
}

- (void)setSelected:(BOOL)select
{
	selected = select;
	
	if (select) 
	{
		[backgroundView removeFromSuperview];
		
		[self addSubview:selectedBackgroundView];
		[self sendSubviewToBack:selectedBackgroundView];	
	}
	else
	{
		[selectedBackgroundView removeFromSuperview];
		
		[self addSubview:backgroundView];
		[self sendSubviewToBack:backgroundView];	
	}	
}

- (void)setContentView:(UIView *)aContentView
{
    if(_contentView !=  aContentView)
    {
        [_contentView removeFromSuperview];
        _contentView = aContentView;
        
        [self addSubview:aContentView];
    }
    
}

- (BOOL)isSelected
{
	return selected;
}

- (void)dealloc 
{

}


@end