//
//  UIButton+CenterImageAndTitle.swift
//  Piing user
//
//  Created by Veedepu Srikanth on 31/10/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import UIKit


extension UIButton
{
    func centerImageAndTitle(withImagePosition position:String, spacing:CGFloat)
    {
        if position == "TOP"
        {
            guard let imageSize = self.imageView?.image?.size else { return }
            
            self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0)
            
            guard let titleText = self.titleLabel?.text else { return }
            
            let titleSize = titleText.size(withAttributes: [NSAttributedStringKey.font : self.titleLabel!.font])
            self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width)
        }
        else if position == "BOTTOM"
        {
            guard let imageSize = self.imageView?.image?.size else { return }
            self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, imageSize.height + spacing, 0.0)
            
            guard let titleText = self.titleLabel?.text else { return }
            
            let titleSize = titleText.size(withAttributes: [NSAttributedStringKey.font : self.titleLabel!.font])
            self.imageEdgeInsets = UIEdgeInsetsMake(titleSize.height + spacing, 0.0, 0.0, -titleSize.width)
        }
        else if position == "LEFT"
        {
            
        }
        else if position == "RIGHT"
        {
            
        }
    }
}

//- (void)buttonImageAndTextWithImagePosition:(NSString *) strPosition WithSpacing:(float) spacing
//{
//
//    if ([strPosition isEqualToString:@"TOP"])
//    {
//        CGSize imageSize = self.imageView.image.size;
//        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
//
//        CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
//        self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
//    }
//    else if ([strPosition isEqualToString:@"BOTTOM"])
//    {
//        CGSize imageSize = self.imageView.image.size;
//        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, (imageSize.height + spacing), 0.0);
//
//        CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
//        self.imageEdgeInsets = UIEdgeInsetsMake((titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
//    }
//    else if ([strPosition isEqualToString:@"LEFT"])
//    {
//        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, spacing, 0.0, 0.0);
//    }
//    else if ([strPosition isEqualToString:@"RIGHT"])
//    {
//        self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
//        self.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
//        self.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
//
//        CGSize imageSize = self.imageView.image.size;
//
//        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - (imageSize.width), 0.0, 0.0);
//
//        self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - (imageSize.width + spacing), 0.0, 0.0);
//    }
//}

