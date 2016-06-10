//
//  ViewController.swift
//  EmpatikaTestTask
//
//  Created by Михаил on 09.06.16.
//  Copyright © 2016 Mihail. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let orderCellId = "orderCell"
    let emptyMessage = "Потяните вниз для загрузки списка заказов"
    
    @IBOutlet weak var tableView: UITableView!
    
    var orders = [Order]()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Список заказов"
        refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(OrdersViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.delegate = self
        tableView.dataSource = self

        refresh(self)
    }
    
    func refresh(sender: AnyObject) {
        Order.loadOrders(showErrorAlert) {
            orders in
            self.orders = orders
            self.tableView.separatorStyle = .SingleLine
            self.tableView.separatorColor = UIColor.blackColor()
            self.tableView.backgroundView = nil
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orders.isEmpty {
            let messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            messageLabel.text = emptyMessage
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .Center
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel
            tableView.separatorStyle = .None
        }
        return orders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(orderCellId) as! OrderTableViewCell
        let order = orders[indexPath.row]
        
        
        let image = UIImage(named: String(order.status))
        cell.statusView.image = image
        cell.titleLabel.text = order.title
        cell.priceLabel.text = String(order.amount) + " ₽"
        cell.idLabel.text = "# " + String(order.id)
        if order.isDeliveryType {
            cell.deliveryView.image = UIImage(named: "Delivery")
        }
        else {
            cell.deliveryView.hidden = true
        }
        cell.timeLabel.text = order.time
        cell.dateLabel.text = order.date
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return orders[indexPath.row].status == OrderStatus.New
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    
        let cancelAction = UITableViewRowAction(style: .Default, title: "Отменить") {
            action in
            self.orders[indexPath.row].status = .Cancelled
            self.tableView.reloadData()
        }
        
        let serveAction = UITableViewRowAction(style: .Normal, title: "Обработать") {action in
            self.orders[indexPath.row].status = .ServedOut
            self.tableView.reloadData()
        }
        
        return [cancelAction, serveAction]
    }}

