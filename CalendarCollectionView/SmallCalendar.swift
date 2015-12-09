//
//  SmallCalendar.swift
//  CalendarCollectionView
//
//  Created by JMariano on 10/17/14.
//  Copyright (c) 2014 JMariano. All rights reserved.
//

import UIKit

class SmallCalendar: NSObject, CalendarConfig {
    var itemSize : CGSize?
    
    override init(){
        itemSize = CGSizeMake(14, 14);
    }
    
    func getItemSize()->CGSize {
        return itemSize!;
    }
}
