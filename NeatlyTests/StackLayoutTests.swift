//
//  UIViewLayoutExtensionsStackTests
//  Domain
//
//  Created by Sam.Warner on 6/07/2016.
//  Copyright © 2016 Fairfax Digital. All rights reserved.
//

import Quick
import Nimble
import UIKit
import Neatly

class StackLayoutTests: QuickSpec {
    
    override func spec() {
        
        describe("assumptions") {
            
            describe("before layout") {
                let superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
                let subviews = [UIView](count: 2) {
                    let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                    superview.addSubview(view)
                    return view
                }
                let installedConstraints = subviews.flatMap { $0.constraints } + superview.constraints
                
                it("should have no constraints") {
                    expect(installedConstraints.count) == 0
                }
            }
        }
        
        describe("layout(subviews:).with(format: .stack(.vertical") {
            
            describe("assumptions") {
                
                var superview: UIView!
                var subviews: [UIView]!
                
                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
                    subviews = [UIView](count: 2) {
                        let view = UIView()
                        superview.addSubview(view)
                        return view
                    }
                    superview.neatly.layout(subviews: subviews).with(format: .stack(axis: .vertical, spacing: 5, insets: UIEdgeInsets(5, on: .top)))
                }
                
                it("should add all constraints to the superview") {
                    let subviewConstraints = subviews.flatMap { $0.constraints }
                    expect(subviewConstraints).to(beEmpty())
                }
            }
            
            context("empty array") {
                var superview: UIView!
                
                var returnedBag: Layout.Bag<NSLayoutConstraint>!
                var installedConstraints: [NSLayoutConstraint]!
                
                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
                    returnedBag = superview.neatly.layout(subviews: []).with(format: .stack(axis: .vertical, spacing: 5, insets: UIEdgeInsets(5, on: .top)))
                    installedConstraints = superview.constraints
                }
                
                it("should not return constraints") {
                    expect(returnedBag.constraints).to(beEmpty())
                }
                
                it("should not install constraints") {
                    expect(installedConstraints).to(beEmpty())
                }
            }
            
            context("one subview") {
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
                    returnedBag = superview.neatly.layout(subviews: subviews).with(format: .stack(axis: .vertical, spacing: 5, insets: UIEdgeInsets(5, on: .top)))
                    installedConstraints = subviews.flatMap { $0.constraints } + superview.constraints
                }
                
                it("should have the expected number of returned constraints") {
                    expect(returnedBag.constraints).to(haveCount(4))
                }
                
                it("should have the expected number of installed constraints") {
                    expect(installedConstraints).to(haveCount(4))
                }
                
                pending("should return all installed constraints") {
                    expect(installedConstraints.count) == returnedBag.constraints.compactMap { c -> NSLayoutConstraint in c.isActive = true; return c }.count
                }
            }
            
            context("multiple subviews") {
                var superview: UIView!
                var subviews: [UIView]!
                
                var returnedBag: Layout.Bag<NSLayoutConstraint>!
                var installedConstraints: [NSLayoutConstraint]!
                
                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
                    subviews = [UIView](count: 4) {
                        let view = UIView()
                        superview.addSubview(view)
                        return view
                    }
                    returnedBag = superview.neatly.layout(subviews: subviews).with(format: .stack(axis: .vertical, spacing: 5, insets: UIEdgeInsets(5, on: .top)))
                    superview.layoutIfNeeded()                    
                    installedConstraints = subviews.flatMap { $0.constraints } + superview.constraints
                }
                
                it("should have the expected number of returned constraints") {
                    expect(returnedBag.constraints).to(haveCount(16))
                }
                
                it("should have the expected number of installed constraints") {
                    expect(installedConstraints).to(haveCount(16))
                }
                
                pending("should return all installed constraints") {
                    expect(installedConstraints.count) == returnedBag.constraints.compactMap { c -> NSLayoutConstraint in c.isActive = true; return c }.count
                }
                
                it("should have the expected number of left constraints") {
                    let leftConstraints = installedConstraints.filter { $0.firstAttribute == .left && $0.secondAttribute == .left }
                    expect(leftConstraints).to(haveCount(4))
                }
                
                it("should have the expected number of right constraints") {
                    let rightConstraints = installedConstraints.filter { $0.firstAttribute == .right && $0.secondAttribute == .right }
                    expect(rightConstraints).to(haveCount(4))
                }
                
                it("should have 1 top constraint") {
                    let topConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .top }
                    expect(topConstraints).to(haveCount(1))
                }
                
                it("should have the expected number of vertical spacing constraints") {
                    let verticalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .bottom }
                    expect(verticalSpacingConstraints).to(haveCount(3))
                }
                
                it("should have the correct vertical spacing") {
                    let verticalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .bottom }
                    let predicate: (NSLayoutConstraint?) -> Bool = { $0!.constant == 5 }
                    expect(verticalSpacingConstraints).to(allPass(predicate))
                }
                
                it("should have the expected number of lessThan bottom constraints") {
                    let subPredicate: (NSLayoutConstraint) -> Bool = { $0.firstAttribute == .bottom && $0.secondAttribute == .bottom }
                    let predicate: (NSLayoutConstraint) -> Bool = { subPredicate($0) && $0.relation == .lessThanOrEqual }
                    let bottomConstraints = installedConstraints.filter(predicate)
                    expect(bottomConstraints).to(haveCount(4))
                }
                
                it("should fit subviews to width") {
                    let predicate: (UIView?) -> Bool = { $0!.frame.width == 100 }
                    expect(subviews).to(allPass(predicate))
                }
            }
        }
        
        describe("layout(sizedSubviews: , layout: .stack(.vertical") {
            
            describe("assumptions") {
                
                var superview: UIView!
                var subviews: [UIView]!
                
                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
                    subviews = [UIView](count: 2) {
                        let view = UIView()
                        superview.addSubview(view)
                        return view
                    }
                    
                    superview.neatly.layout(sizedSubviews: subviews.map { SizedView(view: $0, height: 20) }).with(format: .stack(axis: .vertical, spacing: 5, insets: UIEdgeInsets(5, on: .top)))
                }
                
                it("should add edge constraints to the superview") {
                    expect(superview.constraints).to(haveCount(8))
                }
                
                it("should add height constraints to the subviews") {
                    let subviewConstraints = subviews.flatMap { $0.constraints }
                    expect(subviewConstraints).to(haveCount(2))
                }
                
                it("should add all constraints to the superview") {
                    let subviewConstraints = subviews.flatMap { $0.constraints }
                    let superviewConstraints = superview.constraints
                    expect(subviewConstraints).to(allPass({ !superviewConstraints.contains($0!) }))
                }
            }
            
            context("empty array") {
                var superview: UIView!
                
                var returnedBag: Layout.Bag<NSLayoutConstraint>!
                var installedConstraints: [NSLayoutConstraint]!
                
                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
                    returnedBag = superview.neatly.layout(sizedSubviews: []).with(format: .stack(axis: .vertical, spacing: 5, insets: UIEdgeInsets(5, on: .top)))
                    installedConstraints = superview.constraints
                }
                
                it("should not return constraints") {
                    expect(returnedBag.constraints).to(beEmpty())
                }
                
                it("should not install constraints") {
                    expect(installedConstraints).to(beEmpty())
                }
            }
            
            context("one subview") {
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
                    returnedBag = superview.neatly.layout(sizedSubviews: subviews.map { SizedView(view: $0, height: 20) }).with(format: .stack(axis: .vertical, spacing: 5, insets: UIEdgeInsets(5, on: .top)))
                    installedConstraints = subviews.flatMap { $0.constraints } + superview.constraints
                }
                
                it("should have the expected number of returned constraints") {
                    expect(returnedBag.constraints).to(haveCount(5))
                }
                
                it("should have the expected number of installed constraints") {
                    expect(installedConstraints).to(haveCount(5))
                }
                
                pending("should return all installed constraints") {
                    expect(installedConstraints.count) == returnedBag.constraints.compactMap { c -> NSLayoutConstraint in c.isActive = true; return c }.count
                }
            }
            
            context("multiple subviews") {
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
                    returnedBag = superview.neatly.layout(sizedSubviews: subviews.map { SizedView(view: $0, height: 20) }).with(format: .stack(axis: .vertical, spacing: 15, insets: UIEdgeInsets(15, on: .top)))
                    superview.layoutIfNeeded()
                    installedConstraints = subviews.flatMap { $0.constraints } + superview.constraints
                }
                
                it("should have the expected number of returned constraints") {
                    expect(returnedBag.constraints).to(haveCount(15))
                }
                
                it("should have the expected number of installed constraints") {
                    expect(installedConstraints).to(haveCount(15))
                }

                pending("should return all installed constraints") {
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
                    expect(verticalSpacingConstraints).to(haveCount(2))
                }
                
                it("should have the correct vertical spacing") {
                    let verticalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .bottom }
                    let predicate: (NSLayoutConstraint?) -> Bool = { $0!.constant == 15 }
                    expect(verticalSpacingConstraints).to(allPass(predicate))
                }
                
                it("should have the expected number of lessThan bottom constraints") {
                    let subPredicate: (NSLayoutConstraint) -> Bool = { $0.firstAttribute == .bottom && $0.secondAttribute == .bottom }
                    let predicate: (NSLayoutConstraint) -> Bool = { subPredicate($0) && $0.relation == .lessThanOrEqual }
                    let bottomConstraints = installedConstraints.filter(predicate)
                    expect(bottomConstraints).to(haveCount(3))
                }
                
                it("should have the expected number of height constraints") {
                    expect(installedConstraints.filter { $0.firstAttribute == .height }).to(haveCount(3))
                }
                
                it("should fit subviews to width") {
                    let predicate: (UIView?) -> Bool = { $0!.frame.width == 100 }
                    expect(subviews).to(allPass(predicate))
                }
                
                it("should apply subview height") {
                    let predicate: (UIView?) -> Bool = { $0!.frame.height == 20 }
                    expect(subviews).to(allPass(predicate))
                }
            }
        }

        describe("layout(subviews:).with(format: .stack(.horizontal") {

            describe("assumptions") {

                var superview: UIView!
                var subviews: [UIView]!

                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
                    subviews = [UIView](count: 2) {
                        let view = UIView()
                        superview.addSubview(view)
                        return view
                    }
                    superview.neatly.layout(subviews: subviews).with(format: .stack(axis: .horizontal, spacing: 5, insets: UIEdgeInsets(10, on: .left)))
                }

                it("should add all constraints to the superview") {
                    let subviewConstraints = subviews.flatMap { $0.constraints }
                    expect(subviewConstraints).to(beEmpty())
                }
            }

            context("empty array") {
                var superview: UIView!

                var returnedBag: Layout.Bag<NSLayoutConstraint>!
                var installedConstraints: [NSLayoutConstraint]!

                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
                    returnedBag = superview.neatly.layout(subviews: []).with(format: .stack(axis: .horizontal, spacing: 5, insets: UIEdgeInsets(10, on: .left)))
                    installedConstraints = superview.constraints
                }

                it("should not return constraints") {
                    expect(returnedBag.constraints).to(beEmpty())
                }

                it("should not install constraints") {
                    expect(installedConstraints).to(beEmpty())
                }
            }

            context("one subview") {
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
                    returnedBag = superview.neatly.layout(subviews: subviews).with(format: .stack(axis: .horizontal, spacing: 5, insets: UIEdgeInsets(10, on: .left)))
                    installedConstraints = subviews.flatMap { $0.constraints } + superview.constraints
                }

                it("should have the expected number of returned constraints") {
                    expect(returnedBag.constraints).to(haveCount(4))
                }

                it("should have the expected number of installed constraints") {
                    expect(installedConstraints).to(haveCount(4))
                }

                pending("should return all installed constraints") {
                    expect(installedConstraints.count) == returnedBag.constraints.compactMap { c -> NSLayoutConstraint in c.isActive = true; return c }.count
                }
            }

            context("multiple subviews") {
                var superview: UIView!
                var subviews: [UIView]!

                var returnedBag: Layout.Bag<NSLayoutConstraint>!
                var installedConstraints: [NSLayoutConstraint]!

                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
                    subviews = [UIView](count: 5) {
                        let view = UIView()
                        superview.addSubview(view)
                        return view
                    }
                    returnedBag = superview.neatly.layout(subviews: subviews).with(format: .stack(axis: .horizontal, spacing: 5, insets: UIEdgeInsets(10, on: .left)))
                    superview.layoutIfNeeded()
                    installedConstraints = subviews.flatMap { $0.constraints } + superview.constraints
                }

                it("should have the expected number of returned constraints") {
                    expect(returnedBag.constraints).to(haveCount(20))
                }

                it("should have the expected number of installed constraints") {
                    expect(installedConstraints).to(haveCount(20))
                }

                pending("should return all installed constraints") {
                    expect(installedConstraints.count) == returnedBag.constraints.compactMap { c -> NSLayoutConstraint in c.isActive = true; return c }.count
                }

                it("should have the expected number of top constraints") {
                    let leftConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .top }
                    expect(leftConstraints).to(haveCount(5))
                }

                it("should have the expected number of bottom constraints") {
                    let rightConstraints = installedConstraints.filter { $0.firstAttribute == .bottom && $0.secondAttribute == .bottom }
                    expect(rightConstraints).to(haveCount(5))
                }

                it("should have 1 left constraint") {
                    let topConstraints = installedConstraints.filter { $0.firstAttribute == .left && $0.secondAttribute == .left }
                    expect(topConstraints).to(haveCount(1))
                }

                it("should have the expected number of horizontal spacing constraints") {
                    let verticalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .left && $0.secondAttribute == .right }
                    expect(verticalSpacingConstraints).to(haveCount(4))
                }

                it("should have the correct horizontal spacing") {
                    let verticalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .bottom }
                    let predicate: (NSLayoutConstraint?) -> Bool = { $0!.constant == 5 }
                    expect(verticalSpacingConstraints).to(allPass(predicate))
                }

                it("should have the expected number of lessThan right constraints") {
                    let subPredicate: (NSLayoutConstraint) -> Bool = { $0.firstAttribute == .right && $0.secondAttribute == .right }
                    let predicate: (NSLayoutConstraint) -> Bool = { subPredicate($0) && $0.relation == .lessThanOrEqual }
                    let bottomConstraints = installedConstraints.filter(predicate)
                    expect(bottomConstraints).to(haveCount(5))
                }

                it("should fit subviews to height") {
                    let predicate: (UIView?) -> Bool = { $0!.frame.height == 500 }
                    expect(subviews).to(allPass(predicate))
                }
            }
        }

        describe("layout(sizedSubviews: , layout: .stack(.horizontal") {

            describe("assumptions") {

                var superview: UIView!
                var subviews: [UIView]!

                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
                    subviews = [UIView](count: 3) {
                        let view = UIView()
                        superview.addSubview(view)
                        return view
                    }

                    superview.neatly.layout(sizedSubviews: subviews.map { SizedView(view: $0, width: 20) }).with(format: .stack(axis: .horizontal, spacing: 5, insets: UIEdgeInsets(10, on: .left)))
                }

                it("should add edge constraints to the superview") {
                    expect(superview.constraints).to(haveCount(12))
                }

                it("should add height constraints to the subviews") {
                    let subviewConstraints = subviews.flatMap { $0.constraints }
                    expect(subviewConstraints).to(haveCount(3))
                }

                it("should add all constraints to the superview") {
                    let subviewConstraints = subviews.flatMap { $0.constraints }
                    let superviewConstraints = superview.constraints
                    expect(subviewConstraints).to(allPass({ !superviewConstraints.contains($0!) }))
                }
            }

            context("empty array") {
                var superview: UIView!

                var returnedBag: Layout.Bag<NSLayoutConstraint>!
                var installedConstraints: [NSLayoutConstraint]!

                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
                    returnedBag = superview.neatly.layout(sizedSubviews: []).with(format: .stack(axis: .horizontal, spacing: 5, insets: UIEdgeInsets(10, on: .left)))
                    installedConstraints = superview.constraints
                }

                it("should not return constraints") {
                    expect(returnedBag.constraints).to(beEmpty())
                }

                it("should not install constraints") {
                    expect(installedConstraints).to(beEmpty())
                }
            }

            context("one subview") {
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
                    returnedBag = superview.neatly.layout(sizedSubviews: subviews.map { SizedView(view: $0, width: 20) }).with(format: .stack(axis: .horizontal, spacing: 5, insets: UIEdgeInsets(10, on: .left)))
                    installedConstraints = subviews.flatMap { $0.constraints } + superview.constraints
                }

                it("should have the expected number of returned constraints") {
                    expect(returnedBag.constraints).to(haveCount(5))
                }

                it("should have the expected number of installed constraints") {
                    expect(installedConstraints).to(haveCount(5))
                }

                pending("should return all installed constraints") {
                    expect(installedConstraints.count) == returnedBag.constraints.compactMap { c -> NSLayoutConstraint in c.isActive = true; return c }.count
                }
            }

            context("multiple subviews") {
                var superview: UIView!
                var subviews: [UIView]!

                var returnedBag: Layout.Bag<NSLayoutConstraint>!
                var installedConstraints: [NSLayoutConstraint]!

                beforeEach {
                    superview = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 500))
                    subviews = [UIView](count: 4) {
                        let view = UIView()
                        superview.addSubview(view)
                        return view
                    }
                    returnedBag = superview.neatly.layout(sizedSubviews: subviews.map { SizedView(view: $0, width: 20) }).with(format: .stack(axis: .horizontal, spacing: 15, insets: UIEdgeInsets(15, on: .top)))
                    superview.layoutIfNeeded()
                    installedConstraints = subviews.flatMap { $0.constraints } + superview.constraints
                }

                it("should have the expected number of returned constraints") {
                    expect(returnedBag.constraints).to(haveCount(20))
                }

                it("should have the expected number of installed constraints") {
                    expect(installedConstraints).to(haveCount(20))
                }

                pending("should return all installed constraints") {
                    expect(installedConstraints.count) == returnedBag.constraints.compactMap { c -> NSLayoutConstraint in c.isActive = true; return c }.count
                }

                it("should have the expected number of top constraints") {
                    let leftConstraints = installedConstraints.filter { $0.firstAttribute == .top && $0.secondAttribute == .top }
                    expect(leftConstraints).to(haveCount(4))
                }

                it("should have the expected number of bottom constraints") {
                    let rightConstraints = installedConstraints.filter { $0.firstAttribute == .bottom && $0.secondAttribute == .bottom }
                    expect(rightConstraints).to(haveCount(4))
                }

                it("should have 1 left constraint") {
                    let topConstraints = installedConstraints.filter { $0.firstAttribute == .left && $0.secondAttribute == .left }
                    expect(topConstraints).to(haveCount(1))
                }

                it("should have the expected number of horizontal spacing constraints") {
                    let verticalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .left && $0.secondAttribute == .right }
                    expect(verticalSpacingConstraints).to(haveCount(3))
                }

                it("should have the correct horizontal spacing") {
                    let verticalSpacingConstraints = installedConstraints.filter { $0.firstAttribute == .left && $0.secondAttribute == .right }
                    let predicate: (NSLayoutConstraint?) -> Bool = { $0!.constant == 15 }
                    expect(verticalSpacingConstraints).to(allPass(predicate))
                }

                it("should have the expected number of lessThan right constraints") {
                    let subPredicate: (NSLayoutConstraint) -> Bool = { $0.firstAttribute == .right && $0.secondAttribute == .right }
                    let predicate: (NSLayoutConstraint) -> Bool = { subPredicate($0) && $0.relation == .lessThanOrEqual }
                    let bottomConstraints = installedConstraints.filter(predicate)
                    expect(bottomConstraints).to(haveCount(4))
                }

                it("should have the expected number of width constraints") {
                    expect(installedConstraints.filter { $0.firstAttribute == .width }).to(haveCount(4))
                }

                it("should fit subviews to height") {
                    let predicate: (UIView?) -> Bool = { $0!.frame.height == 485 }
                    expect(subviews).to(allPass(predicate))
                }

                it("should apply subview width") {
                    let predicate: (UIView?) -> Bool = { $0!.frame.width == 20 }
                    expect(subviews).to(allPass(predicate))
                }
            }
        }
    }
}
