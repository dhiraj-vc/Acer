//
//  PatientDetialVM.swift
//  ASER
//
//  Created by jaspreet.bhatia on 1/15/19.
//  Copyright © 2019 Priti Sharma. All rights reserved.
//

import Foundation
import UIKit
class PatientDetialVM {
    
}
extension PatientDetialVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"PatientDetialTVC" , for: indexPath) as! PatientDetialTVC
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 40
        
    }
    
    
}
extension PatientDetialVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collVWReportsUpload.dequeueReusableCell(withReuseIdentifier:"PatientDetialCVC" , for: indexPath) as! PatientDetialCVC
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.height)
    }
}
