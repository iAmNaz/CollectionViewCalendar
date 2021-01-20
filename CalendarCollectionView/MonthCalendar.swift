//
//  MonthCalendar.swift
//  CalendarCollectionView
//
//  Created by JMariano on 10/17/14.
//  Copyright (c) 2014 JMariano. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class MonthCalendar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let currentCalendar : Calendar = Calendar.current
    fileprivate var sampleDate : Date?
    fileprivate var calendarConfiguration : CalendarConfig?
    
    var layout: UICollectionViewFlowLayout?
    var dayCountInMonth : Int?
    var weekDay : Int?
    var firstDay : Date?
    var firstDayIndex : Int?
    var date : Int = 0
    var collectionViewFrame: CGRect?
    var dayMarker = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var collectionView : UICollectionView?
    
    //TODO: Collection view, cell subviews, parentcollectionview
    @objc func configureCalendar(_ aSampleDate : Date, aCalendarConfig : CalendarConfig) {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.calendarConfiguration = aCalendarConfig;
        self.sampleDate = aSampleDate
        
        let height = ceil(self.bounds.height/9)
        
        let monthLabel = UILabel()
        monthLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: height)
        monthLabel.text = getMonthName()
        monthLabel.textAlignment = NSTextAlignment.center
        self.addSubview(monthLabel)
        collectionViewFrame = CGRect(x: 0, y: height, width: self.bounds.width, height: self.bounds.height - height)
        
        generateDataSet()
        configureViews()
    }
    
    func configureViews() {
        if layout == nil {
            layout = UICollectionViewFlowLayout()
            layout?.sectionInset = UIEdgeInsets.zero
            layout?.itemSize = CGSize(width: ceil(self.bounds.width/7.2), height: ceil(self.bounds.height/8.1))
            layout?.minimumInteritemSpacing = 0;
            layout?.minimumLineSpacing = 1;
        }
        
        if collectionView == nil {
            collectionView = UICollectionView(frame: collectionViewFrame!, collectionViewLayout: layout!)
            collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collectionView?.backgroundColor = UIColor.white
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
        let calendar = Calendar.current

        let firstDayComponents = (calendar as NSCalendar).components( [NSCalendar.Unit.year , NSCalendar.Unit.month , NSCalendar.Unit.day , NSCalendar.Unit.weekday], from: self.sampleDate!)
        return firstDayComponents.weekday!
    }

    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let monthName =  dateFormatter.string(from: self.sampleDate!)

        return monthName
    }
    
    func getDayCountInMonth() -> Int {
        let days = (currentCalendar as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self.sampleDate!)
        return days.length
    }
    
    func getFirstDay() -> Date {
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = (gregorian as NSCalendar).components([NSCalendar.Unit.era, NSCalendar.Unit.year, NSCalendar.Unit.month , NSCalendar.Unit.weekday], from: self.sampleDate!)
        components.day = 1
        return gregorian.date(from: components)!
    }
    
    //MARK: UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 56;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.lightGray
    
        var label : UILabel? = cell.contentView.viewWithTag(1) as? UILabel;
        
        if label == nil {
            let alabel : UILabel = UILabel();
            alabel.tag = 1;
            alabel.frame = cell.bounds;
            alabel.textAlignment = .center;
            alabel.isUserInteractionEnabled = false;
            cell.contentView.addSubview(alabel)
            label = alabel
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(MonthCalendar.handleTap))
        // 4
        cell.contentView.addGestureRecognizer(recognizer)
        
        if indexPath.row < 7 {
            label?.text = dayMarker[indexPath.row]
        }
        
        if indexPath.row >= self.firstDayIndex {
            if self.date < self.dayCountInMonth! {
                self.date += 1
                let stringValue = "\(self.date)"
                label?.text = String(stringValue)
            }
        }
        return cell;
    }
    
    @objc func handleTap () {
        print("handleTap")
    }
    
    //Mark: UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAtIndexPath")
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath){
        print("didHighlightItemAtIndexPath")
    }

}
