//
//  MonthCalendar.swift
//  CalendarCollectionView
//
//  Created by JMariano on 10/17/14.
//  Copyright (c) 2014 JMariano. All rights reserved.
//

import UIKit

class MonthCalendar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let currentCalendar : NSCalendar = NSCalendar.currentCalendar()
    private var sampleDate : NSDate?
    private var calendarConfiguration : CalendarConfig?
    
    var layout: UICollectionViewFlowLayout?
    var dayCountInMonth : Int?
    var weekDay : Int?
    var firstDay : NSDate?
    var firstDayIndex : Int?
    var date : Int = 0
    var collectionViewFrame: CGRect?
    var dayMarker = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var collectionView : UICollectionView?
    
    //TODO: Collection view, cell subviews, parentcollectionview
    func configureCalendar(aSampleDate : NSDate, aCalendarConfig : CalendarConfig) {
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1
        self.calendarConfiguration = aCalendarConfig;
        self.sampleDate = aSampleDate
        
        let height = ceil(self.bounds.height/9)
        
        let monthLabel = UILabel()
        monthLabel.frame = CGRectMake(0, 0, self.bounds.width, height)
        monthLabel.text = getMonthName()
        monthLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(monthLabel)
        collectionViewFrame = CGRectMake(0, height, self.bounds.width, self.bounds.height - height)
        
        generateDataSet()
        configureViews()
    }
    
    func configureViews() {
        if layout == nil {
            layout = UICollectionViewFlowLayout()
            layout?.sectionInset = UIEdgeInsetsZero
            layout?.itemSize = CGSize(width: ceil(self.bounds.width/7.2), height: ceil(self.bounds.height/8.1))
            layout?.minimumInteritemSpacing = 0;
            layout?.minimumLineSpacing = 1;
        }
        
        if collectionView == nil {
            collectionView = UICollectionView(frame: collectionViewFrame!, collectionViewLayout: layout!)
            collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collectionView?.backgroundColor = UIColor.whiteColor()
            collectionView?.delegate = self;
            collectionView?.dataSource = self;
            self.addSubview(self.collectionView!)
        }
    }
    
    
    func generateDataSet () {
        self.dayCountInMonth = getDayCountInMonth()
        self.weekDay = getWeekday()
        self.firstDay = getFirstDay()
        let reservedCellsForDayMarker = 7
        let zeroBasedIndex = 1
        self.firstDayIndex = (self.weekDay! - zeroBasedIndex) + reservedCellsForDayMarker
    }
    
    //MARK: Private Helpers
    func getWeekday() -> Int {
        let calendar = NSCalendar.currentCalendar()

        let firstDayComponents = calendar.components( [NSCalendarUnit.Year , NSCalendarUnit.Month , NSCalendarUnit.Day , NSCalendarUnit.Weekday], fromDate: self.sampleDate!)
        return firstDayComponents.weekday
    }

    func getMonthName() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let monthName =  dateFormatter.stringFromDate(self.sampleDate!)

        return monthName
    }
    
    func getDayCountInMonth() -> Int {
        let days = currentCalendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: self.sampleDate!)
        return days.length
    }
    
    func getFirstDay() -> NSDate {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let components = gregorian!.components([NSCalendarUnit.Era, NSCalendarUnit.Year, NSCalendarUnit.Month , NSCalendarUnit.Weekday], fromDate: self.sampleDate!)
        components.day = 1
        return gregorian!.dateFromComponents(components)!
    }
    
    //MARK: UICollectionView DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 56;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        cell.contentView.backgroundColor = UIColor.lightGrayColor()
    
        var label : UILabel? = cell.contentView.viewWithTag(1) as? UILabel;
        
        if label == nil {
            let alabel : UILabel = UILabel();
            alabel.tag = 1;
            alabel.frame = cell.bounds;
            alabel.textAlignment = .Center;
            alabel.userInteractionEnabled = false;
            cell.contentView.addSubview(alabel)
            label = alabel
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap"))
        // 4
        cell.contentView.addGestureRecognizer(recognizer)
        
        if indexPath.row < 7 {
            label?.text = dayMarker[indexPath.row]
        }
        
        if indexPath.row >= self.firstDayIndex {
            if self.date < self.dayCountInMonth! {
                self.date++
                let stringValue = "\(self.date)"
                label?.text = String(stringValue)
            }
        }
        return cell;
    }
    
    func handleTap () {
        print("handleTap")
    }
    
    //Mark: UICollectionView Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("didSelectItemAtIndexPath")
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath){
        print("didHighlightItemAtIndexPath")
    }

}
