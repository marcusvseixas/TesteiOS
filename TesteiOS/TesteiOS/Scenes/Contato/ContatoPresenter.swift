//
//  ContatoPresenter.swift
//  TesteiOS
//
//  Created by marcus.v.seixas on 04/05/18.
//  Copyright (c) 2018 marcus.v.seixas. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ContatoPresentationLogic
{
  func presentSomething(response: Contato.Something.Response)
}

class ContatoPresenter: ContatoPresentationLogic
{
  weak var viewController: ContatoDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Contato.Something.Response)
  {
    let viewModel = Contato.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
