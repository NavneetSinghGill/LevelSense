//
//  ProductDetailsCell.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

class ProductDetailsCell: UITableViewCell, ViewModelConfigurable {
    typealias ViewModelType = ProductViewModel
    
    @IBOutlet private weak var contentLabel: UILabel!
    
    var viewModel: ViewModelType?
    
    // ----------------------------------
    //  MARK: - Configure -
    //
    func configureFrom(_ viewModel: ViewModelType) {
        self.viewModel = viewModel
        
        /* ---------------------------------
         ** This lable is intended to render
         ** only styled text represented by
         ** HTML. It will not display embeded
         ** video or other complex HTML objects.
         */
        
        //TODO: uncomment
//        self.contentLabel.attributedText = viewModel.summary.interpretAsHTML(font: "Apple SD Gothic Neo", size: 17.0)
        do {
            
            //Replacing actually removes some unwanted characters
            var newString = viewModel.summary
            newString = newString.replacingOccurrences(of: "  ", with: " ")
            newString = newString.replacingOccurrences(of: "<p> </p>", with: "")
            let data = newString.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                 documentAttributes: nil)
                self.contentLabel.attributedText = str
                self.contentLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 17)
            }
        } catch {
            self.contentLabel.text = ""
        }
    }
}
