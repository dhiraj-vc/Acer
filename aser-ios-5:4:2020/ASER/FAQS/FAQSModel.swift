
/**
 *
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author     : Shiv Charan Panjeta < shiv@toxsl.com >
 *
 * All Rights Reserved.
 * Proprietary and confidential :  All information contained herein is, and remains
 * the property of ToXSL Technologies Pvt. Ltd. and its partners.
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 */

import Foundation

class FAQSModel{
    var answer, question : String?
    func getFaqList(dictData: NSDictionary){
        answer = dictData["answer"] as? String ?? ""
        question = dictData["question"] as? String ?? ""
    }
}
