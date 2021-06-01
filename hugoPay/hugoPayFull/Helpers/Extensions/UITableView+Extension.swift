//
//  UITableView+Extesion.swift
//  Hugo
//
//  Created by Ali Gutierrez on 3/28/21.
//

import UIKit

extension UITableView {
    /// Dequeues a UITableViewCell with Type T
    /// Fatal error in case of invalid identifier so use carefully.
    /// - Parameter identifier: The reusable cell identifier
    /// - Parameter indexPath: indexPath for dequeue.
    func dequeueCell<T>(withIdentifier identifier: String, for indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Invalid or missing cell with type \(T.self)")
        }
        return cell
    }
}
