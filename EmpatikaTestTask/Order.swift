import Foundation
import Alamofire
import SwiftyJSON

enum OrderStatus { case New, Cancelled, ServedOut }
enum PaymentType { case Cash, CreditCard, App }

struct Order {
    
    let id: Int
    var amount: Int
    var title: String
    var status: OrderStatus
    var isDeliveryType: Bool
    var paymentType: PaymentType
    var time: String
    var date: String
    
    init(json: JSON) {
        switch json["status"].intValue {
        case 1:
            status = .New
        case 2, 3 :
            status = .Cancelled
        default:
            status = .ServedOut
        }
        
        if (json["delivery_type"].intValue == 2) {
            isDeliveryType = true
        }
        else {
            isDeliveryType = false
        }
        
        switch json["payment_type"].intValue {
        case 0:
            paymentType = .Cash
        case 1:
            paymentType = .App
        default:
            paymentType = .CreditCard
        }
        
        
        
        if isDeliveryType {
            title = json["address"]["formatted_address"].stringValue
        }
        else {
            title = json["venue"]["title"].stringValue
        }
       
        let fullTime = json["delivery_time_str"].stringValue.characters.split{$0 == " "}.map(String.init)
        time = String(fullTime[1].characters.prefix(5))
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        if let nsDate = formatter.dateFromString(fullTime[0]) {
            formatter.dateFormat = "dd.mm.yy"
            date = formatter.stringFromDate(nsDate)
        }
        else {
            date = "?"
        }
        
        amount = json["total"].intValue
        id = json["order_id"].intValue
        
        //TODO: количество позиций? еще доп?
    }
    
    private static let url = "http://testappall.1.doubleb-automation-production.appspot.com/api/history"
    
    static func loadOrders(errorBlock: ((String) -> Void), successBlock: ([Order] -> Void)) {
        Alamofire.request(.GET, url, parameters: ["client_id" : "33513"])
            .validate().responseJSON {
                response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    let orders = json["orders"].arrayValue.map {
                        orderJson in
                        return Order(json: orderJson)
                    }
                    
                    successBlock(orders)
                    
                case .Failure(_):
                    errorBlock("Не удалось загрузить данные о заказах")
                }
        }
    }
}