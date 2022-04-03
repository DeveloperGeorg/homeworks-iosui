//
//  LoginViewControllerDelegateProtocol.swift
//  Navigation
//
//  Created by Георгий Бондаренко on 19.03.2022.
//

import Foundation


protocol LoginViewControllerDelegateProtocol {
    func checkCredentials(login: String, password: String) -> Bool
}
