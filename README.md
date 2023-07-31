# Neatly
A library to make creating autolayout constraints for multiple related views simpler and more elegant.

## Background
Autolayout APIs are great, as are DSL libs like SnapKit. There are, however, situations where you want to lay views out according to a regular pattern (e.g. in a stack or a grid), where these tools can be a bit heavyweight.

Neatly provides a simple and elegate DSL for laying multiple views out in a regular pattern, using autolayout constraints.

![Neatly](https://upload.wikimedia.org/wikipedia/commons/0/06/Colorful_Towels_%28Closeup%29.jpg)

## How to get it 

### Swift Package Manager

`.package(url:  "https://github.com/DomainGroupOSS/swift-neatly", from: "0.4.0")`

## Usage

### Stack

```swift
container.neatly
    .add(views: subviews)
    .with(format: .stack(
        axis: .vertical,
        spacing: 20,
        insets: insets)
)
```

```swift
container.neatly
    .add(views: subviews)
    .with(format: .stack(
        axis: .horizontal,
        spacing: 20,
        insets: insets)
)
```

### Table

```swift
container.neatly
    .add(views: subviews)
    .with(format: .table(
        columns: 3,
        horizontalSpacing: 10,
        verticalSpacing: 10,
        insets: insets)
)
```
