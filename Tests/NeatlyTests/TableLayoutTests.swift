//
//  TableLayoutTests
//  Domain
//
//  Created by Sam.Warner on 6/07/2016.
//  Copyright © 2016 Fairfax Digital. All rights reserved.
//

import Quick
import Nimble
import UIKit
import Neatly
    
class TableLayoutTests: QuickSpec {
    
    override func spec() {
        
        describe("layout(subviews:).with(format: .table") {
            
            context("empty array") {
                var superview: UIView!
                
                var returnedBag: Layout.Bag<NSLayoutConstraint>!
                var installedConstraints: [NSLayoutConstraint]!
                
                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
                    returnedBag = superview.neatly.layout(subviews: []).with(format: .table(columns: 2, horizontalSpacing: 0, verticalSpacing: 0, insets: .zero))
                    installedConstraints = superview.constraints
                }
                
                it("should not return constraints") {
                    expect(returnedBag.constraints).to(beEmpty())
                }
                
                it("should not install constraints") {
                    expect(installedConstraints).to(beEmpty())
                }
            }
            
            context("one subview, one column") {
                var superview: UIView!
                var subviews: [UIView]!
                
                var returnedBag: Layout.Bag<NSLayoutConstraint>!
                var installedConstraints: [NSLayoutConstraint]!
                
                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
                    subviews = [UIView](count: 1) {
                        let view = UIView()
                        superview.addSubview(view)
                        return view
                    }
                    returnedBag = superview.neatly.layout(subviews: subviews).with(format: .table(columns: 1, horizontalSpacing: 0, verticalSpacing: 0, insets: .zero))
                    superview.layoutIfNeeded()
                    installedConstraints = subviews.flatMap { $0.constraints } + superview.constraints
                }
                
                it("should have the expected number of returned constraints") {
                    expect(returnedBag.constraints).to(haveCount(5))
                }
                
                it("should have the expected number of installed constraints") {
                    expect(installedConstraints).to(haveCount(5))
                }
                
                it("should return all installed constraints") {
                    expect(installedConstraints.count) == returnedBag.constraints.compactMap { c -> NSLayoutConstraint in c.isActive = true; return c }.count
                }
                
                it("should have 1 left constraints") {
                    let leftConstraints = installedConstraints.filter { $0.firstAttribute == .left && $0.secondAttribute == .left }
                    expect(leftConstraints).to(haveCount(1))
                }
                
                it("should have 1 right constraints") {
                    let rightConstraints = installedConstraints.filter { $0.firstAttribute == .right && $0.secondAttribute == .right }
                    expect(rightConstraints).to(haveCount(1))
                }
                
                it("should have 1 top constraint") {
                    let topConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .top }
                    expect(topConstraints).to(haveCount(1))
                }
                
                it("should have 1 lessThan bottom constraints") {
                    let subPredicate: (NSLayoutConstraint) -> Bool = { $0.firstAttribute == .bottom && $0.secondAttribute == .bottom }
                    let predicate: (NSLayoutConstraint) -> Bool = { subPredicate($0) && $0.relation == .lessThanOrEqual }
                    let bottomConstraints = installedConstraints.filter(predicate)
                    expect(bottomConstraints).to(haveCount(1))
                }
                
                it("should fit subviews to width") {
                    let predicate: (UIView?) -> Bool = { $0!.frame.width == 100 }
                    expect(subviews).to(allPass(predicate))
                }
            }
            
            context("one subview, two columns") {
                var superview: UIView!
                var subviews: [UIView]!
                
                var returnedBag: Layout.Bag<NSLayoutConstraint>!
                var installedConstraints: [NSLayoutConstraint]!
                
                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
                    subviews = [UIView](count: 1) {
                        let view = UIView()
                        superview.addSubview(view)
                        return view
                    }
                    returnedBag = superview.neatly.layout(subviews: subviews).with(format: .table(columns: 2, horizontalSpacing: 0, verticalSpacing: 0, insets: .zero))
                    superview.layoutIfNeeded()
                    installedConstraints = subviews.flatMap { $0.constraints } + superview.constraints
                }
                
                it("should have the expected number of returned constraints") {
                    expect(returnedBag.constraints).to(haveCount(5))
                }
                
                it("should have the expected number of installed constraints") {
                    expect(installedConstraints).to(haveCount(5))
                }
                
                it("should return all installed constraints") {
                    expect(installedConstraints.count) == returnedBag.constraints.compactMap { c -> NSLayoutConstraint in c.isActive = true; return c }.count
                }
                
                it("should have 1 left constraints") {
                    let leftConstraints = installedConstraints.filter { $0.firstAttribute == .left && $0.secondAttribute == .left }
                    expect(leftConstraints).to(haveCount(1))
                }
                
                it("should have 1 right constraints") {
                    let rightConstraints = installedConstraints.filter { $0.firstAttribute == .right && $0.secondAttribute == .right }
                    expect(rightConstraints).to(haveCount(1))
                }
                
                it("should have 1 top constraint") {
                    let topConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .top }
                    expect(topConstraints).to(haveCount(1))
                }
                
                it("should have 1 lessThan bottom constraints") {
                    let subPredicate: (NSLayoutConstraint) -> Bool = { $0.firstAttribute == .bottom && $0.secondAttribute == .bottom }
                    let predicate: (NSLayoutConstraint) -> Bool = { subPredicate($0) && $0.relation == .lessThanOrEqual }
                    let bottomConstraints = installedConstraints.filter(predicate)
                    expect(bottomConstraints).to(haveCount(1))
                }
                
                it("should fit subviews to width") {
                    let predicate: (UIView?) -> Bool = { $0!.frame.width == 100 }
                    expect(subviews).to(allPass(predicate))
                }
            }
            
            context("multiple subviews, one column") {
                var superview: UIView!
                var subviews: [UIView]!
                
                var returnedBag: Layout.Bag<NSLayoutConstraint>!
                var installedConstraints: [NSLayoutConstraint]!
                
                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
                    subviews = [UIView](count: 3) {
                        let view = UIView()
                        superview.addSubview(view)
                        return view
                    }
                    returnedBag = superview.neatly.layout(subviews: subviews).with(format: .table(columns: 1, horizontalSpacing: 0, verticalSpacing: 20, insets: .zero))
                    superview.layoutIfNeeded()
                    installedConstraints = subviews.flatMap { $0.constraints } + superview.constraints
                }
                
                it("should have the expected number of returned constraints") {
                    expect(returnedBag.constraints).to(haveCount(17))
                }
                
                it("should have the expected number of installed constraints") {
                    expect(installedConstraints).to(haveCount(17))
                }
                
                it("should return all installed constraints") {
                    expect(installedConstraints.count) == returnedBag.constraints.compactMap { c -> NSLayoutConstraint in c.isActive = true; return c }.count
                }
                
                it("should have the expected number of left constraints") {
                    let leftConstraints = installedConstraints.filter { $0.firstAttribute == .left && $0.secondAttribute == .left }
                    expect(leftConstraints).to(haveCount(3))
                }
                
                it("should have the expected number of right constraints") {
                    let rightConstraints = installedConstraints.filter { $0.firstAttribute == .right && $0.secondAttribute == .right }
                    expect(rightConstraints).to(haveCount(3))
                }
                
                it("should have 1 top constraint") {
                    let topConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .top }
                    expect(topConstraints).to(haveCount(1))
                }
                
                it("should have the expected number of vertical spacing constraints") {
                    let verticalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .bottom }
                    expect(verticalSpacingConstraints).to(haveCount(4))
                }
                
                it("should have the correct vertical spacing") {
                    let verticalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .bottom }
                    let predicate: (NSLayoutConstraint?) -> Bool = { $0!.constant == 20 }
                    expect(verticalSpacingConstraints).to(allPass(predicate))
                }
                
                it("should have the expected number of lessThan bottom constraints") {
                    let subPredicate: (NSLayoutConstraint) -> Bool = { $0.firstAttribute == .bottom && $0.secondAttribute == .bottom }
                    let predicate: (NSLayoutConstraint) -> Bool = { subPredicate($0) && $0.relation == .lessThanOrEqual }
                    let bottomConstraints = installedConstraints.filter(predicate)
                    expect(bottomConstraints).to(haveCount(3))
                }
                
                it("should fit subviews to width") {
                    let predicate: (UIView?) -> Bool = { $0!.frame.width == 100 }
                    expect(subviews).to(allPass(predicate))
                }
            }
            
            context("multiple subviews, two columns, perfect distribution") {
                var superview: UIView!
                var subviews: [UIView]!
                
                var returnedBag: Layout.Bag<NSLayoutConstraint>!
                var installedConstraints: [NSLayoutConstraint]!
                
                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 105, height: 500))
                    subviews = [UIView](count: 4) {
                        let view = UIView()
                        superview.addSubview(view)
                        return view
                    }
                    returnedBag = superview.neatly.layout(subviews: subviews).with(format: .table(columns: 2, horizontalSpacing: 5, verticalSpacing: 3, insets: .zero))
                    superview.layoutIfNeeded()
                    installedConstraints = subviews.flatMap { $0.constraints } + superview.constraints
                }
                
                it("should have the expected number of returned constraints") {
                    expect(returnedBag.constraints).to(haveCount(30))
                }
                
                it("should have the expected number of installed constraints") {
                    expect(installedConstraints).to(haveCount(30))
                }
                
                it("should return all installed constraints") {
                    expect(installedConstraints.count) == returnedBag.constraints.compactMap { c -> NSLayoutConstraint in c.isActive = true; return c }.count
                }
                
                it("should have the expected number of left constraints") {
                    let leftConstraints = installedConstraints.filter { $0.firstAttribute == .left && $0.secondAttribute == .left }
                    expect(leftConstraints).to(haveCount(2))
                }
                
                it("should have the expected number of right constraints") {
                    let rightConstraints = installedConstraints.filter { $0.firstAttribute == .right && $0.secondAttribute == .right }
                    expect(rightConstraints).to(haveCount(2))
                }
                
                it("should have the expected number of horizontal spacing constraints") {
                    let horizontalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .left && $0.secondAttribute == .right }
                    expect(horizontalSpacingConstraints).to(haveCount(2))
                }
                
                it("should have the correct horizontal spacing") {
                    let horizontalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .left && $0.secondAttribute == .right }
                    let predicate: (NSLayoutConstraint?) -> Bool = { $0!.constant == 5 }
                    expect(horizontalSpacingConstraints).to(allPass(predicate))
                }
                
                it("should have 4 top constraints") {
                    let topConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .top }
                    expect(topConstraints).to(haveCount(4))
                }
                
                it("should have the expected number of vertical spacing constraints") {
                    let verticalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .bottom }
                    expect(verticalSpacingConstraints).to(haveCount(8))
                }
                
                it("should have the correct vertical spacing") {
                    let verticalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .bottom }
                    let predicate: (NSLayoutConstraint?) -> Bool = { $0!.constant == 3 }
                    expect(verticalSpacingConstraints).to(allPass(predicate))
                }
                
                it("should have the expected number of lessThan bottom constraints") {
                    let subPredicate: (NSLayoutConstraint) -> Bool = { $0.firstAttribute == .bottom && $0.secondAttribute == .bottom }
                    let predicate: (NSLayoutConstraint) -> Bool = { subPredicate($0) && $0.relation == .lessThanOrEqual }
                    let bottomConstraints = installedConstraints.filter(predicate)
                    expect(bottomConstraints).to(haveCount(4))
                }
                
                it("should fit subviews to width") {
                    let predicate: (UIView?) -> Bool = { $0!.frame.width == 50 }
                    expect(subviews).to(allPass(predicate))
                }
            }
            
            context("multiple subviews, three columns, imperfect distribution") {
                var superview: UIView!
                var subviews: [UIView]!
                
                var returnedBag: Layout.Bag<NSLayoutConstraint>!
                var installedConstraints: [NSLayoutConstraint]!
                
                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 312, height: 500))
                    subviews = [UIView](count: 8) {
                        let view = UIView()
                        superview.addSubview(view)
                        return view
                    }
                    returnedBag = superview.neatly.layout(subviews: subviews).with(format: .table(columns: 3, horizontalSpacing: 6, verticalSpacing: 22, insets: .zero))
                    superview.layoutIfNeeded()
                    installedConstraints = subviews.flatMap { $0.constraints } + superview.constraints
                }
                
                it("should have the expected number of returned constraints") {
                    expect(returnedBag.constraints).to(haveCount(79))
                }
                
                it("should have the expected number of installed constraints") {
                    expect(installedConstraints).to(haveCount(79))
                }
                
                it("should return all installed constraints") {
                    expect(installedConstraints.count) == returnedBag.constraints.compactMap { c -> NSLayoutConstraint in c.isActive = true; return c }.count
                }
                
                it("should have the expected number of left constraints") {
                    let leftConstraints = installedConstraints.filter { $0.firstAttribute == .left && $0.secondAttribute == .left }
                    expect(leftConstraints).to(haveCount(3))
                }
                
                it("should have the expected number of right constraints") {
                    let rightConstraints = installedConstraints.filter { $0.firstAttribute == .right && $0.secondAttribute == .right }
                    expect(rightConstraints).to(haveCount(3))
                }
                
                it("should have the expected number of horizontal spacing constraints") {
                    let horizontalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .left && $0.secondAttribute == .right }
                    expect(horizontalSpacingConstraints).to(haveCount(5))
                }
                
                it("should have the correct horizontal spacing") {
                    let horizontalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .left && $0.secondAttribute == .right }
                    let predicate: (NSLayoutConstraint?) -> Bool = { $0!.constant == 6 }
                    expect(horizontalSpacingConstraints).to(allPass(predicate))
                }
                
                it("should have the expected number of top constraint") {
                    let topConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .top }
                    expect(topConstraints).to(haveCount(8))
                }
                
                it("should have the expected number of vertical spacing constraints") {
                    let verticalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .bottom }
                    expect(verticalSpacingConstraints).to(haveCount(30))
                }
                
                it("should have the correct vertical spacing") {
                    let verticalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .bottom }
                    let predicate: (NSLayoutConstraint?) -> Bool = { $0!.constant == 22 }
                    expect(verticalSpacingConstraints).to(allPass(predicate))
                }
                
                it("should have the expected number of lessThan bottom constraints") {
                    let subPredicate: (NSLayoutConstraint) -> Bool = { $0.firstAttribute == .bottom && $0.secondAttribute == .bottom }
                    let predicate: (NSLayoutConstraint) -> Bool = { subPredicate($0) && $0.relation == .lessThanOrEqual }
                    let bottomConstraints = installedConstraints.filter(predicate)
                    expect(bottomConstraints).to(haveCount(8))
                }
                
                it("should fit first two rows of subviews to width") {
                    let predicate: (UIView?) -> Bool = { $0!.frame.width == 100 }
                    expect(subviews[0..<5]).to(allPass(predicate))
                }
                
                it("should fit last rows of subviews to width") {
                    let predicate: (UIView?) -> Bool = { $0!.frame.width == 153 }
                    expect(subviews[6..<8]).to(allPass(predicate))
                }
            }
        }
    }
}
